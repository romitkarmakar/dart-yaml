import "Node.dart";

class ScalarNode extends Node {
  String key;
  String value;

  @override
  String toString() {
    return "${Node.generateIndentation(0)}$key: $value \n";
  }
}