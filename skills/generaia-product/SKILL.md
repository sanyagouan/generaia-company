---
name: generaia-product
description: Catálogo de paquetes, precios, márgenes, nichos de mercado y estrategia comercial de GeneraIA.
---

# GeneraIA Product — Catálogo y Estrategia Comercial

## Elevator Pitch

> "Te configuro un asistente IA que atiende a tus clientes por WhatsApp."

GeneraIA no es un chatbot genérico. Es un asistente IA especializado por sector, instalado en un servidor dedicado por cliente, que se conecta a las herramientas que el cliente ya usa (WhatsApp, email, calendario, CRM).

## Modelo de negocio

**Setup + Mantenimiento mensual. NO es SaaS.**

Cada cliente contrata:
1. Pago de setup (una sola vez) — instalación y configuración
2. Pago mensual — hosting, mantenimiento, soporte

El cliente también paga su propio servidor (incluido en la mensualidad de GeneraIA) y sus propias API keys (MiniMax, si quiere voz).

## Paquetes

### Paquete Esencial — 299€ setup

Para negocios que ya tienen hosting y solo quieren el asistente IA.

- Asistente IA configurado (OpenClaw)
- 1 canal: WhatsApp
- Conocimiento del negocio cargado
- 1 mes de soporte incluido

**No incluye:** servidor, dominio, mantenimiento mensual.

### Paquete Profesional — 299€ setup + 79€/mes

El paquete estándar. Recomendado para la mayoría de negocios.

- Todo lo de Esencial
- **Servidor dedicado Hetzner CX33** (2 vCPU, 4GB RAM, 80GB SSD)
- **Dominio incluido** (.org o .com)
- **3 canales:** WhatsApp + Email + Web (chatbot embebible)
- Mantenimiento y actualizaciones
- Monitorización 24/7 (Uptime Kuma)
- Backups diarios
- Soporte por email

### Paquete A Medida — 500€+ setup + 79€/mes+

Para negocios con necesidades especiales.

- Todo lo de Profesional
- **Servidor mayor** (CX43 o CX53 según necesidades)
- **Múltiples canales** personalizados
- **Skills específicas** del sector
- **Integraciones** con herramientas del cliente
- **Voice** (llamadas automatizadas) — coste variable según uso
- Propuesta comercial custom

## Coste real por cliente (IVA 21% incluido)

### Estructura de costes mensuales

| Concepto | CX33 | CX43 | CX53 |
|----------|------|------|------|
| Hetzner VPS | 6,40€ | 10,03€ | 18,01€ |
| Dominio | 1€ | 1€ | 1€ |
| MiniMax (Plan Plus) | 20€ | 20€ | 20€ |
| **Total coste** | **~27€/mes** | **~31€/mes** | **~39€/mes** |

### Margen bruto por paquete

| Paquete | Precio venta | Coste | Margen | Margen % |
|---------|------------|-------|--------|----------|
| Básico (CX33) | 119€/mes | 27€/mes | 92€ | **77%** |
| Medio (CX43) | 169€/mes | 31€/mes | 138€ | **82%** |
| Alto (CX53) | 229€/mes | 39€/mes | 190€ | **83%** |
| Mantenimiento extra | +79€/mes | 0€ | 79€ | **100%** |
| Setup Básico | 399€ | 0€ | 399€ | **100%** |
| Setup Medio | 499€ | 0€ | 499€ | **100%** |
| Setup Alto | 599€ | 0€ | 599€ | **100%** |

**Caso real (piloto "En Las Nubes"):** Coste real ~77-120€/mes, margen real 82-94%.

## Nichos priorizados

### 1. Asesoría fiscal — PRIORIDAD ALTA

**Mercado:** 82.000+ asesorías en España, 28.000M€ facturación.

**Qué hace el asistente:**
- Clasifica documentos recibidos por email/WhatsApp automáticamente
- Agenda citas de consultoría fiscal
- Responde FAQs sobre impuestos, deducciones, plazos
- Envía recordatorios de declaraciones y pagos
- Gestiona comunicación con clientes

**ROI demostrable:** 96€/mes en tiempo ahorrado en clasificación de docs × N clientes de la asesoría.

**Datos del sector:**
- 82.000 asesorías gestoras en España (REGA + IAGA)
- 28.000M€ facturación sector gestoría
- Temporada alta: enero-abril y septiembre-octubre
- Comunicación constante: plazos, hacienda,モデル clientes

### 2. Inmobiliarias — PRIORIDAD ALTA

**Mercado:** 58.235 inmobiliarias en España, 8.900M€ (+18% vs año anterior).

**Qué hace el asistente:**
- Responde consultas de inmuebles por WhatsApp 24/7
- Agenda visitas automáticamente
- Envía fichas de propiedades nuevas a clientes interesados
- Seguimiento de leads: "¿sigues interesado?"
- Gestiona cancelaciones y cambios de cita

**ROI demostrable:** 1 venta extra al mes = 9.000-15.000€ en comisiones de una inmobiliaria media.

**Datos del sector:**
- 58.235 inmobiliarias (dato reciente)
- 8.900M€ facturación (+18%)
- Lead management es el dolor principal
- Primera respuesta rápida = más conversiones

### 3. Clínicas dentales — PRIORIDAD MEDIA

**Mercado:** 7.599 clínicas dentales, 970M€ facturación.

**Qué hace el asistente:**
- Gestiona citas: agenda, cancela, reprograma
- Recordatorios automáticos 24h antes
- Seguimiento post-tratamiento
- Responde FAQs: precios, tratamientos, seguros
- Captura nuevos pacientes

**ROI:** Reducción de citas perdidas + aumento de записей = más facturación por paciente.

### 4. Restaurantes — PILOTO ACTIVO

**Piloto:** Restaurante "En Las Nubes" (Logroño), contacto: Susana.

**Qué hace el asistente:**
- Gestiona reservas por WhatsApp
- Responde al menú y precios
- Informa de eventos y ofertas
- Recordatorios de reserva

**Coste real piloto:** 77-120€/mes. Margen: 82-94%.

## Ampliaciones modulares

El producto base se puede ampliar con módulos:

| Ampliación | Precio extra | Descripción |
|-----------|------------|-------------|
| Voice (llamadas) | Coste variable | Llamadas automatizadas con TTS. ElevenLabs ~$0.10/1000 chars |
| Email avanzado | Incluido | Integración Gmail/Workspace |
| CRM | 19€/mes | Integración con CRM del cliente |
| NAS local | 19€/mes | Backup local en mini PC |
| Dashboard analytics | 19€/mes | Métricas de conversación |
| IA local (Ollama) | 9€/mes | Modelos locales para datos sensibles |
| Hardware on-premise | Precio custom | Mini PC para IA local |
| Múltiples empleados | 9€/mes/empleado | Varios usuarios del panel |

## Principio clave: NO reemplazar, CONECTAR

GeneraIA no reemplaza las herramientas del cliente. Se conecta a lo que ya usa:
- ¿Ya tiene WhatsApp Business? → El asistente usa WhatsApp Business API
- ¿Usa Google Calendar? → El asistente lee/escribe citas
- ¿Tiene CRM? → El asistente se integra con el CRM

**Posicionamiento:** "Te configuro un asistente IA que atiende a tus clientes por WhatsApp."

No: "Te doy una plataforma de IA." No: "Te reemplazo tu software actual." Sí: "Conecto IA a lo que ya tienes."

## Pricing psychology

- **Setup bajo** (299€) reduce la barrera de entrada. El cliente "prueba" por 299€ antes de comprometerse a mensualidad.
- **Mensualidad clara** (79€) es predecible. Sin sorpresas.
- **Mantenimiento extra** (+79€) para clientes que quieren TODO resuelto sin tocar nada.
- **Voice como upsell** — el cliente ve el coste real de las llamadas y decide si lo quiere.

## Objetivo: Validar con 1 cliente real (no piloto)

Antes de escalar marketing:
1. Piloto "En Las Nubes" → convertir a cliente pagando
2. Segundo cliente real → validar que el proceso de onboarding funciona
3. Tercer cliente → validar que podemos repetir sin intervention manual

**Headcount Zero:** Solo cuando haya demanda probada, contratar agentes especializados.
