class Node {
  String value;
  bool isArr;
  List<Node> children;
  String comment;

  Node() {
    value = "";
    children = <Node>[];
    isArr = false;
    comment = "";
  }

  Node.fromValue(String line) {
    value = line;
    children = <Node>[];
    isArr = false;
    comment = "";
  }

  void display() {
    print(value);
  }
}

class AST extends Node {
  Node root;

  AST() {
    root = new Node();
  }
}
