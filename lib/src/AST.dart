import 'package:dartyaml/src/MappingNode.dart';
import 'package:dartyaml/src/ScalarNode.dart';
import 'package:dartyaml/src/SequenceNode.dart';

import 'Node.dart';

/// This class helps to generate the Abstract Syntax Tree from the yaml to easily work with the YAML file.

class TreeNode {
  int level;
  String value;
  bool isArr;
  List<TreeNode> children;

  TreeNode() {
    level = 0;
    isArr = false;
    children = <TreeNode>[];
  }
}

class AST {
  TreeNode root;
  Map<int, String> comments;
  int commentIndex;

  AST() {
    commentIndex = 0;
    root = TreeNode();
    root.value = "root";
    comments = new Map();
  }

  /// Returns whether the string contains comment or not.
  bool isComment(String line) {
    line = line.trim();
    final regex = RegExp(r'#.*');
    return regex.hasMatch(line) ? true : false;
  }

  /// Removes all the comment from the line.
  String removeComments(String line) {
    return line.replaceAllMapped(RegExp(r'#.*'), (match) {
      return '';
    });
  }

  /// Returns the tree level for the line.
  int getIndentationLevel(String line) {
    int i = 0;
    while (line[i] == " ") {
      i++;
    }
    return (i / 2).round();
  }

  /// Move the pointer to required tree level.
  static TreeNode movePointer(TreeNode root, int level) {
    if (level == 0) return root;
    return movePointer(root.children[root.children.length - 1], level - 1);
  }

  // Inputs a line and genrate a node for the tree.
  bool addNode(String line) {
    commentIndex++;
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
      if (comment != null)
        comments[commentIndex] = comment;
      else
        comments[commentIndex] = "\n";
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

  /// Print all the nodes in the tree.
  static void iterateTree(TreeNode pointer) {
    print("${Node.generateIndentation(pointer.level)}${pointer.value}");
    pointer.children.forEach((f) => iterateTree(f));
  }

  /// Inject comments in the final string generated from ast.
  String injectComments(String data) {
    List<String> arr = data.split("\n");
    comments.forEach((k, v) {
      arr.insert(k, v);
    });
    data = arr.join("\n");

    return data;
  }

  /// Generates a map from the AST.
  static dynamic treeToMap(dynamic result, TreeNode root) {
    if (root.children.length > 0) {
      if (root.isArr) {
        List<String> arr = root.value.split(':');
        result.value[arr[0]] = SequenceNode();
        result.value[arr[0]].level = root.level;
        root.children.forEach((f) {
          result.value[arr[0]].value.add(f);
        });

        return result;
      } else {
        List<String> arr = root.value.split(':');
        result.value[arr[0]] = MappingNode();
        result.value[arr[0]].level = root.level;
        root.children.forEach((f) {
          result.value[arr[0]] = treeToMap(result.value[arr[0]], f);
        });

        return result;
      }
    } else {
      List<String> arr = root.value.split(':');
      result.value[arr[0]] = ScalarNode();
      result.level = root.level;
      result.value[arr[0]].value = arr[1];

      return result;
    }
  }
}
