import 'dart:io'; // Server side / command line only package.

Map<String, String> env = Platform.environment;

// Desktop contains the current desktop environment on Linux.
// Empty string on all other operating systems.
var desktop = env["XDG_CURRENT_DESKTOP"];

// DesktopSession used for LXDE
var desktopSession = env["DESKTOP_SESSION"];
