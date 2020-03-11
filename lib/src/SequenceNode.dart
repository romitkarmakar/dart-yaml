import "Node.dart";

class SequenceNode extends Node {
  String key;
  List<String> value;
  SequenceNode() {
    value = <String>[];
  }
  @override
  String toString() {
    String temp = "${Node.generateIndentation(0)}$key: \n";
    value.forEach((f) {
      temp += "${Node.generateIndentation(1)} - $f \n";
    });

    return temp;
  }
}