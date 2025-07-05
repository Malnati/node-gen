const fs = require('fs');
const path = require('path');
const files = process.argv.slice(2);
if (!files.length) {
  console.error('Usage: node add-path-comment.js <file> [file...]');
  process.exit(1);
}
for (const file of files) {
  let data = fs.readFileSync(file, 'utf8');
  let lines = data.split(/\r?\n/);
  if (lines[0] && lines[0].startsWith('#!')) {
    lines.shift();
  }
  const ext = path.extname(file);
  while (lines.length) {
    const line = lines[0].trim();
    if (line === '' || line.startsWith('//') || line.startsWith('<!--') || (ext !== '.md' && line.startsWith('#'))) {
      lines.shift();
    } else {
      break;
    }
  }
  let comment;
  if (['.ts', '.tsx', '.js', '.jsx', '.json', '.ejs'].includes(ext)) {
    comment = `// /${file}`;
  } else if (ext === '.md' || ext === '.html') {
    comment = `<!-- /${file} -->`;
  } else {
    comment = `# /${file}`;
  }
  lines.unshift(comment);
  fs.writeFileSync(file, lines.join('\n'), 'utf8');
  console.log('Updated', file);
}
