import 'package:js/js.dart';
import 'package:sass/src/js/array.dart';
import '../variable_trace_graph.dart';

@JS()
@anonymous
class JSVariableTrace {
  external JSArray variables;
  external JSArray dependencies;

  external factory JSVariableTrace({required variables, required dependencies});
}

@JS()
@anonymous
class JSTraceVariable {
  external String name;
  external String expression;
  external bool isRoot;
  external bool isArgument;

  external factory JSTraceVariable(
      {required name,
      required expression,
      required isRoot,
      required isArgument});
}

JSVariableTrace makeJSVariableTraceGraph(VariableTraceGraph graph) {
  var dependencies = JSArray();
  var variables = JSArray();

  for (var variable in graph.variables) {
    // variables.push(JSTraceVariable(
    //     name: variable.name,
    //     expression: variable.nodeWithSpan.toString(),
    //     isRoot: variable.isRoot,
    //     isArgument: variable.isArgument));
    variables.push(variable.toJson(true));
  }

  for (var element in graph.dependencies) {
    var list = JSArray();
    for (var id in element) {
      list.push(id);
    }
    dependencies.push(list);
  }

  return JSVariableTrace(variables: variables, dependencies: dependencies);
}
