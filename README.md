# Infraestructura como Código (IaC) - Serverless Order Processing

Este repositorio contiene la definición de la infraestructura en Azure para la solución serverless de procesamiento de órdenes (Event-Driven) utilizando Azure Functions y Azure Durable Functions.

## Arquitectura Modular (Terraform)

El código ha sido refactorizado siguiendo las mejores prácticas de Infraestructura como Código (IaC), dividiendo la arquitectura en componentes lógicos mediante módulos:

- **Módulo `storage`**: Provisiona la cuenta de almacenamiento primario (`Storage Account`) necesaria para las Azure Functions, incluyendo las colas (`orders-to-process` y `orders-processed`) que habilitan el flujo asíncrono y los triggers.
- **Módulo `cosmosdb`**: Despliega la base de datos NoSQL (`Cosmos DB SQL API`), configurando la persistencia de estado con base de datos `orders-db` y contenedor `orders` segmentado por `/orderId`.
- **Módulo `function_app`**: Implementa el entorno serverless con un `App Service Plan` (Consumption Linux), la `Function App` (Python 3.10) para el orquestador/actividades de Durable Functions, y un espacio de `Application Insights` para observabilidad y registro estructurado.

El orquestador principal (`main.tf` en la raíz) se encarga de conectar y desplegar estos módulos inyectando dependencias entre ellos mediante variables.

## Integración y Despliegue Continuo (CI/CD)

El ciclo de vida de la infraestructura está completamente automatizado mediante GitHub Actions (`.github/workflows/deploy.yml`).

### Flujo de despliegue

1. **Pull Requests (`terraform plan`)**: Cuando se propone un cambio a `main`, el pipeline ejecuta una validación y genera un plan predictivo de los recursos que cambiarán (sin aplicarlos).
2. **Push / Merge a `main` (`terraform apply`)**: Automáticamente despliega la infraestructura en Azure sobre el entorno de producción.

### Gestión de Estado Remoto (Remote Backend)

Para operar en entornos profesionales y colaborativos, el estado de Terraform (`.tfstate`) no se guarda localmente en el repositorio, sino en un **Remote Backend**.
El pipeline se conecta a un `Azure Blob Storage` preexistente que garantiza consistencia y bloqueos concurrentes de despliegue, inyectando la configuración en caliente durante el paso de `terraform init`:

- `resource_group_name=${{ secrets.TF_STATE_RG }}`
- `storage_account_name=${{ secrets.TF_STATE_STORAGE }}`
- `container_name=tfstate`


