import 'dart:io';

import 'package:args/args.dart';
import 'package:cross_wallpaper/windows/in.dart' show readLine;
import 'package:path/path.dart' as p;

void main(List<String> args) {
  if (Platform.isWindows) {
    final parser = ArgParser()
      ..addFlag(
        "no-open",
        abbr: "n",
        defaultsTo: false,
        help: "Pass this flag to not open the explorer",
      )
      ..addFlag(
        "verbose",
        abbr: "v",
        defaultsTo: false,
        help: "Shows logs",
      )
      ..addFlag(
        "help",
        abbr: "h",
        defaultsTo: false,
      );
    argResults = parser.parse(args);
    final paths = argResults.rest;
    var path = '';

    if (argResults['help']) {
      print(parser.usage);
      return;
    }

    bool open = !argResults["no-open"];
    bool debug = argResults["verbose"];

    if (paths.isEmpty) {
      if (!stdin.hasTerminal) {
        printC("no terminal is attached, reading from stdin..", flag: debug);
        readLine.listen((line) {
          path = line.trim();
          final openPath = p.canonicalize(path);
          printC("resolved as $openPath", flag: argResults["verbose"] as bool);
          openExplorer(path, open: open);
        });
      } else {
        // args are empty and attatched to a terminal
        print("wrong usage");
        print(parser.usage);
        return;
      }
    } else {
      path = paths[0].trim();
      final openPath = p.canonicalize(path);
      printC("resolved as $openPath", flag: argResults["verbose"] as bool);
      openExplorer(path, open: open);
    }
  }
}

ArgResults argResults;

/// Second arg must be `/select,` not `/select` notice the `,`
/// https://stackoverflow.com/questions/281888/open-explorer-on-a-file#comment105130300_281911
void openExplorer(String path, {bool open: true}) {
  var openPath = p.canonicalize(path);
  if (open) {
    printC("openPathing $openPath", flag: argResults["verbose"] as bool);
    Process.run('explorer', ['/select,', openPath]).then((data) {
      /// I get a String can't be a bool if not using `argResults["verbose"] as bool`
      stdout.writeC(data.stdout, flag: argResults["verbose"] as bool);
      stdout.writeC(data.stderr, flag: argResults["verbose"] as bool);
    });
  } else {
    printC(
      "--no-open(-n) flag was set, won't open the explorer",
      flag: argResults["verbose"] as bool,
    );
  }
}

void printC(Object d, {bool flag: true}) {
  if (flag) print(d);
}

extension _conditionalWrite on Stdout {
  void writeC(Object d, {bool flag: true}) {
    if (flag) this.write(d);
  }
}
