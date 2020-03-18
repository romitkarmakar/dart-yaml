class Node {
  String comment;
  bool isRoot;
  int level;

  Node() {
    isRoot = false;
  }

  static String generateIndentation(int level) {
    int i = 0;
    String temp = "";
    while (i < level){
      temp += " ";
      i++;
    }

    return temp;
  }

  @override
  String toString() {
    return super.toString();
  }
}