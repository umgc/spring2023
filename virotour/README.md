# ViroTour Flutter App Setup

## Prerequisites

- [Set up local Flask server](../virotour_local/README.md)
- [Set up Flutter app for Windows](./docs/windows_setup.md)
- [Set up Flutter app for MacOS](./docs/macos_setup.md)

## Configuring Flutter to work with Google Chrome

Navigate to `flutter\bin\cache`. Delete `flutter_tools.stamp`.
Navigate to `flutter\packages\flutter_tools\lib\src\web`. Edit `chrome.dart` by adding
`'--disable-web-security',` after the `'--disable-extensions',`.