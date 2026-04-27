# GeneraIA — Onboarding Pipeline End-to-End

> Version: 1.0 | Status: Draft | Fecha: 2026-04-27 | Autor: CEO GeneraIA

---

## Overview

Este documento describe el pipeline completo de onboarding de un nuevo cliente GeneraIA,
desde el pago hasta que el agente entra en producción. Cada paso indica si es
AUTOMATICO o MANUAL y quien es responsable.

---

## Mapa General

```
Cliente paga (Stripe)
        │
        ▼
  [1] Provisioning Hetzner  ◄── AUTOMATICO
        │
        ▼
  [2] Instalacion Stack  ◄── AUTOMATICO (Coolify)
        │
        ▼
  [3] DNS + SSL  ◄── AUTOMATICO / SEMI-AUTO
        │
        ▼
  [4] Config Agente + Integraciones  ◄── MANUAL (CEO GeneraIA)
        │
        ▼
  [5] QA + Verificacion  ◄── MANUAL (CEO GeneraIA)
        │
        ▼
  [6] Entrega al cliente  ◄── MANUAL
```

**Tiempo total estimado: 5-10 dias laborables**
**Automatizacion parcial: pasos 1-3 automaticos, pasos 4-6 manuales**

---

## Paso 1: Pago via Stripe

**Tipo:** MANUAL (el cliente inicia) / AUTOMATICO (procesamiento)

### Proceso:
1. Cliente selecciona pack en la web o via propuesta comercial
2. Se crea invoice Stripe manualmente o via link de pago
3. Cliente paga (tarjeta, transferencia via Stripe Link)
4. Stripe envia webhook `invoice.paid` o `checkout.session.completed`

### Webhook recibido:
```json
{
  "type": "checkout.session.completed",
  "data": {
    "object": {
      "id": "cs_xxx",
      "customer_email": "cliente@empresa.com",
      "metadata": {
        "pack": "professional",
        "company_name": "En Las Nubes SL"
      }
    }
  }
}
```

### Datos capturados:
- Email del cliente
- Pack contratado
- Nombre de empresa
- Fecha de pago
- ID de transaccion Stripe

### Responsable: Stripe (automatico) + CEO GeneraIA (verificacion)

### Siguiente paso automatico: Trigger provisioning Hetzner via webhook o script

---

## Paso 2: Provisioning Automatico en Hetzner

**Tipo:** AUTOMATICO
**Herramienta:** Hetzner Cloud API + script de provisioning
**Responsable:** Sistema automatico (trigger: webhook Stripe)

### Servidores por Pack:

| Pack | Modelo Hetzner | vCPU | RAM | SSD | Coste |
|------|---------------|------|-----|-----|-------|
| Starter | CX11 | 2 | 4 GB | 40 GB | ~EUR 4.99/mo |
| Professional | CX21 | 2 | 8 GB | 80 GB | ~EUR 7.49/mo |
| Enterprise | CX22 | 4 | 16 GB | 160 GB | ~EUR 14.99/mo |

### Script de provisioning (pseudocodigo):

```bash
# 1. Crear servidor Hetzner via API
POST https://api.hetzner.cloud/v1/servers
{
  "name": "generaia-{company_slug}-{timestamp}",
  "server_type": "cx21",           # según pack
  "location": "fsn1",              # onb1, hel1, etc.
  "image": "ubuntu-22.04",
  "ssh_keys": [{"name": "generaia-provisioning"}],
  "user_data": "#cloud-config\nruncmd:\n  - bash /root/provision.sh"
}

# 2. Esperar que el servidor este activo
GET /servers/{id}
# status: "running"

# 3. Obtener IP publica
# response.server.public_net.ipv4.ip

# 4. Guardar en base de datos/cliente
# { company_id, server_id, ipv4, pack, status: provisioning }
```

###cloud-config (user_data):
```yaml
#cloud-config
package_update: true
packages:
  - curl
  - git
  - docker
  - docker-compose
runcmd:
  - bash <(curl -fsSL https://get.coollabs.io/coolify/install.sh)
  - systemctl enable --now coolify
  - ufw allow 80/tcp
  - ufw allow 443/tcp
  - ufw allow 22/tcp
```

### Checklist de verificacion:
- [ ] Servidor creado en Hetzner
- [ ] Status: "running"
- [ ] IP publica registrada
- [ ] Coolify accesible en http://IP:8000
- [ ] SSH accesible en puerto 22

### Tiempo estimado: 3-7 minutos

---

## Paso 3: Instalacion del Stack Tecnologico

**Tipo:** AUTOMATICO (Coolify orchestrates)
**Responsable:** Coolify

### Stack completo por cliente:

```
┌─────────────────────────────────────────┐
│           VPS Hetzner (cliente)          │
│                                          │
│  ┌──────────────┐  ┌──────────────────┐ │
│  │   Coolify    │  │    Docker        │ │
│  │  (Management │  │                  │ │
│  │   UI/API)    │  │  ┌────────────┐  │ │
│  │  :8000       │  │  │  Hermes     │  │ │
│  └──────────────┘  │  │  Agent      │  │ │
│                     │  │  :3100      │  │ │
│                     │  └────────────┘  │ │
│                     │                  │ │
│                     │  ┌────────────┐  │ │
│                     │  │  OpenClaw   │  │ │
│                     │  │  Agent      │  │ │
│                     │  └────────────┘  │ │
│                     │                  │ │
│                     │  ┌────────────┐  │ │
│                     │  │  Postgres   │  │ │
│                     │  │  (state)    │  │ │
│                     │  └────────────┘  │ │
│                     │                  │ │
│                     │  ┌────────────┐  │ │
│                     │  │  Redis      │  │ │
│                     │  │  (cache)   │  │ │
│                     │  └────────────┘  │ │
│                     └──────────────────┘ │
└─────────────────────────────────────────┘
```

### Instalacion via Coolify:

Coolify maneja el deploy de cada componente via docker-compose.
Configuramos un "project" en Coolify por cliente:

```yaml
# coolify-project.yaml (por cliente)
name: generaia-{company_slug}
services:
  hermes:
    image: ghcr.io/nousresearch/hermes-agent:latest
    ports:
      - "3100:3100"
    environment:
      - API_BASE_URL=http://localhost:3100
      - PAPERCLIP_API_KEY=${PAPERCLIP_API_KEY}
      - LLM_PROVIDER=${LLM_PROVIDER}
      - LLM_API_KEY=${LLM_API_KEY}
    volumes:
      - hermes_data:/home/paperclip/.hermes
    restart: unless-stopped

  openclaw:
    image: ghcr.io/nousresearch/openclaw:latest
    environment:
      - HERMES_URL=http://hermes:3100
    depends_on:
      - hermes
    restart: unless-stopped

  postgres:
    image: postgres:16-alpine
    environment:
      - POSTGRES_DB=generaia
      - POSTGRES_USER=generaia
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data
    restart: unless-stopped
```

### DNS + SSL:

**Tipo:** SEMI-AUTOMATICO

```bash
# 1. Crear registro DNS en Cloudflare (via API)
POST https://api.cloudflare.com/client/v4/zones/{zone_id}/dns_records
{
  "type": "A",
  "name": "agente.{company_domain}",
  "content": "{server_ipv4}",
  "proxied": true
}

# 2. Esperar propagacion DNS (1-5 min)

# 3. Generar SSL automatico via Let's Encrypt (Coolify lo hace)
# Accesible via: https://agente.{company_domain}

# 4. Para pack Enterprise: certificado wildcard o dedicado
# Via: certbot --manual --preferred-challenges=dns
```

### Checklist de verificacion:
- [ ] Coolify proyecto creado
- [ ] Hermes arrancado y accesible
- [ ] Postgres inicializado con schema
- [ ] Redis arrancado
- [ ] DNS propagado
- [ ] SSL activo (Let's Encrypt via Coolify)
- [ ] URL accesible: https://agente.{dominio}

### Tiempo estimado: 5-15 minutos

---

## Paso 4: Configuracion del Agente + Integraciones

**Tipo:** MANUAL
**Responsable:** CEO GeneraIA
**Herramientas:** terminal, navegador, Paperclip API

### 4a. Configurar Agente Hermes en el servidor del cliente

Conectar al servidor via SSH y configurar:

```bash
# Conectar al servidor del cliente
ssh root@agente.{company_domain}

# Configurar credenciales del cliente
cd ~/.hermes
nano .env

# Variables necesarias:
# - PAPERCLIP_API_KEY (credencial del agente en la plataforma)
# - LLM_API_KEY (OpenRouter, Anthropic, etc.)
# - Database connection string
# - Redis URL
# - Telegram bot token (si aplica)

# Reiniciar servicios
cd /opt/coolify
docker compose restart hermes
```

### 4b. Configurar integraciones especificas del cliente

Segun el pack y las necesidades del cliente:

**Integracion Email:**
- IMAP/SMTP para recibir emails
- O auth con Gmail/Outlook si disponible
- Reglas de filtro para emails relevantes

**Integracion Calendario:**
- Google Calendar API o CalDAV
- Microsoft Graph para Office 365
- Configurar credenciales del cliente

**Integracion CRM:**
- API key del CRM del cliente (HubSpot, Pipedrive, etc.)
- Webhook para actualizaciones entrantes

**Integracion Telegram:**
```bash
# Crear bot Telegram para el cliente
# 1. Cliente crea bot via @BotFather
# 2. Obtener bot token
# 3. Configurar en el agente:

cat >> ~/.hermes/.env << EOF
TELEGRAM_BOT_TOKEN=123456:ABC-DEF
TELEGRAM_CHAT_ID={cliente_chat_id}
EOF
```

### 4c. Personalizar instrucciones del agente

```bash
# Crear archivo de contexto del cliente
mkdir -p ~/.hermes/profiles/{company_slug}
cat > ~/.hermes/profiles/{company_slug}/system_prompt.md << 'EOF'
# Perfil del Cliente: {Nombre Empresa}

## Sobre la empresa
{descripcion, sector, tamano, ubicacion}

## Procesos a automatizar
1. {tarea 1}: {detalle}
2. {tarea 2}: {detalle}

## Integraciones activas
- Email: {cuenta}
- Calendario: {cuenta}
- CRM: {sistema}

## Tone de comunicacion
{formal/informal, idioma, الخصوص}

## Contactos clave
- {nombre}: {rol}, {email}
EOF

# Reiniciar agente para aplicar cambios
docker restart hermes
```

### Checklist de verificacion:
- [ ] Credenciales configuradas en .env
- [ ] Integraciones probadas individualmente
- [ ] Sistema de prompts personalizado
- [ ] Agente responde correctamente
- [ ] Telegram conectado (si aplica)

### Tiempo estimado: 1-3 horas (segun complejidad de integraciones)

---

## Paso 5: QA y Verificacion

**Tipo:** MANUAL
**Responsable:** CEO GeneraIA

### Checklist de QA completo:

#### 5a. Verificacion de conectividad
```bash
# Desde el servidor:
curl -s http://localhost:3100/health
# Esperado: {"status":"ok"}

curl -s https://agente.{dominio}/api/health
# Esperado: 200 OK

# Probar integraciones:
curl -s http://localhost:3100/api/integrations/email/test
curl -s http://localhost:3100/api/integrations/calendar/test
```

#### 5b. Test de escenario real
Ejecutar las tareas principales que el agente debera hacer:

- [ ] Recibir un email de prueba y generar respuesta adecuada
- [ ] Crear un evento en el calendario
- [ ] Actualizar el CRM con datos de prueba
- [ ] Responder una pregunta de FAQ
- [ ] Enviar un reporte de prueba

#### 5c. Test de seguridad
- [ ] SSL valido (https://www.ssllabs.com/ssltest/)
- [ ] Puertos abiertos correctamente (solo 80, 443, 22)
- [ ] No exponer puertos internos (3100, 5432, 6379)
- [ ] Credenciales no hardcodeadas en codigo publicable
- [ ] Rate limiting activo

#### 5d. Test de resistencia
- [ ] Agente sobrevive a reinicio del servidor
- [ ] Datos persisten tras reinicio
- [ ] Backup automatico funcionando

#### 5e. Documentacion para el cliente
- [ ] Credenciales de acceso entregadas
- [ ] Guia de uso basica
- [ ] Canales de soporte documentados
- [ ] SLA segun pack contratado

### Registro de QA:

```
Fecha QA: {fecha}
QA por: CEO GeneraIA
Resultado: PASS / FAIL / CONDITIONAL

Issues encontrados:
1. {issue} -> {solucion}
2. ...

Firma de aprobacion: _______________
```

### Tiempo estimado: 3-5 dias laborables (QA real en entorno del cliente)

---

## Paso 6: Entrega al Cliente

**Tipo:** MANUAL
**Responsable:** CEO GeneraIA

### Checklist de entrega:

#### Comunicacion:
- [ ] Email de entrega con:
  - URL del agente
  - Credenciales de acceso
  - Enlace a documentacion
  - Contacto de soporte

#### Contenido del email de entrega:
```
Asunto: Tu empleado digital GeneraIA esta listo — [Nombre Empresa]

Hola {nombre},

Tu agente IA ya esta funcionando. Aqui tienes todo lo que necesitas saber:

ACCESO
Agente: https://agente.{dominio}
Telegram: @{bot_username}

INTEGRACIONES ACTIVAS
- Email: {cuenta}
- Calendario: {cuenta}
- CRM: {sistema}

PRIMEROS PASOS
1. Abre el enlace y presentate al agente
2. Proba pedirle algo sencillo
3. Revisamos juntos en 3 dias para ajustes

SOPORTE
- Email: hola@generaia.site
- Telegram directo: {segun pack}

Proximo check-in: {fecha + 3 dias}

Bienvenido a GeneraIA!
El equipo
```

#### Seguimiento:
- Agenda una llamada de seguimiento a los 3-5 dias
- Agenda revision semanal durante el primer mes (pack Professional/Enterprise)
- Crea recordatorio para renewal a los 11 meses

### Tiempo estimado: 30 minutos (comunicacion)

---

## Resumen: Automatico vs Manual

| Paso | Tipo | Tiempo | Responsable |
|------|------|--------|-------------|
| 1. Pago Stripe | MANUAL+AUTO | 2-5 min | Cliente + Sistema |
| 2. Provisioning Hetzner | AUTOMATICO | 3-7 min | Sistema |
| 3. Instalacion Stack | AUTOMATICO | 5-15 min | Coolify |
| 3b. DNS + SSL | SEMI-AUTO | 5-10 min | Sistema |
| 4. Config agente | MANUAL | 1-3 horas | CEO GeneraIA |
| 5. Integraciones | MANUAL | 2-4 horas | CEO GeneraIA |
| 6. QA | MANUAL | 3-5 dias | CEO GeneraIA |
| 7. Entrega | MANUAL | 30 min | CEO GeneraIA |

**Total tiempo humano: ~5-10 dias laborables**

---

## Automatizaciones pendientes (roadmap)

1. **Webhook Stripe → Hetzner provisioning**: Script que recibe el webhook y lanza la creacion del servidor
2. **Coolify API para project creation**: Automatizar la creacion del proyecto Coolify con el docker-compose
3. **Config Agente via API**: Endpoint Paperclip para recibir config del cliente y auto-configurar Hermes
4. **QA automatizado**: Suite de tests que corra tras cada deploy y reporte resultados
5. **Dashboard de monitoreo**: Grafana + Prometheus para监控 del agente (Enterprise)

---

## Referencias

- Coolify docs: https://coolify.io/docs
- Hetzner Cloud API: https://docs.hetzner.cloud/
- Hermes Agent: https://hermes-agent.nousresearch.com/docs/
- OpenClaw: Framework de tareas autonomous (Nous Research)
- Stripe Webhooks: https://stripe.com/docs/webhooks

---

## Changelog

| Fecha | Version | Cambio |
|--------|---------|--------|
| 2026-04-27 | 1.0 | Version inicial |
