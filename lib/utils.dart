import 'dart:convert';
import 'dart:io';
 


Future<Map<String, String>> yamlToJson(fileName) async {
  File yaml = new File(fileName);
  Map<String, String> data = new Map();

  Stream<List<int>> inputStream = yaml.openRead();

  inputStream.transform(utf8.decoder).transform(new LineSplitter()).listen(
      (String line) {
    data[line.split(":")[0]] = line.split(":")[1];
  }, onDone: () {
    print(data);
    return data;
  }, onError: (e) {
    return {};
  });
}

String JsonToMap(Map<String, String> data) {
  String temp = "";
  data.forEach((k, v) => temp += "${k}: ${v}\r\n");

  return temp.substring(0, temp.length - 2);
}

void writeToFile(filename, String data) {
  new File(filename).writeAsString(data).then((File file) {
    print("Operation Done");
  });
}