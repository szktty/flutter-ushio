# Ushio 🧂

A state management library inspired by the one used in SwiftUI.

## Differences of SwiftUI

- Supported
  - `@State` -> `state()`, `stateList()`, `stateMap()`
  - `@StateObject` -> `stateObject()`
  - `@Published` -> `published()`, `publishedList()`, `publishedMap()`
  - `@EnvironmentObject` -> `environmentObject()`
- Not supported
  - `@ObservedObject`

## Install

```
flutter pub add ushio
```

Import:

```dart
import 'package:ushio/ushio.dart';
```

## Usage

[Guide (Japanese)](https://zenn.dev/shiguredo/articles/flutter-ushio-guide)

See also [examples](./example/README.md).

## License

Apache License Version 2.0

## Author

SUZUKI Tetsuya (tetsuya.suzuki@gmail.com)