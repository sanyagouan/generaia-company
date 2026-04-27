---
name: generaia-playbook
description: Pipeline de onboarding de clientes, roadmap de ejecución, workers y operaciones de GeneraIA.
---

# GeneraIA Playbook — Pipeline y Roadmap de Ejecución

## Pipeline de Onboarding — De "Sí" a Funcionando

### FASE 0 — Preparación (una sola vez, ya hecha)

- ✅ Hetzner API Token operativo
- ✅ Cloudflare API Token operativo
- ✅ Registrar API para comprar dominios
- ✅ Coolify con integración Hetzner nativa (v4.0.0-beta.435+)
- ✅ Dominio generaia.org operativo con wildcard DNS

### FASE 1 — Cliente paga → Provisión automática

1. Stripe webhook recibe el pago
2. Crear servidor Hetzner vía API (CX33/CX43/CX53 según paquete)
3. Cloud-init instala Docker + Hermes + Coolify automáticamente
4. Server ready en ~2 minutos

### FASE 2 — Provisioning automático

1. Hermes se instala en modo nativo
2. Coolify se despliega (Docker)
3. Dentro de Coolify: OpenClaw + Uptime Kuma
4. Hermes se autoconfigura: sysadmin, monitoring, backups

### FASE 3 — DNS y Dominio

1. Registrar dominio vía Cloudflare Registrar (~1€/mes)
2. DNS wildcard: `*.cliente.com`
3. Traefik auto-genera SSL (Let's Encrypt)
4. **Cerrar puerto 8080** (solo 443 abierto)

### FASE 4 — Configuración del Bot

1. Crear Telegram bot para Santi/admin (BotFather API)
2. Desactivar privacy mode
3. Configurar WhatsApp Business (número dedicado)
4. Cargar knowledge base del negocio en OpenClaw
5. Instalar skills específicas del sector

### FASE 5 — Verificación y Entrega

1. Health check de todos los servicios
2. Test: enviar mensaje → respuesta correcta
3. Entregar credenciales al cliente

### ⚠️ Paso manual único

**OAuth de Google** — El cliente debe autorizar manualmente Gmail/Calendar/Drive. No automatizable.

## Seguridad del Servidor (implementar en TODOS)

| Medida | Config |
|--------|--------|
| SSH | Puerto 2222 (no 22), solo llaves SSH |
| fail2ban | 3 intentos SSH → ban 24h |
| Firewall UFW | Solo 2222/tcp, 80/tcp, 443/tcp, 443/udp |
| Traefik 8080 | CERRADO en producción |
| Coolify password | 32 chars auto-generado |
| API keys | chmod 600, rotación programada |
| Backups | Diarios locales + R2 (Cloudflare) |

## Credenciales Activas

### Cloudflare
- **API Token:** `cfut_***REDACTED***`
- **Account ID:** `f81ffc389aa3c402f2d405fabd229bc7`
- **Zonas activas:**
  - `generaia.org` (ID: e81c367098d7069f8d52af7b85a97ba0)
  - `enlasnubesrestobar.net` (ID: 5a4f9bc27466fa9fe423b85e7bedc47e)

### Hetzner
- API token configurado en Coolify

### Dominios — Extensiones más baratas
- `.org` = $7.50/año
- `.cc` = $8.00/año
- `.com` = $10.46/año

## Workers a Crear

Paperclip CEO debe crear estos workers especializados para ejecutar el pipeline:

### Worker 1: "Provisioner"
- Crea servidores Hetzner vía API
- Instala Docker + Hermes + Coolify via cloud-init
- **Budget:** $20/mes
- **Skills:** hetzner-api, cloudflare-api, hermes-install, coolify-docker-debug

### Worker 2: "Architect"
- Configura DNS, dominios, SSL
- Instala OpenClaw + Uptime Kuma
- Genera Telegram bot por cliente
- **Budget:** $20/mes
- **Skills:** cloudflare-registrar-dns-automation, openclaw-fresh-install, telegram-bot-privacy

### Worker 3: "QA Tester"
- Health check de todos los servicios post-onboarding
- Verifica que todo responde correctamente
- **Budget:** $10/mes
- **Skills:** openclaw-debug, hermes-gateway-restart, uptime-kuma

### Worker 4: "Sales Ops" (Nichos verticales)
- Prepara contenido por nicho (asesorías, inmobiliarias, dental)
- Skills específicas de cada sector
- Propuestas comerciales
- **Budget:** $30/mes
- **Skills:** blue-ocean-strategy, lean-startup, one-page-marketing, traction-eos

## Roadmap de Ejecución

### Semana 1: Definir producto base exacto
- Documentar paquetes, precios, márgenes con números reales
- Definir exactamente qué incluye cada paquete
- Validar con Santi

### Semana 2: Web de GeneraIA
- Landing page profesional
- Información de paquetes y precios
- Formulario de contacto
- Caso de estudio del piloto

### Semana 3: Materiales de venta
- One-pager (pitch de 1 página)
- Pricing sheet
- FAQ respondiendo objeciones
- Propuesta comercial template

### Semana 4: Proceso de onboarding
- Documentar pipeline end-to-end
- Identificar pasos manuales vs automáticos
- Minimizar intervención humana

### Semana 5+: Primer cliente real
- Convertir piloto "En Las Nubes" a cliente pagando
- Validar que el onboarding funciona sin asistencia
- Segundo cliente

## Reglas de operación

1. **UNA fase por semana.** Terminar completamente antes de pasar a la siguiente
2. **Investigación primero.** No ejecutar nada sin validar con fuentes primarias
3. **Verdad sin fantasías.** Si algo es imposible, decirlo
4. **Metodología:** definir → proponer → validar → ejecutar
5. **3 intentos fallidos** → paras y preguntas
6. **Silencio = todo bien.** No enviar reportes de "todo OK"
7. **Revenue is oxygen.** Cada decisión → "¿Esto nos acerca a un cliente pagando?"

## Documentos de referencia

| Documento | Ubicación | Contenido |
|-----------|-----------|-----------|
| Proyecto Maestro | `/root/.hermes/research/PROYECTO-MAESTRO.md` | Estado, roadmap, decisiones |
| Briefing Nichos | `/root/.hermes/research/BRIEFING-PAPERCLIP-ESPECIALIZACION-NICHOS-V3.md` | Nichos detallados con datos |
| Hermes Perfiles | `/root/.hermes/research/HERMES-PERFILES-CONFIG.md` | Config.yaml completa |
| Onboarding Pipeline | `/root/wiki/skills/onboarding-pipeline.md` | Pipeline end-to-end |
| GeneraIA Entity | `/root/wiki/entities/generaia.md` | Entity graph |

## Próximos pasos inmediatos

1. Definir producto base con absoluta precisión
2. Investigar y diseñar la web de GeneraIA
3. Documentar pipeline de onboarding end-to-end
