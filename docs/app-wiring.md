# Orden de wiring Flutter (B2C)

Guía corta para conectar la app con los servicios Connect ya desplegados.
Los stubs Dart se generan **en cada repo de servicio** (`buf generate --template buf.gen.dart.yaml`), no en este paquete.

## Repos de backend (hoy)

Org GitHub: `La-Perla-App`. Stubs: `<repo>/gen/dart/` tras `buf generate --template buf.gen.dart.yaml`.

| Repo | Superficie app (Connect) | Uso Flutter V1 |
|---|---|---|
| [`auth-backend-laperla`](https://github.com/La-Perla-App/auth-backend-laperla) | `AuthService` | Login, register, perfil, avatar, sesión |
| [`directory-backend-laperla`](https://github.com/La-Perla-App/directory-backend-laperla) | `DirectoryService` | Home, destinos, categorías, negocios, featured |
| [`passes-backend-laperla`](https://github.com/La-Perla-App/passes-backend-laperla) | `PassService` | Catálogo de pases, pase activo, historial, savings/payback |
| [`benefits-backend-laperla`](https://github.com/La-Perla-App/benefits-backend-laperla) | `BenefitService` | Beneficios por negocio / destino |
| [`redemption-backend-laperla`](https://github.com/La-Perla-App/redemption-backend-laperla) | `RedemptionService` | QR, tarjeta digital, canjes, savings (suma) |
| [`notifications-backend-laperla`](https://github.com/La-Perla-App/notifications-backend-laperla) | `NotificationsService` | Inbox, devices, preferencias |

**Cliente (este paquete):** [`services-core-laperla`](https://github.com/La-Perla-App/services-core-laperla) (`laperla_services_core`) — Transport + `GeneralParams`; no genera stubs.

**No son APIs B2C (no cablear desde la app):** `backend-core-laperla` (librería Go), `hub-web-laperla` (Admin/Merchant), `deploy-webhook-laperla`, `gitops-*`. Payment / points / merchant API: aún no existen como microservicio publicado.

Base URL develop (API): `https://api-dev.laperlaapp.biz` (mismas rutas `/api/...` y `/services.*.v1.*Service/`).

## Orden recomendado

| # | Pantalla / flujo | Servicio | RPC clave |
|---|---|---|---|
| 1 | Login / register / perfil / locale / avatar | **Auth** | `CredentialsLogin`, `Register`, `GetMe` / `UpdateProfile`, `PresignUserAvatar*` |
| 2 | Home (destino, categorías, featured, negocios) | **Directory** | `GetHome` → `best_discount_label` / `best_benefit_id` en cada `Business` |
| 3 | Catálogo de pases + pase activo | **Passes** | `ListPassProducts`, `GetActivePass`, `GetPassHistory` |
| 4 | Ahorro / payback | **Passes** | `GetSavingsSummary` (suma redemptions + `pass_price_cents`) |
| 5 | Tarjeta digital + QR | **Redemption** | `GetMyDigitalCard` (holder + pase + QR) o `IssueUserQr` solo |
| 6 | Beneficios en ficha | **Benefits** | `ListBenefits` (por `business_id` / destino) |
| 7 | Inbox / devices | **Notifications** | al final |

## Transport (`laperla_services_core`)

```dart
final services = LaperlaServices(
  baseUrl: 'https://api-dev.laperlaapp.biz',
  sessionStore: store,
  params: () => GeneralParams(
    lang: 'es',
    platform: LaperlaPlatform.ios,
    clientVersion: '0.1.0',
    clientId: installId,
    ianaTimezone: 'America/Caracas',
    destinationId: margaritaId, // X-Destination-Id
  ),
);
final transport = services.transport(createHttpClient());
final auth = AuthServiceClient(transport);
final directory = DirectoryServiceClient(transport);
final passes = PassServiceClient(transport);
final redemption = RedemptionServiceClient(transport);
final benefits = BenefitServiceClient(transport);
```

## Notas de contrato

- **Sin tenant.** Scope = `destinationId` (Margarita V1: `7c0e2d8a-4b3f-4c1a-9d2e-0f1a2b3c4d5e`).
- Home teaser: `best_discount_label` es `"20%"` / `"$5"` / `"Gratis"` — no hay rating/distance en directory.
- Savings: preferí `passes.GetSavingsSummary` si la UI muestra payback; `redemption.GetMySavingsSummary` solo suma.
- Arte 3D del pase: `image_key` + `image_effect` ya vienen en producto / digital card; shader Flutter = doc en `passes-backend-laperla/docs/pass-art-effects-flutter.md` (después del wiring plano).
- Generar stubs: en cada servicio, `buf generate --template buf.gen.dart.yaml` → `gen/dart/`.

Ver también [consume-services.md](consume-services.md).
