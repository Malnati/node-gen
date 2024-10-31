
// src/generator-config.ts

import { IGeneratorConfig } from "./interfaces";
import { TComponents } from './types';

export class GeneratorConfig implements IGeneratorConfig{
	public app!: string;
	public templatesPath!: string;
	public schemaPath!: string;
    public outputDir!: string;
    public components!: TComponents;
    public scripts?: Record<string, string>;
    public dependencies?: Record<string, string>;
    public devDependencies?: Record<string, string>;

    constructor(_app: string, _templatesPath: string, _schemaPath: string, _outputDir: string, _components: TComponents, _scripts?: Record<string, string>, _dependencies?: Record<string, string>, _devDependencies?: Record<string, string>, dependencies?: Record<string, string>, devDependencies?: Record<string, string>) {
		this.app = _app;
		this.templatesPath = _templatesPath;
		this.schemaPath = _schemaPath;
		this.outputDir = _outputDir;
		this.components = _components;
		this.scripts = _scripts;
		this.dependencies = _dependencies;
		this.devDependencies = _devDependencies;
    }
}
