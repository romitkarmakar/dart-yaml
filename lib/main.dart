import 'dart:convert';
import 'dart:io';
import 'utils.dart';
import 'Node.dart';

void iterateNode(Node pointer) {
  // pointer.display();
  print("${pointer.value} ${pointer.comment}");
  pointer.children.forEach((v) => iterateNode(v));
}

Node movePointer(Node root, int level) {
  if (level == 0) return root;
  return movePointer(root.children[root.children.length - 1], level - 1);
}

dynamic treeToMap(Node pointer, dynamic data) {
  if (pointer.children.length > 0) {
    if (pointer.isArr) {
      data[pointer.value.substring(0, pointer.value.length - 1)] = <String>[];
      pointer.children.forEach((v) => treeToMap(
          v, data[pointer.value.substring(0, pointer.value.length - 1)]));
    } else {
      data[pointer.value.substring(0, pointer.value.length - 1)] =
          <String, dynamic>{};
      pointer.children.forEach((v) => treeToMap(
          v, data[pointer.value.substring(0, pointer.value.length - 1)]));
    }
  } else {
    if (pointer.value.trim().startsWith("-")) {
      data.add(pointer.value);
    } else {
      List<String> arr = pointer.value.split(":");
      data[arr[0].trim()] = double.tryParse(arr[1].trim()) ?? arr[1].trim();
    }
  }

  return data;
}

dynamic treeToMapWithComments(Node pointer, dynamic data) {
  if (pointer.children.length > 0) {
    if (pointer.isArr) {
      data[pointer.value.substring(0, pointer.value.length - 1)] = <String>[];
      pointer.children.forEach((v) => treeToMapWithComments(
          v, data[pointer.value.substring(0, pointer.value.length - 1)]));
    } else {
      data[pointer.value.substring(0, pointer.value.length - 1)] =
          <String, dynamic>{};
      pointer.children.forEach((v) => treeToMapWithComments(
          v, data[pointer.value.substring(0, pointer.value.length - 1)]));
    }
  } else {
    if (pointer.value.trim().startsWith("-")) {
      data.add(pointer.value);
    } else {
      List<String> arr = pointer.value.split(":");
      arr[1] = arr[1].trim() + " " + pointer.comment;
      data[arr[0].trim()] = double.tryParse(arr[1].trim()) ?? arr[1].trim();
    }
  }

  return data;
}

bool isComment(String line) {
  line = line.trim();
  final regex = RegExp(r'#.*');
  return regex.hasMatch(line) ? true : false;
}

bool isSymbol(String line) {
  int i = 0;
  while (line[i] != "&") {
    i++;
    if (i == line.length) break;
  }

  return i == line.length ? false : true;
}

String spaceGenerator(int level) {
  String result = "";
  int i = 0;
  while (i < level) {
    result += "  ";
    i++;
  }

  return result;
}

String MapToYaml(dynamic data, String result, int level) {
  data.forEach((k, v) {
    if (v is Map) {
      result += "${spaceGenerator(level)}$k: \n${MapToYaml(v, "", level + 1)}";
    } else if (v is List) {
      result += "${spaceGenerator(level)}$k: \n";
      v.forEach((f) => result += "${spaceGenerator(level + 1)} $f \n");
    } else {
      result += "${spaceGenerator(level)}$k: $v\n";
    }
  });

  return result;
}

void writeToFile(filename, String data, Map<int, String> comments) {
  List<String> arr = data.split("\n");
  comments.forEach((k, v) {
    arr.insert(k, v);
  });
  data = arr.join("\n");
  new File(filename).writeAsString(data).then((File file) {
    print("Operation Done");
  });
}

String removeComments(String line) {
  return line.replaceAllMapped(RegExp(r'#.*'), (match) {
    return '';
  });
}

Future<void> main() async {
  File yaml = new File('test.yaml');
  Node root = new Node.fromValue("root:");
  Map<String, dynamic> tempMap = new Map();
  Map<String, List<int>> symbols = new Map();
  Map<int, String> comments = new Map();

  Stream<List<int>> inputStream = yaml.openRead();
  int i = 0;

  inputStream.transform(utf8.decoder).transform(new LineSplitter()).listen(
      (String line) {
    if(line.length == 0) return;
    RegExp e = new RegExp(r'#.*');
    int level = getIndentationLevel(line);
    line = line.trim();
    String comment = e.stringMatch(line);
    line = removeComments(line);
    if (line.length == 0) {
      comments[i] = comment;
      i++;
      return;
    }

    if (line.startsWith("-")) movePointer(root, level).isArr = true;
    Node tempN = new Node.fromValue(line);
    if (comment != null) tempN.comment = comment;
    movePointer(root, level).children.add(tempN);
    // if (isSymbol(line))
    //   symbols[line] = [
    //     level + 1,
    //     movePointer(root, level).children.length - 1
    //   ];
    i++;
  }, onDone: () {
    //iterateNode(root);
    // movePointer(root, 1).children[2].display();
    // root.children[0].children[3].children.forEach((v) => v.display());
    dynamic temp = treeToMapWithComments(root, tempMap);
    temp["root"]["dependencies"]["mypackage"] = "1.23.1";
    // comments.forEach((k, v) {
    //   print("${k} ${v}");
    // });
    writeToFile("new.yaml",
        MapToYaml(temp["root"], "", 0), comments);
  }, onError: (e) {
    return {};
  });
}
