# services-core-laperla

Paquete Dart (`laperla_services_core`) para **consumir los servicios** La Perla desde Flutter (y Dart).

Es el espejo cliente del **backend-core** de Go: un `Transport` ConnectRPC que los stubs generados por proto usan, más `GeneralParams` (sesión, idioma, plataforma, destino, …).

```yaml
dependencies:
  laperla_services_core:
    git:
      url: https://github.com/La-Perla-App/services-core-laperla.git
```

```dart
final services = LaperlaServices(
  baseUrl: 'https://dev.laperlaapp.biz',
  sessionStore: store,
  params: () => GeneralParams(
    lang: 'es',
    platform: LaperlaPlatform.android,
    destinationId: margaritaId,
  ),
);
final auth = AuthServiceClient(services.transport(createHttpClient()));
```

## Docs

- [docs/README.md](docs/README.md)
- [docs/consume-services.md](docs/consume-services.md) — generar stubs y llamar auth/otros
- [docs/general-params.md](docs/general-params.md)
- [AGENTS.md](AGENTS.md)

## Qué no es

No incluye pantallas ni clientes generados. Los `.connect.client.dart` salen de `buf generate` en cada servicio (o repo de protos).
