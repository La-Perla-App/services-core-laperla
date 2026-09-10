# GeneralParams (Flutter ↔ Go)

El backend lee `api.GeneralParams` de:

1. Header **`General-Params-Bin`** (JSON en base64, mismos nombres exportados de Go), o
2. Headers HTTP sueltos si el bin no viene

Este paquete manda **las dos** formas.

| Campo Dart | Header | Go | Quién lo usa en el front |
|---|---|---|---|
| `sessionToken` | `Authorization: Bearer` + cookie `laperla-access-token` | `SessionToken` | Login; vacío = anónimo (Home) |
| `lang` | `Accept-Language` | `Lang` (`es` / `en`) | i18n de la app |
| `clientId` | `X-Client-Id` + cookie `laperla-client-id` | `ClientId` | Analytics, idempotencia |
| `ianaTimezone` | `X-Timezone` | `IANATimezone` | Default: Caracas, Venezuela (`America/Caracas`) |
| `platform` | `X-Platform` | `Platform` | `ios` / `android` / `web` |
| `clientVersion` | `X-Client-Version` | `ClientVersion` | Semver del build |
| `destinationId` | `X-Destination-Id` | (reservado / `DestinationId` en el bin) | Destino publicado (Margarita, …) |

`Session` del struct Go **no** se envía: eso lo reconstruye el servidor al validar el JWT (+ Redis).

Tras login, el servidor puede devolver `sessionToken` en `Response-Info-Bin`. El interceptor lo guarda en `SessionStore`.
