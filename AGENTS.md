# Agentes — services-core-laperla

Paquete Dart `laperla_services_core`. Core cliente para **llamar servicios** (espejo de `backend-core-laperla`).

## Qué es

- `GeneralParams` + headers que el Go core ya entiende (`Authorization`, `Accept-Language`, `X-Platform`, `X-Timezone`, `X-Client-Id`, `X-Client-Version`, `General-Params-Bin`, cookies `laperla-*`).
- `createLaperlaServicesTransport` / `LaperlaServices` → `Transport` para `*Client` generados.
- `SessionStore` (interfaz; Flutter implementa secure storage).
- Errores `LaperlaException` (427/428/429).

## Qué no es

No genera protos. No metas widgets, Riverpod, ni stubs de auth en este repo. Los clientes Dart los genera la **app** (`app-laperla/tool/proto.sh`) desde los `.proto` de cada servicio.

La versión del plugin de generación va atada a la de este paquete: pedimos
`connectrpc ^1.0.0` (protobuf `>=3.1.0 <5.0.0`), así que la app genera con
`protoc_plugin 22.5.0`. Si aquí se sube a `connectrpc ^2.0.0`, hay que subir el
plugin en la app en el mismo movimiento o su `lib/gen/` deja de compilar.

## Contrato

- Nombres de header en minúsculas (Connect `Headers`).
- JSON del bin: campos Go (`SessionToken`, `Lang`, `ClientId`, `IANATimezone`, `Platform`, `ClientVersion`).
- Cookie access: `laperla-access-token`.
- `destinationId` es de producto (front); auth lo ignora.
- Sin tenant.

## Docs

[docs/consume-services.md](docs/consume-services.md), [docs/app-wiring.md](docs/app-wiring.md), [docs/general-params.md](docs/general-params.md).
