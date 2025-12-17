# digital_arena_test

Aplicación Flutter de ejemplo para el challenge de Digital Arena.

## Descripción

`digital_arena_test` es una aplicación cliente Flutter que consume una
API REST (implementada en `digital_arena_backend/`) y persiste datos
localmente usando `drift`.

Este README cubre requisitos, instalación, ejecución, estructura del
repositorio y decisiones técnicas tomadas durante el desarrollo.

## Requisitos minimos (comando flutter doctor)

Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.38.1, on macOS 26.1 25B78 darwin-arm64, locale es-VE)
[✓] Android toolchain - develop for Android devices (Android SDK version 36.1.0)
[✓] Xcode - develop for iOS and macOS (Xcode 26.1.1)
[✓] Chrome - develop for the web
[✓] Connected device (3 available)
[✓] Network resources

## Instalación (cliente Flutter)

```bash
flutter pub get
```

2. Configura variables de entorno si es necesario (ver `enviroment/`).

## Ejecución

- Ejecutar en un emulador o dispositivo:

```bash
flutter run
```

2. Asegúrate de que la variable de entorno que usa el cliente (`API_URL`)
   apunte al backend local o remoto. Los endpoints se configuran en
   `enviroment/dotenv.*`.

## Estructura de carpetas (resumen)

```
digital_arena_test/
├─ lib/
│  ├─ core/
│  │  ├─ local/           # DB: `data_base_client.dart`, `app_data_base.dart`
│  │  └─ network/         # Cliente HTTP: `api_client.dart`
│  ├─ models/             # Modelos de datos
│  ├─ repository/         # Repositorios (ej. `api_list_repository.dart`)
│  └─ ui/                 # Pantallas y widgets
|  └─ ui/pages/           # Se encuentran las definiciones de las pantallas principales, en este caso api_list y prefs, y dentro de cada carpera la difinicion Cubit correspondiente
├─ enviroment/            # Variables .env
└─ android|ios|web        # Plataformas
```

## Diagrama de arquitectura (simplificado)

Cliente Flutter <--> API REST (digital_arena_backend) <--> Consulta de items aleatorios

En el cliente:
- `ApiClient` realiza llamadas HTTP y normaliza errores.
- `ApiListRepository` consume `ApiClient` y expone `Stream<List<ItemModel>>`.
- `DataBaseClient` (basado en `drift`) maneja la persistencia local.
- `flutter_bloc/cubit` para manejo de state management

## Puntos clave y comentarios en el código

- `lib/core/local/data_base_client.dart`: Implementa `DataBaseClient` como
  singleton para evitar abrir la base de datos más de una vez en el mismo
  isolate. Evita errores del tipo "database opened a second time".

- `lib/core/network/api_client.dart`: Debe mapear excepciones de red
  (`SocketException`, `ClientException`) a un `ApiException` propio. Esto
  permite al consumidor distinguir errores de red, parseo y otros.

- `lib/repository/api_list_repository.dart`: Expone `fetchItems()` como
  `Stream<List<ItemModel>>`. En el `Stream` se manejan `FormatException`
  y se re-lanzan errores como `ApiException`.

He añadido comentarios en esos archivos en los puntos donde se
gestionan:

- Inicialización del singleton de DB.
- Mapeo de errores en `ApiClient.get()` y conversión a `Stream.error(...)`.
- Manejo de parseo en `ApiListRepository.fetchItems()`.

## Decisiones técnicas y justificación

- Persistencia local con `drift`:
  - Razón: consultas SQL sofisticadas y tipo-safe; buena integración con
    Flutter/Dart.

- `DataBaseClient` como singleton:
  - Problema resuelto: abrir la DB multiple veces produce excepciones y
    corrupción potencial. Una instancia compartida por isolate evita
    re-aperturas involuntarias.

- Comunicación con el backend via `ApiClient` que devuelve `Stream`:
  - Razón: facilita la composición reactiva con `StreamBuilder` y permite
    manejar eventos y reintentos si se desea.

- Mapeo de errores a `ApiException`:
  - Razón: normaliza errores (network, parse, server) para que la UI
    pueda reaccionar adecuadamente.

## Manejo de errores de red comunes

- Error DNS / host no encontrado (`SocketException: Failed host lookup...`):
  Tratarlo como `ApiErrorKind.network`. Ejemplo de captura desde el
  consumidor del `Stream` (p. ej. en `StreamBuilder` o `listen`):

```dart
repo.fetchItems().listen(
  (items) => /* manejar items */,
  onError: (error) {
    if (error is ApiException && error.kind == ApiErrorKind.network) {
      // Mostrar mensaje de "Sin conexión" o reintentar
    } else {
      // Otros errores
    }
  },
);
```

## Interfaces y manejos de estados 

En los requerimeintos para la prueba se pidio trabajar 4 interfaces (ApiList, PrefsList, New y Edit), sin embargo me tome la libertad de reducir a dos interfaces principales (ApiList y PrefsList) y manejar New y Edit como modales pues tambien representan parte de la navegacion y UX de Flutter, y puede ser tomado en cuenta como parte de la evaluacion del codigo.

El state management como se solicito se manejo usando flutter_bloc/cubit, cada cubit definido esta dentro de la respectiva carpeta de su interfaz, p.e. `lib/ui/pages/api_list/cubit/api_list_cubit.dart` donde se maneja toda la logica de negocio estableciendo la consulta de datos mediante los repository definidos, de ese modo garantizando una arquitectura limpia, con capas debidamente identificadas y funcionales.


## Backend y consulta de items

Para realizar la consulta de datos me tome la libertad de hacer un backend simple y desplegado en Railway para la consulta de datos, cabe aclarar que este backend devuelve items aleatorios manteniendo siempre la misma estructura es decir:

```json
{
    "id": 7707,
    "name": "Item 7707",
    "description": "Ut eiusmod adipiscing ad amet sed ut elit minim et lorem.",
    "created_at": "2025-12-14T21:26:42.608Z",
    "updated_at": "2025-12-20T00:25:00.607Z"
}
```
el endpoint esta expuesto en enviroment/dotenv.prod para simplicidad a la hora de clonar y ejecutar.

## Dependencias utilizadas.

```yaml
  flutter_bloc: Para state management
  http: Para consultas api rest
  flutter_dotenv: para manejo de enviroment
  intl: para parseo de fechas a formatos especificos funciones definidas en lisb/utils/form_utils.dart
  drift: local storage management
  drift_flutter: requerido por drift
  path_provider: requerido por drift
  path: requerido por drift
```

