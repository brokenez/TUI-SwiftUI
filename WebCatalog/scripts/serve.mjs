import http from 'node:http';
import { createReadStream, existsSync, statSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const types = { '.html':'text/html; charset=utf-8', '.js':'text/javascript; charset=utf-8', '.css':'text/css; charset=utf-8', '.json':'application/json; charset=utf-8', '.png':'image/png', '.svg':'image/svg+xml', '.mp4':'video/mp4', '.md':'text/plain; charset=utf-8', '.txt':'text/plain; charset=utf-8', '.swift':'text/plain; charset=utf-8' };
const server = http.createServer((request, response) => {
  let pathname;
  try { pathname = decodeURIComponent(new URL(request.url, 'http://localhost').pathname); }
  catch { response.writeHead(400); response.end('Bad request'); return; }
  const publicRoot = pathname.startsWith('/src/') || pathname === '/' || pathname === '/index.html' ? root : path.join(root, 'public');
  const file = path.resolve(publicRoot, '.' + (pathname === '/' ? '/index.html' : pathname));
  if (!file.startsWith(publicRoot + path.sep) || !existsSync(file) || !statSync(file).isFile()) { response.writeHead(404); response.end('Not found'); return; }
  const size = statSync(file).size;
  const headers = { 'Content-Type': types[path.extname(file)] || 'application/octet-stream', 'Cache-Control': 'no-cache', 'X-Content-Type-Options':'nosniff' };
  const range = request.headers.range?.match(/^bytes=(\d+)-(\d*)$/);
  if (range) {
    const start = Number(range[1]), end = Math.min(range[2] ? Number(range[2]) : size - 1, size - 1);
    if (start > end || start >= size) { response.writeHead(416, {'Content-Range':`bytes */${size}`}); response.end(); return; }
    response.writeHead(206, {...headers, 'Content-Range':`bytes ${start}-${end}/${size}`, 'Content-Length':end-start+1, 'Accept-Ranges':'bytes'});
    createReadStream(file, {start, end}).pipe(response);
  } else { response.writeHead(200, {...headers, 'Content-Length':size, 'Accept-Ranges':'bytes'}); createReadStream(file).pipe(response); }
});
server.listen(Number(process.env.PORT || 4317), '127.0.0.1', () => console.log('TUI catalog: http://127.0.0.1:4317'));
