import 'dart:convert' show utf8, LineSplitter;
import 'dart:io' show stdin, stdout;

// https://stackoverflow.com/a/19390500/8608146
void main() {
  stdout.write(">> ");
  readLine.listen((x) {
    print(x);
    stdout.write(">> ");
  });
}

Stream<String> get readLine =>
    stdin.transform(utf8.decoder).transform(const LineSplitter());
