import 'dart:io';

main() {

  Process.run('osascript', [
    "-e",
    'tell application "Finder" to get POSIX path of (get desktop picture as alias)'
  ]).then((ProcessResult res) {
    print(res);
  });
}
