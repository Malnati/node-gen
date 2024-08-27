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
    try {
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
    } catch (error) {
      if (error instanceof Error) {
        console.error('Error generating diagram:', error.message);
      } else {
        console.error('Unknown error:', error);
      }
      throw error;
    }
  }

  private createSvgContent(): string {
    const tableWidth = 250;
    const baseHeight = 50;
    const rowHeight = 20;
    const padding = 50;

    // Calcular a altura máxima entre todas as tabelas
    const maxTableHeight = Math.max(...this.schema.map(table => baseHeight + table.columns.length * rowHeight));
    const width = 1300;
    const height = Math.max(
      800,
      this.schema.length * (maxTableHeight + padding) / 2
    );

    const tablesPerRow = Math.floor(width / (tableWidth + padding));

    // Iniciar SVG com fundo branco
    let svg = `<svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}">`;
    svg += `<rect width="100%" height="100%" fill="white"/>`;

    let x = padding;
    let y = padding;

    this.schema.forEach((table, index) => {
      svg += `<rect x="${x}" y="${y}" width="${tableWidth}" height="${maxTableHeight}" fill="lightgrey" stroke="black"/>`;
      svg += `<text x="${x + 10}" y="${y + 20}" font-family="Arial" font-size="12" font-weight="bold" fill="black">${table.tableName}</text>`;
      svg += `<line x1="${x}" y1="${y + 25}" x2="${x + tableWidth}" y2="${y + 25}" stroke="black" stroke-width="1"/>`;

      let columnY = y + 40;
      table.columns.forEach(column => {
        svg += `<text x="${x + 10}" y="${columnY}" font-family="Arial" font-size="10" fill="black">${column.columnName}: ${column.dataType}</text>`;
        columnY += rowHeight;
      });

      // Definir e desenhar pontos de ligação (azuis)
      const connectionPoints = this.getConnectionPoints(x, y, tableWidth, maxTableHeight);
      connectionPoints.forEach(point => {
        svg += `<circle cx="${point.x}" cy="${point.y}" r="3" fill="blue" />`;
      });

      // Escolher e desenhar um ponto de saída (vermelho)
      const sourcePoint = this.getSourcePoint(x, y, tableWidth, maxTableHeight);
      svg += `<circle cx="${sourcePoint.x}" cy="${sourcePoint.y}" r="5" fill="red" />`;

      if ((index + 1) % tablesPerRow === 0) {
        x = padding;
        y += maxTableHeight + padding;
      } else {
        x += tableWidth + padding;
      }
    });

    svg += `</svg>`;
    return svg;
  }

  // Pontos de ligação um pouco mais afastados
  private getConnectionPoints(x: number, y: number, width: number, height: number): { x: number, y: number }[] {
    const offset = 25; // Distância para afastar os pontos de ligação

    return [
      // Pontos nas bordas
      { x: x - offset, y: y + height / 2 }, // Left center
      { x: x + width + offset, y: y + height / 2 }, // Right center
      { x: x + width / 2, y: y - offset }, // Top center
      { x: x + width / 2, y: y + height + offset }, // Bottom center
      
      // Pontos nas quinas
      { x: x - offset, y: y - offset }, // Top-left
      { x: x + width + offset, y: y - offset }, // Top-right
      { x: x - offset, y: y + height + offset }, // Bottom-left
      { x: x + width + offset, y: y + height + offset } // Bottom-right
    ];
  }

  private getSourcePoint(x: number, y: number, width: number, height: number): { x: number, y: number } {
    const offset = 0; // Distância para afastar os pontos de ligação

    return { x: x + width + offset, y: y + height / 2 };
  }

  private async convertSvgToPng(svgContent: string, outputFilePath: string): Promise<void> {
    try {
      const buffer = Buffer.from(svgContent);
      await sharp(buffer)
        .png()
        .toFile(outputFilePath);
    } catch (error) {
      if (error instanceof Error) {
        console.error('Error converting SVG to PNG:', error.message);
      } else {
        console.error('Unknown error:', error);
      }
      throw error;
    }
  }
}
