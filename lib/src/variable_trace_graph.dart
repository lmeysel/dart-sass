import 'trace_variable.dart';

class VariableTraceGraph {
  final dependencies = <Set<int>>[];
  final variables = <TraceVariable>[];

  VariableTraceGraph(Set<TraceVariable> variables) {
    _computeGraph(variables, {});
  }

  Map<String, dynamic> toJson() {
    return {
      'dependencies': dependencies.map((inner) => inner.toList()).toList(),
      'variables': variables.map((e) => e.toJson(true)).toList()
    };
  }

  Set<int> _computeGraph(
    Set<TraceVariable> variables,
    Map<TraceVariable, int> idMap,
  ) {
    return variables.map((variable) {
      if (!idMap.containsKey(variable)) {
        idMap[variable] = idMap.length;
        this.variables.add(variable);
        dependencies.add(_computeGraph(variable.dependencies, idMap));
      }

      return idMap[variable]!;
    }).toSet();
  }
}
