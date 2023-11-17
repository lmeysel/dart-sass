// Copyright 2016 Google Inc. Use of this source code is governed by an
// MIT-style license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'value.dart';
import 'ast/node.dart';

abstract class TraceVariable {
  final String name;
  Value get value;
  bool get isLazy;

  final bool isRoot;
  final bool isArgument;
  final AstNode? nodeWithSpan;
  final Set<TraceVariable> dependencies;

  TraceVariable(this.name,
      {Set<TraceVariable>? dependencies,
      this.nodeWithSpan,
      this.isRoot = false,
      this.isArgument = false})
      : dependencies = dependencies ?? {};

  void addDependencies(Set<TraceVariable> deps) {
    dependencies.addAll(deps);
  }

  String toString() {
    return r'$' + name;
  }

  dynamic toJson([bool flat = false]) {
    return flat
        ? [
            name,
            isRoot,
            isArgument,
            nodeWithSpan?.toString() ?? '',
            value.toString()
          ]
        : {
            'name': name,
            'isRoot': isRoot,
            'isArgument': isArgument,
            'expression': nodeWithSpan?.toString() ?? '',
            'evaluated': value.toString()
          };
  }
}
