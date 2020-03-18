import "Node.dart";

class SequenceNode extends Node {
  List<String> value;
  SequenceNode() {
    value = <String>[];
  }
  @override
  String toString() {
    String temp = "\n";
    value.forEach((f) {
      temp += "${Node.generateIndentation(level)}- $f \n";
    });

    return temp;
  }
}