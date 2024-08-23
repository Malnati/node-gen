import { Table, DbReaderConfig, Format } from './interfaces';
import * as fs from 'fs';
import sharp from 'sharp';

export class DiagramGenerator {
  private schema: Table[];
  private config: DbReaderConfig;

  constructor(schemaPath: string, config: DbReaderConfig) {
    const schemaJson = fs.readFileSync(schemaPath, 'utf-8');
    const parsedSchema = JSON.parse(schemaJson);
    this.schema = parsedSchema.schema;
    this.config = config;
  }

  public async generateDiagram(outputFormat: Format = 'png'): Promise<void> {
    const svgContent = this.createSvgContent();
    const outputFilePath = `${this.config.outputDir}/public/diagram.${outputFormat}`;

    if (outputFormat === 'svg') {
      fs.writeFileSync(outputFilePath, svgContent);
      console.log(`SVG diagram generated at ${outputFilePath}`);
    } else if (outputFormat === 'png') {
      await this.convertSvgToPng(svgContent, outputFilePath);
      console.log(`PNG diagram generated at ${outputFilePath}`);
    } else {
      throw new Error('Unsupported format');
    }
  }

  private createSvgContent(): string {
    // Estime o tamanho com base no número de tabelas e colunas
    const numTables = this.schema.length;
    const numColumns = this.schema.reduce((acc, table) => acc + table.columns.length, 0);
    
    const tableWidth = 250;
    const tableHeight = 200;
    const padding = 50;

    const width = Math.max(800, numTables * (tableWidth + padding));
    const height = Math.max(600, numTables * (tableHeight + padding) + numColumns * 20);

    let svg = `<svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}">`;

    // Basic positioning values
    let x = 10;
    let y = 20;

    for (const table of this.schema) {
      svg += `<rect x="${x}" y="${y}" width="${tableWidth}" height="${tableHeight}" fill="lightgrey" stroke="black"/>`;
      svg += `<text x="${x + 10}" y="${y + 20}" font-family="Arial" font-size="12" fill="black">${table.tableName}</text>`;

      let columnY = y + 40;
      for (const column of table.columns) {
        svg += `<text x="${x + 10}" y="${columnY}" font-family="Arial" font-size="10" fill="black">${column.columnName}: ${column.dataType}</text>`;
        columnY += 20;
      }

      x += tableWidth + padding;  // Move to the next position
      if (x + tableWidth > width - padding) {  // Wrap to the next line if exceeding width
        x = 10;
        y += tableHeight + padding;
      }
    }

    svg += `</svg>`;
    return svg;
  }

  private async convertSvgToPng(svgContent: string, outputFilePath: string): Promise<void> {
    const buffer = Buffer.from(svgContent);
    await sharp(buffer)
      .png()
      .toFile(outputFilePath);
  }
}
