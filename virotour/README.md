# Spring 2023 - The best cohort ever.

Enable a deeper connection between the user and the facility by providing a virtual tour experience that enables text searchable elements.

## Prerequisites
- [Set up for Windows](./docs/windows_setup.md)
- [Set up for MacOS](./docs/macos_setup.md)

## Configuring Flutter to work with Google Chrome

Navigate to `flutter\bin\cache`. Delete `flutter_tools.stamp`. 
Navigate to `flutter\packages\flutter_tools\lib\src\web`. Edit `chrome.dart` by adding 
`'--disable-web-security',` after the `'--disable-extensions',`.

