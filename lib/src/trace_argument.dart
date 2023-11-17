import 'trace_variable.dart';
import 'value.dart';

final class TraceArgument {
  final Value value;
  final Set<TraceVariable> dependencies;

  TraceArgument(this.value, [this.dependencies = const <TraceVariable>{}]);
}
