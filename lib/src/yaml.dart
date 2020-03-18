import 'dart:async';
import 'AST.dart';
import 'dart:io';

/// Read yaml from file
Future<TreeNode> readFromFile(String fileName) async {
  AST tree = AST();
  File file = new File(fileName);
  String futureContent = await file.readAsString();
  List<String> arr = futureContent.split('\n');
  arr.forEach((f) {
    tree.addNode(f);
  });

  return tree.root;
}

/// Read yaml from string
Future<TreeNode> readFromString(String content) async {
  AST tree = AST();
  List<String> arr = content.split('\n');
  arr.forEach((f) {
    tree.addNode(f);
  });

  return tree.root;
}