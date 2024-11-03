// src/app/utils/ZipUtil.ts

import archiver from 'archiver';
import * as fs from 'fs';

export function zipDirectory(sourceDir: string, zipFilePath: string): Promise<void> {
  return new Promise((resolve, reject) => {
    const output = fs.createWriteStream(zipFilePath);
    const archive = archiver('zip', { zlib: { level: 9 } });

    output.on('close', () => resolve());
	archive.on('error', (err: Error) => reject(err));

    archive.pipe(output);
    archive.directory(sourceDir, false);
    archive.finalize();
  });
}
