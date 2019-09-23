import 'dart:io';

main() async {

  await Process.run('osascript', [
    "-e",
    'tell application "Finder" to get POSIX path of (get desktop picture as alias)'
  ]).then((ProcessResult res) {
    print(res.stdout);
  });

  var filename = "/Users/dheeru/Desktop/Screenshot 2019-08-06 at 11.11.18 PM.png";
  print(filename.codeUnits);

  // Process.run("osascript", "-e", 'tell application "System Events" to tell every desktop to set picture to ${filename}').then(
  //   (ProcessResult res) {
  //     print(res.stdout);
  //   }
  // )

}
