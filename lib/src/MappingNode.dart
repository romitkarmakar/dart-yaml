import "Node.dart";

class MappingNode extends Node {
  String key;
  List<Node> value;

  MappingNode() {
    value = <Node>[];
  }

  @override
  String toString() {
    String temp = "";
    if (!isRoot) {
      temp = "${Node.generateIndentation(0)}$key: \n";
      value.forEach((f) {
        temp += "${Node.generateIndentation(1)}$f";
      });
    } else {
      value.forEach((f) {
        temp += "${Node.generateIndentation(0)}$f";
      });
    }
    return temp;
  }
}
