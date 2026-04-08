// Copyright (c) 2026 Pixxle SAS - LAI Project
// Licensed under the MIT License.

import { Component, ViewChild } from '@angular/core';
import { IonContent } from '@ionic/angular';

import { LaiService } from './services/lai.service';

interface ChatMessage {
  role: 'user' | 'assistant';
  text: string;
}

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
  providers: [LaiService]
})
export class AppComponent {
  @ViewChild(IonContent) content?: IonContent;

  messages: ChatMessage[] = [];
  inputMessage = '';
  modelReady = false;
  sending = false;

  constructor(private laiService: LaiService) {
    void this.init();
  }

  async init(): Promise<void> {
    await this.laiService.init();
    this.modelReady = this.laiService.isReady();
    this.addMessage('assistant', 'Bonjour ! Je suis LAI. Que veux-tu savoir ?');
  }

  async sendMessage(): Promise<void> {
    const value = this.inputMessage.trim();
    if (!value || this.sending) {
      return;
    }

    this.inputMessage = '';
    this.addMessage('user', value);

    this.sending = true;
    const placeholder: ChatMessage = { role: 'assistant', text: '...' };
    this.messages.push(placeholder);
    this.scrollToBottom();

    try {
      const response = await this.laiService.generateReply(value);
      placeholder.text = response;
    } catch (error) {
      const message = error instanceof Error ? error.message : 'Erreur inconnue';
      placeholder.text = `Erreur: ${message}`;
    } finally {
      this.sending = false;
      this.scrollToBottom();
    }
  }

  onEnter(event: KeyboardEvent): void {
    if (event.shiftKey) {
      return;
    }
    event.preventDefault();
    void this.sendMessage();
  }

  private addMessage(role: ChatMessage['role'], text: string): void {
    this.messages.push({ role, text });
    this.scrollToBottom();
  }

  private scrollToBottom(): void {
    setTimeout(() => {
      void this.content?.scrollToBottom(200);
    }, 50);
  }
}
