# AI LOG - Asistente de Desarrollo (Antigravity Agent)

Este documento registra el uso de inteligencia artificial en la automatización y refactorización del código de esta prueba técnica, tal como fue solicitado en los requerimientos.

## 1. Herramientas Utilizadas
- **Antigravity (Google DeepMind)**: Agente autónomo de codificación utilizado embebido en la terminal/IDE.
- Se utilizó interacción multiherramienta (lectura de archivos, ejecución de comandos, escritura en disco) gestionada por este agente para organizar el código.

## 2. Prompts / Acciones Utilizadas
1. **Analizar la arquitectura actual:** `list_dir e:/Documentos/PruebaCreaSistemas/infra` y lectura secuencial de `main.tf`, `variables.tf`, y `outputs.tf`.
2. **Generar un plan de refactorización IaC en modo PLANNING:** Se generó `implementation_plan.md` mapeando la separación de los recursos (App Service, Cosmos, Storage) en módulos de Terraform separados.
3. **Creación recursiva de módulos:** Se ordenó al agente escribir cada sub-módulo en variables `variables.tf`, `main.tf` y `outputs.tf` inyectando propiedades específicas agrupadas por contexto de negocio.
4. **Validación del pipeline de Github Actions:** Se leyó `deploy.yml` y se decidió reestructurar para añadir robustez (disparadores de Pull Request y paso de variables de entorno para la autenticación de Terraform con Azure).
5. **Generación de documentación final:** Se ordenó al creador escribir el `README.md` estructurado resumiendo la arquitectura desplegada, y este archivo de log `AI_LOG.md`.

## 3. Decisiones Técnicas: Ajuste o Rechazo de Sugerencias de IA
1. **Decisión: Rechazar la inclusión del despliegue del back-end en el workflow IaC.**
   - **Propuesta de la IA (implícita/inicial):** Cuando se solicitó "valida el ci/cd y dime como se puede desplegar", la IA comúnmente sugiere añadir el comando de Function App Publish o comprimir el código Python en el mismo `.yaml`.
   - **Corrección/Por qué se ajustó:** Se notó que el requerimiento explícitamente mencionaba "ese repo va ser solo el iac del requerimiento". Por tanto, se ajustó el pipeline para manejar estricta y únicamente el ciclo de vida de Terraform (init, plan, validate, apply), absteniéndose de desplegar el código de la función ahí mismo, y en su lugar, documentando en el README cómo ambos repos/ciclos de vida se comunicarían (Separación de Funciones).
2. **Decisión: Ajustar la gestión del Terraform State en el workflow CI/CD.**
   - **Propuesta de la IA:** El `deploy.yml` original simplemente corría `terraform init` sin prever un remote backend, y la IA intentó ejecutar formates sin tener el entorno preparado.
   - **Corrección/Por qué se ajustó:** En un pipeline del mundo real (y evaluación con criterio técnico de nivel pro), es un craso error aplicar IaC sin un "statefile" distribuido (Remote Backend). Se forzó a que el `.yml` resultante mencione "Nota: Idealmente deberías configurar un backend en Azure Storage Account" y use un seteo estricto con las credenciales ARM por variables de entorno explícitas para evitar fallos de persistencia en futuros despliegues del pipeline real.
