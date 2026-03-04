// gen/src/sspa-static-assets-generator.ts
import * as fs from 'fs';
import * as path from 'path';

import { renderTemplate } from './utils/TemplateEngine';

type SspaStaticTarget = {
  dir: string;
  name: string;
  title: string;
  version: string;
  isPaging: boolean;
};

export class SspaStaticAssetsGenerator {
  private readonly rootDir: string;

  constructor() {
    this.rootDir = path.resolve(__dirname, '..', '..');
  }

  sync(): void {
    const targets: SspaStaticTarget[] = [
      { dir: 'sspa-static/mfe-app', name: 'mfe-app', title: 'mfe-app', version: '0.0.0', isPaging: false },
      { dir: 'sspa-static/mfe-app-crud', name: 'mfe-app-crud', title: 'mfe-app-crud', version: '0.0.0', isPaging: false },
      { dir: 'sspa-static/mfe-parcel', name: 'mfe-parcel', title: 'mfe-parcel', version: '0.0.0', isPaging: false },
      { dir: 'sspa-static/mfe-parcel-create', name: 'mfe-parcel-create', title: 'mfe-parcel-create', version: '0.0.0', isPaging: false },
      { dir: 'sspa-static/mfe-parcel-create/mfe-app', name: 'mfe-app', title: 'mfe-app', version: '0.0.0', isPaging: false },
      { dir: 'sspa-static/mfe-parcel-delete', name: 'mfe-parcel-delete', title: 'mfe-parcel-delete', version: '0.0.0', isPaging: false },
      { dir: 'sspa-static/mfe-parcel-paging', name: 'mfe-parcel-paging', title: 'mfe-parcel-paging', version: '0.0.0', isPaging: true },
      { dir: 'sspa-static/mfe-parcel-retrieve', name: 'mfe-parcel-retrieve', title: 'mfe-parcel-retrieve', version: '0.0.0', isPaging: false },
      { dir: 'sspa-static/mfe-parcel-update', name: 'mfe-parcel-update', title: 'mfe-parcel-update', version: '0.0.0', isPaging: false },
      { dir: 'sspa-static/mfe-parcel-view', name: 'mfe-parcel-view', title: 'mfe-parcel-view', version: '0.0.0', isPaging: false },
    ];

    targets.forEach((target) => {
      const absoluteDir = path.join(this.rootDir, target.dir);
      if (!fs.existsSync(absoluteDir)) {
        return;
      }

      const packageJson = renderTemplate('sspa-static-package-json.ejs', {
        name: target.name,
        version: target.version,
        isPaging: target.isPaging,
      });
      const indexHtml = renderTemplate('sspa-static-index-html.ejs', {
        title: target.title,
      });
      const readme = renderTemplate('sspa-static-readme.ejs', {
        title: target.title,
        version: target.version,
      });

      fs.writeFileSync(path.join(absoluteDir, 'package.json'), packageJson);
      fs.writeFileSync(path.join(absoluteDir, 'index.html'), indexHtml);
      fs.writeFileSync(path.join(absoluteDir, 'README.md'), readme);
    });
  }
}
