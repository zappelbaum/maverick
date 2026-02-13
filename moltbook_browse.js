import { browse } from './skills/b0tresch-stealth-browser/scripts/browser.js';

const result = await browse('https://www.moltbook.com', {
  text: true,
  timeout: 15000,
  waitForSelector: '.post-card, [data-post], article'
});

console.log(result.text);
