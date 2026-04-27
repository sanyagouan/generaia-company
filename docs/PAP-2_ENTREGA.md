# PAP-2 — Landing Page GeneraIA: Entrega

Estado: Completada (locked por run previo — no se pudo marcar done)
Fecha: 2026-04-27
Archivo principal: pap-2-landing/index.html

## Qué se hizo

Landing page profesional — una sola página HTML/CSS/JS, sin dependencias externas.
Dark theme, responsive, optimizada para conversión.

Secciones:
1. Nav — Logo + CTA "Hablar con nosotros"
2. Hero — "Tu empleado digital trabaja 24/7" + CTAs
3. Trust bar — 5 garantías
4. Problema / Solución — 2 cards lado a lado
5. Capacidades del agente — Grid de 6 tiles
6. Tabla comparativa — GeneraIA vs ChatGPT/Copilot
7. Caso de éxito En Las Nubes — Stats cuantitativos + quote
8. Paquetes — 3 cards (Starter €99, Professional €249 popular, Enterprise €599)
9. Onboarding — 5 pasos + timeline técnico
10. Formulario de contacto — funcional, con lead capture JS
11. Footer — email + Telegram

Decisiones de diseño:
- HTML/CSS/JS puro. No frameworks. No build step.
- Deployable en Cloudflare Pages, Netlify, Vercel o Hetzner.
- Dark mode — transmite tecnología/seguridad
- CTA: "Agendar discovery gratuito"
- Professional posicionado como "popular" con badge
- Precios incluyen coste infrastructure visible (genera confianza)

Para deployar localmente:
  cd pap-2-landing && python3 -m http.server 8080

Nota: Issue bloqueado por run anterior. Status no actualizable hasta que se libere el lock.
