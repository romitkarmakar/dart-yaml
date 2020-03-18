import "Node.dart";

class ScalarNode extends Node {
  String value;

  @override
  String toString() {
    return "$value";
  }
}