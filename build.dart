import 'package:polymer/builder.dart';

void main(List<String> args) {
  lint(entryPoints: ['web/example.html'], options: parseOptions(args));
}