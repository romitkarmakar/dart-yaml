import "Node.dart";

class MappingNode extends Node {
  Map<String, dynamic> value;

  MappingNode() {
    value = Map();
  }

  @override
  String toString() {
    String temp = "";
    value.forEach((k, v) {
      temp += "\n${Node.generateIndentation(level)}$k: $v";
    });

    return temp;
  }
}
