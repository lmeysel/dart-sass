// Copyright 2016 Google Inc. Use of this source code is governed by an
// MIT-style license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// DO NOT EDIT. This file was generated from async_variable_tracer.dart.
// See tool/grind/synchronize.dart for details.
//
// Checksum: 0133478a922698c2841a49cde1417c4b074abf30
//
// ignore_for_file: unused_import

import 'trace_variable.dart';
import './trace_argument.dart';
import 'value.dart';

class VariableTracer {
  static final VariableTracer _singleton = VariableTracer._();

  VariableTracer._();

  factory VariableTracer() {
    return _singleton;
  }

  final List<Set<TraceVariable>> _batch = [];

  Set<TraceVariable>? get _deps => _batch.lastOrNull;

  (T, Set<TraceVariable>) traceReads<T>(T Function() cb) {
    var deps = <TraceVariable>{};
    _batch.add(deps);
    var result = cb();

    _batch.removeLast();
    return (result, deps);
  }

  void touch(TraceVariable variable) {
    _deps?.add(variable);
  }

  TraceArgument traceArgument(Value Function() cb) {
    var (value, dependencies) = traceReads(cb);
    return TraceArgument(value, dependencies);
  }
}

mixin VariableTracerMixin {
  final VariableTracer _tracer = VariableTracer();

  (T, Set<TraceVariable>) traceReadVariables<T>(T Function() cb) =>
      _tracer.traceReads(cb);

  TraceVariable touchVariable(TraceVariable variable) {
    _tracer.touch(variable);
    return variable;
  }

  TraceArgument touchArgument(TraceArgument argument) {
    for (var variable in argument.dependencies) {
      _tracer.touch(variable);
    }
    return argument;
  }

  TraceArgument traceArgument(Value Function() cb) {
    return _tracer.traceArgument(cb);
  }
}
