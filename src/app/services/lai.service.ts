// Copyright (c) 2026 Pixxle SAS - LAI Project
// Licensed under the MIT License.

import { Injectable } from '@angular/core';
import { Capacitor } from '@capacitor/core';

import { LaiModel } from './lai.plugin';

type Language = 'fr' | 'en';

interface KBEntry {
  topic: string;
  keywords: string[];
  facts_fr: string;
  facts_en: string;
}

interface UserKnowledge {
  name?: string;
  preferences: string[];
  mood?: string;
}

interface ConversationContext {
  topic?: string;
  lastEntities: string[];
  turnCount: number;
}

const DEFAULT_KNOWLEDGE: UserKnowledge = {
  preferences: []
};

const DEFAULT_CONTEXT: ConversationContext = {
  lastEntities: [],
  turnCount: 0
};

@Injectable()
export class LaiService {
  private knowledgeBase: KBEntry[] = [];
  private userKnowledge: UserKnowledge = { ...DEFAULT_KNOWLEDGE };
  private context: ConversationContext = { ...DEFAULT_CONTEXT };
  private modelLoaded = false;

  async init(): Promise<void> {
    await this.loadKB();
    this.loadMemory();

    if (Capacitor.isNativePlatform()) {
      await LaiModel.load();
      this.modelLoaded = true;
    }
  }

  isReady(): boolean {
    return this.modelLoaded || !Capacitor.isNativePlatform();
  }

  async generateReply(message: string): Promise<string> {
    this.updateContext(message);

    const language = this.detectLanguage(message);
    const kbFact = this.searchKB(message, language);
    const facts = this.buildFacts(kbFact ? [kbFact] : []);

    const prompt = this.buildPrompt(message, facts);

    if (!Capacitor.isNativePlatform()) {
      return this.cleanResponse(`(Simulation web) Prompt: ${prompt}`);
    }

    const result = await LaiModel.generate({
      prompt,
      maxNewTokens: 50,
      temperature: 0.7,
      topK: 40,
      repetitionPenalty: 1.3
    });

    return this.cleanResponse(result.text);
  }

  private buildPrompt(message: string, facts: string): string {
    if (facts.trim().length > 0) {
      return `[USER] ${message} [FACTS] ${facts} [ANSWER]`;
    }
    return `[USER] ${message} [ANSWER]`;
  }

  private buildFacts(kbFacts: string[]): string {
    const facts: string[] = [];

    if (this.userKnowledge.name) {
      facts.push(`L'utilisateur s'appelle ${this.userKnowledge.name}.`);
    }

    if (this.userKnowledge.mood) {
      facts.push(`Humeur: ${this.userKnowledge.mood}.`);
    }

    if (this.context.topic) {
      facts.push(`Sujet: ${this.context.topic}.`);
    }

    facts.push(...kbFacts);

    return facts.join(' ');
  }

  private detectLanguage(text: string): Language {
    const frenchIndicators = [
      'quelle', 'quel', 'est', 'comment', 'pourquoi', 'je', 'tu', 'nous', 'bonjour'
    ];
    const lower = text.toLowerCase();
    for (const indicator of frenchIndicators) {
      if (lower.includes(indicator)) {
        return 'fr';
      }
    }
    return 'en';
  }

  private searchKB(query: string, language: Language): string | null {
    const normalized = this.normalize(query.toLowerCase());
    for (const entry of this.knowledgeBase) {
      for (const keyword of entry.keywords) {
        if (normalized.includes(this.normalize(keyword.toLowerCase()))) {
          return language === 'fr' ? entry.facts_fr : entry.facts_en;
        }
      }
    }
    return null;
  }

  private normalize(text: string): string {
    return text
      .replace(/l'/g, 'l ')
      .replace(/d'/g, 'd ')
      .replace(/j'/g, 'j ')
      .replace(/qu'/g, 'qu ')
      .replace(/’/g, "'");
  }

  private cleanResponse(response: string): string {
    let cleaned = response
      .replace(/\[USER\]/g, '')
      .replace(/\[ANSWER\]/g, '')
      .replace(/\[FACTS\]/g, '')
      .trim();

    cleaned = cleaned.replace(/\s+/g, ' ');
    return cleaned;
  }

  private updateContext(message: string): void {
    this.context.turnCount += 1;

    const name = this.extractName(message);
    if (name) {
      this.userKnowledge.name = name;
      this.persistMemory();
    }

    const preference = this.extractPreference(message);
    if (preference) {
      this.userKnowledge.preferences.push(preference);
      this.persistMemory();
    }

    const mood = this.extractMood(message);
    if (mood) {
      this.userKnowledge.mood = mood;
      this.persistMemory();
    }

    if (/capitale|capital|pays|country|population|habitants/i.test(message)) {
      this.context.topic = 'géographie';
    }
  }

  private extractName(message: string): string | null {
    const patterns = [
      /je m'appelle\s+([\p{L}'-]+)/iu,
      /je suis\s+([\p{L}'-]+)/iu,
      /my name is\s+([\p{L}'-]+)/iu
    ];
    for (const pattern of patterns) {
      const match = message.match(pattern);
      if (match?.[1]) {
        return this.capitalize(match[1]);
      }
    }
    return null;
  }

  private extractPreference(message: string): string | null {
    const match = message.match(/j'aime\s+(.+)/i);
    if (match?.[1]) {
      return match[1].trim();
    }
    return null;
  }

  private extractMood(message: string): string | null {
    const moods = ['content', 'triste', 'fatigué', 'fatigue', 'heureux'];
    const lower = message.toLowerCase();
    for (const mood of moods) {
      if (lower.includes(mood)) {
        return mood;
      }
    }
    return null;
  }

  private capitalize(value: string): string {
    return value.charAt(0).toUpperCase() + value.slice(1);
  }

  private async loadKB(): Promise<void> {
    try {
      const response = await fetch('assets/kb_simple.jsonl');
      const text = await response.text();
      const lines = text.split('\n').map((line) => line.trim()).filter(Boolean);
      this.knowledgeBase = lines.map((line) => JSON.parse(line));
    } catch {
      this.knowledgeBase = [];
    }
  }

  private loadMemory(): void {
    try {
      const stored = localStorage.getItem('lai_user_knowledge');
      if (stored) {
        this.userKnowledge = JSON.parse(stored);
      }
    } catch {
      this.userKnowledge = { ...DEFAULT_KNOWLEDGE };
    }
  }

  private persistMemory(): void {
    try {
      localStorage.setItem('lai_user_knowledge', JSON.stringify(this.userKnowledge));
    } catch {
      // ignore
    }
  }
}
