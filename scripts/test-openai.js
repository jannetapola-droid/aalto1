require('dotenv').config();

const apiKey = process.env.OPENAI_API_KEY;
const model  = process.env.MODEL || 'gpt-4o-mini';

if (!apiKey) { console.error('OPENAI_API_KEY puuttuu .env-tiedostosta'); process.exit(1); }

(async () => {
  try {
    const res = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + apiKey
      },
      body: JSON.stringify({
        model,
        messages: [{ role: 'user', content: 'Pong?' }]
      })
    });

    if (!res.ok) {
      console.error('Virhe:', res.status, await res.text());
      process.exit(1);
    }

    const data = await res.json();
    console.log(data.choices?.[0]?.message?.content ?? data);
  } catch (err) {
    console.error('Poikkeus:', err?.message || err);
    process.exit(1);
  }
})();

