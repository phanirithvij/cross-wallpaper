// A Wallpaper cli app in dart
// Uses dart:ffi requires dart>=2.5.0

import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

import 'package:path/path.dart' as p;
import 'utils.dart' show downloadFile;
import 'dart:io';

main(List args) async {
  if (args.length == 1) {
    final file = p.canonicalize(args[0]);
    final exists =
        FileSystemEntity.typeSync(file) != FileSystemEntityType.notFound;

    if (exists && !setWallpaper(file)) {
      print("Failed to set wallpaper");
      return -1;
    }
    print("Not a file");
    // url
    final directory = await Directory.systemTemp.createTemp('my_temp_dir');
    final path = directory.path;

    downloadFile(args[0], "$path/temp.png").whenComplete(() {
      setWallpaper(p.canonicalize("$path/temp.png"));
      exit(0);
    });
    return 0;
  }
  print(getWallpaper());
}

const int _kMaxSmi64 = (1 << 62) - 1;
const int _kMaxSmi32 = (1 << 30) - 1;
final int _maxSize = sizeOf<IntPtr>() == 8 ? _kMaxSmi64 : _kMaxSmi32;

/// [Utf16] Helper class to decode and encode String to Utf16 and back
/// [ffi_examples](https://github.com/dart-lang/samples/blob/master/ffi/structs/structs.dart#L9)
///
class Utf16C extends Struct {
  @Uint16()
  int char;
//   static int strlen(Pointer<Utf16> string) {
//     final Pointer<Uint16> array = string.cast<Uint16>();
// 	// ignore: avoid_as
//     final Uint16List nativeString = (array as Uint16Pointer).asTypedList(_maxSize);
//     return nativeString.indexWhere((char) => char == 0);
//   }

//   static String fromUtf8(Pointer<Utf16> string) {
//     final int length = strlen(string);
//     return utf8.decode(Uint16List.view(
//         string.cast<Uint16>().asTypedList(length).buffer, 0, length));
//   }

  static String fromUtf16(Pointer<Utf16> ptr) {
    final units = List<int>();
    var len = 0;
    while (true) {
      final int char = ptr.cast<Int8>().elementAt(len++).value;
      final _ = ptr.cast<Int8>().elementAt(len++).value;
      print(ptr.cast<Int8>().elementAt(len-1).address);
      print("$char, $len");
      if (char == 0) break;
      units.add(char);
    }
    return String.fromCharCodes(units);
  }
}
/*
BOOL SystemParametersInfoW(
  UINT  uiAction,
  UINT  uiParam,
  PVOID pvParam,
  UINT  fWinIni
);

https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-systemparametersinfow
https://github.com/sindresorhus/win-wallpaper/blob/master/wallpaper.c

*/

typedef SystemParametersInfoWC = Int8 Function(
    Uint32 uiAction, Uint32 uiParam, Pointer pvParam, Uint32 fWinIni);
typedef SystemParametersInfoWDart = int Function(
    int uiAction, int uiParam, Pointer pvParam, int fWinIni);

String getWallpaper() {
  // Load user32.dll.
  final dylib = DynamicLibrary.open('user32.dll');

  // Look up the function.
  final systemParWP =
      dylib.lookupFunction<SystemParametersInfoWC, SystemParametersInfoWDart>(
          'SystemParametersInfoW');

  const int SPI_GETDESKWALLPAPER = 0x0073;
  const int MAX_PATH = 1000;

  // Allocate pointers to Utf16 arrays containing the command arguments.
  final Pointer<Utf16> filenameP = Utf16.toUtf16("0" * MAX_PATH);

  // Invoke the command, and free the pointers.
  systemParWP(SPI_GETDESKWALLPAPER, MAX_PATH, filenameP, 0);
  String wall = Utf16C.fromUtf16(filenameP);
  free(filenameP);

  return wall;
}

bool setWallpaper(String filename) {
  // Load user32.dll.
  final dylib = DynamicLibrary.open('user32.dll');

  // Look up the function.
  final systemParWP =
      dylib.lookupFunction<SystemParametersInfoWC, SystemParametersInfoWDart>(
          'SystemParametersInfoW');

  // http://pinvoke.net/default.aspx/Enums/SPIF.html
  const int SPI_SETDESKWALLPAPER = 0x0014;
  const int SPIF_UPDATEINIFILE = 0x01;
  const int SPIF_SENDCHANGE = 0x02;

  // Allocate pointers to Utf16 arrays containing the command arguments.
  final Pointer<Utf16> filenameP = Utf16.toUtf16(filename);

  // Invoke the command, and free the pointers.
  final result = systemParWP(
      SPI_SETDESKWALLPAPER, 0, filenameP, SPIF_UPDATEINIFILE | SPIF_SENDCHANGE);

  free(filenameP);
  return result > 0;
}
