# Changelog

## 0.1.0

- `GeneralParams` alineado al Go `api.GeneralParams`, más `destinationId` para el front.
- Headers + `General-Params-Bin` / `Response-Info-Bin` como el backend-core.
- `LaperlaServices` / `createLaperlaServicesTransport` para clientes Connect generados.
- `SessionStore` + persistencia del token desde `Response-Info-Bin`.
- `LaperlaException` (16, 427, 428, 429).
