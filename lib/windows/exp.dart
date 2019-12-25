import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:cross_wallpaper/windows/in.dart' show readLine;

void main(List<String> args) {
  if (Platform.isWindows) {
    var paths = [];
    if (args.length >= 1) {
      paths.add(args[0].trim());
    }
    // A way to read from pipe
    if (!stdin.hasTerminal) {
      readLine.listen((line) {
        paths.add(line.trim());
      });
    }
    // print("Must pass an file/folder path as an argument");
    // exit(1);

    /// Second arg must be `/select,` not `/select`
    /// https://stackoverflow.com/questions/281888/open-explorer-on-a-file#comment105130300_281911
    Process.run('explorer', ['/select,', p.canonicalize(paths[0])])
        .then((data) {
      stdout.write(data.stdout);
      stdout.write(data.stderr);
    });
  }
}
