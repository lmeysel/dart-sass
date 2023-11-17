// Copyright 2018 Google Inc. Use of this source code is governed by an
// MIT-style license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

@TestOn('vm')

import 'dart:io';

import 'package:test/test.dart';

import 'package:sass/sass.dart';

void main() {
  test("passes an argument to a custom function and uses its return value",
      () async {
    var file = await File('test.scss').readAsString();
    // var css = await compileStringAsync(file);

    var ref = await File('bs-ref.css').readAsString();
    var css = compileString(r"$body-bg: $gray-800 !lazy;" + file,
        syntax: Syntax.scss);

    await File('bs-res.css').writeAsString(css);
    expect(css, equals(ref));
    // print(css);
  });
  test(
      "generated bootstrap source code is the same as in the reference implementation",
      () async {
    var file =
        await File('node_modules/bootstrap/scss/bootstrap.scss').readAsString();
    var ref = await File('bs-ref.css').readAsString();
    var css = await compileStringAsync(r"$body-bg: $gray-800 !lazy;" + file,
        loadPaths: ['node_modules/bootstrap/scss'], syntax: Syntax.scss);

    expect(css, equals(ref));
  });
}
