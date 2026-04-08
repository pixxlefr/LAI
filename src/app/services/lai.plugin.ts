// Copyright (c) 2026 Pixxle SAS - LAI Project
// Licensed under the MIT License.

import { registerPlugin } from '@capacitor/core';

export interface GenerateOptions {
  prompt: string;
  maxNewTokens?: number;
  temperature?: number;
  topK?: number;
  repetitionPenalty?: number;
}

export interface GenerateResult {
  text: string;
}

export interface LaiModelPlugin {
  load(): Promise<void>;
  generate(options: GenerateOptions): Promise<GenerateResult>;
}

export const LaiModel = registerPlugin<LaiModelPlugin>('LaiModel');
