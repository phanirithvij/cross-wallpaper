import 'dart:io';

main() {

  Process.run('osascript', [
    "-e",
    'tell application "Finder" to get POSIX path of (get desktop picture as alias)'
  ]).then((ProcessResult res) {
    print(res.stdout);
  });

//   	return exec.Command("osascript", "-e", `tell application "System Events" to tell every desktop to set picture to `+strconv.Quote(file)).Run()

}
