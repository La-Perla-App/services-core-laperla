# services-core-laperla (`laperla_services_core`)

Core Dart/Flutter para **llamar servicios** La Perla con los clientes que genera Connect a partir de los `.proto`. Espejo del **backend-core** de Go.

No genera stubs. No implementa pantallas. Da:

1. `GeneralParams` (mismos datos que el Go core + `destinationId` para el front)
2. Un `Transport` Connect que los `*Client` generados reciben
3. Sesión (token) y mapeo de errores
4. Cómo generar y consumir clientes Dart

- Humanos: esta carpeta
- Cómo llamar servicios: [consume-services.md](consume-services.md)
- Contrato de params: [general-params.md](general-params.md)
- Agentes: [../AGENTS.md](../AGENTS.md)
