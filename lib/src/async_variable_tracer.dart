// Copyright 2016 Google Inc. Use of this source code is governed by an
// MIT-style license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'trace_variable.dart';
import './trace_argument.dart';
import 'value.dart';

class AsyncVariableTracer {
  static final AsyncVariableTracer _singleton = AsyncVariableTracer._();

  AsyncVariableTracer._();

  factory AsyncVariableTracer() {
    return _singleton;
  }

  final List<Set<TraceVariable>> _batch = [];

  Set<TraceVariable>? get _deps => _batch.lastOrNull;

  Future<(T, Set<TraceVariable>)> traceReads<T>(Future<T> Function() cb) async {
    var deps = <TraceVariable>{};
    _batch.add(deps);
    var result = await cb();

    _batch.removeLast();
    return (result, deps);
  }

  void touch(TraceVariable variable) {
    _deps?.add(variable);
  }

  Future<TraceArgument> traceArgument(Future<Value> Function() cb) async {
    var (value, dependencies) = await traceReads(cb);
    return TraceArgument(value, dependencies);
  }
}

mixin AsyncVariableTracerMixin {
  final AsyncVariableTracer _tracer = AsyncVariableTracer();

  Future<(T, Set<TraceVariable>)> traceReadVariables<T>(
          Future<T> Function() cb) =>
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

  Future<TraceArgument> traceArgument(Future<Value> Function() cb) {
    return _tracer.traceArgument(cb);
  }
}
