import 'dart:io';

import '../lib/sass_api.dart';

void main() async {
  var file = await File('../../test.scss').readAsString();
  var ast = Stylesheet.parse(file, Syntax.scss);
  print(ast);
}
