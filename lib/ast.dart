class Node {
  String value;
  Node left;
  Node right;
  String comment;
  
  Node(String a) {
    value = a;
  }

  void display() {
    print(value);
  }
}