# cross-wallpaper

A wallpaper changer cross-platform in dart for flutter

- Ios will be implemented if possible [not right now](https://stackoverflow.com/questions/50598159/swift-change-iphone-background)

## Windows

- Uses `dart:ffi` and calls some `win32.dll` funcions

To run

```shell
dart2native windows/windows.dart
windows.exe <optional URL or FileName>
# or
dart windows/windows.dart <optional URL or FileName>
```

## Android

- use `launcher_assist` which's already written
- improve if something doesn't work while using it

## TODO

- [ ] Android use [launcher_assist](https://github.com/hathibelagal-dev/launcher-assist-for-flutter/blob/master/android/src/main/java/com/progur/launcherassist/LauncherAssistPlugin.java#L58)
- [ ] Check what this is https://github.com/xyproto/wallutils
- [x] Windows
- [ ] Linux/Windows Reference [go/wallpaper](https://github.com/reujab/wallpaper)
- [ ] MacOS Reference [sindresorhus](https://github.com/sindresorhus/macos-wallpaper)
