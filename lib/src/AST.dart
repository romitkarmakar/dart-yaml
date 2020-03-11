import 'package:dartyaml/src/MappingNode.dart';
import 'package:dartyaml/src/ScalarNode.dart';
import 'package:dartyaml/src/SequenceNode.dart';

/// This class helps to generate the Abstract Syntax Tree from the yaml to easily work with the YAML file.

class TreeNode {
  int level;
  String value;
  bool isArr;
  List<TreeNode> children;

  TreeNode() {
    isArr = false;
    children = <TreeNode>[];
  }
}

class AST {
  TreeNode root;
  Map<int, String> comments;

  AST() {
    root = TreeNode();
    comments = new Map();
  }

  bool isComment(String line) {
    line = line.trim();
    final regex = RegExp(r'#.*');
    return regex.hasMatch(line) ? true : false;
  }

  String removeComments(String line) {
    return line.replaceAllMapped(RegExp(r'#.*'), (match) {
      return '';
    });
  }

  int getIndentationLevel(String line) {
    int i = 0;
    while (line[i] == " ") {
      i++;
    }
    return (i / 2).round();
  }

  static TreeNode movePointer(TreeNode root, int level) {
    if (level == 0) return root;
    return movePointer(root.children[root.children.length - 1], level - 1);
  }

  bool addNode(int index, String line) {
    if (line.length == 0) return false;

    // Move pointer to required child
    TreeNode temp = TreeNode();
    temp.level = getIndentationLevel(line);
    TreeNode pointer = AST.movePointer(root, temp.level);

    // Extract comment from the line
    String comment = RegExp(r'#.*').stringMatch(line);
    line = removeComments(line);

    // Add comments to comments array.
    line = line.trim();
    if (line.length == 0) {
      if (comment != null) comments[index] = comment;
      return false;
    }

    // Check it is array or map
    if (line.startsWith("-")) {
      pointer.isArr = true;
      temp.value = line.replaceAllMapped(RegExp(r'^-'), (match) {
        return '';
      });
      temp.value = temp.value.trim();
      pointer.children.add(temp);

      return true;
    } else {
      temp.value = line;
      pointer.children.add(temp);

      return true;
    }
  }

  static void iterateTree(TreeNode pointer) {
    print(pointer.value);
    pointer.children.forEach((f) => iterateTree(f));
  }

  String injectComments(String data) {
    List<String> arr = data.split("\n");
    comments.forEach((k, v) {
      arr.insert(k, v);
    });
    data = arr.join("\n");

    return data;
  }

  static dynamic treeToMap(TreeNode root) {
    if (root.children.length > 0) {
      if (root.isArr) {
        SequenceNode temp = SequenceNode();
        temp.key = root.value;
        root.children.forEach((f) => temp.value.add(f.value));
        return temp;
      } else {
        MappingNode temp = MappingNode();
        temp.key = root.value;
        root.children.forEach((f) => temp.value.add(treeToMap(f)));
        return temp;
      }
    } else {
      ScalarNode temp = ScalarNode();
      List<String> arr = root.value.split(":");
      temp.key = arr[0];
      temp.value = arr[1];

      return temp;
    }
  }
}
