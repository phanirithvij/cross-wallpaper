import 'dart:ffi' as ffi;

main() {
  getWallpaper();
  setWallpaper("D:\\Images\\Wallpapers\\sky-stars-j8e1zp.jpg");
}

class Utf16 extends ffi.Struct<Utf16> {
  @ffi.Uint16()
  int char;

  static String fromUtf16(ffi.Pointer<Utf16> ptr) {
    final units = List<int>();
    var len = 0;
    while (true) {
      final char = ptr.elementAt(len++).load<Utf16>().char;
      if (char == 0) break;
      units.add(char);
    }
    return String.fromCharCodes(units);
  }

  static ffi.Pointer<Utf16> toUtf16(String s) {
    final units = s.codeUnits;
    final ptr = ffi.Pointer<Utf16>.allocate(count: units.length + 1);
    for (var i = 0; i < units.length; i++) {
      ptr.elementAt(i).load<Utf16>().char = units[i];
    }
    // Add the C string null terminator '\0'
    ptr.elementAt(units.length).load<Utf16>().char = 0;
    return ptr;
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
*/
typedef SystemParametersInfoWC = ffi.Int8 Function(ffi.Uint32 uiAction,
    ffi.Uint32 uiParam, ffi.Pointer pvParam, ffi.Uint32 fWinIni);
typedef SystemParametersInfoWDart = int Function(
    int uiAction, int uiParam, ffi.Pointer pvParam, int fWinIni);

int getWallpaper() {
  // Load user32.dll.
  final dylib = ffi.DynamicLibrary.open('user32.dll');

  // Look up the function.
  final systemParWP =
      dylib.lookupFunction<SystemParametersInfoWC, SystemParametersInfoWDart>(
          'SystemParametersInfoW');

  const int SPI_GETDESKWALLPAPER = 0x0073;
  const int MAX_PATH = 1000;

  // Allocate pointers to Utf16 arrays containing the command arguments.
  final filenameP = Utf16.toUtf16("0" * MAX_PATH);

  // Invoke the command, and free the pointers.
  final result = systemParWP(SPI_GETDESKWALLPAPER, MAX_PATH, filenameP, 0);
  print(Utf16.fromUtf16(filenameP));

  filenameP.free();
  return result;
}

bool setWallpaper(String filename) {
  // Load user32.dll.
  final dylib = ffi.DynamicLibrary.open('user32.dll');

  // Look up the function.
  final systemParWP =
      dylib.lookupFunction<SystemParametersInfoWC, SystemParametersInfoWDart>(
          'SystemParametersInfoW');

  const int SPI_SETDESKWALLPAPER = 0x0014;
  const int SPIF_UPDATEINIFILE = 0x01;
  const int SPIF_SENDCHANGE = 0x02;

  // Allocate pointers to Utf16 arrays containing the command arguments.
  final filenameP = Utf16.toUtf16(filename);

  // Invoke the command, and free the pointers.
  final result = systemParWP(
      SPI_SETDESKWALLPAPER, 0, filenameP, SPIF_UPDATEINIFILE | SPIF_SENDCHANGE);
  print(Utf16.fromUtf16(filenameP));

  filenameP.free();
  return result > 0;
}