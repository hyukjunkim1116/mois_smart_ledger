import 'dart:io';
import 'package:excel/excel.dart';

void main() {
  var file = "assets/data.xlsx";
  var bytes = File(file).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  // 1. 시작 부분 출력
  print("const List<ExcelRowData> RAW_DATA = [");

  for (var table in excel.tables.keys) {
    var sheet = excel.tables[table];
    if (sheet == null) continue;

    for (int i = 4; i < sheet.maxRows; i++) {
      var row = sheet.rows[i];

      // 데이터 추출 및 특수문자 처리 (따옴표 이스케이프)
      String permitDate = row[1]?.value?.toString().split("T")[0] .replaceAll('"', '\\"')             // 따옴표 이스케이프
          .replaceAll(RegExp(r'\r?\n'), ' ') // \n 또는 \r\n을 공백으로 치환
          .trim() ?? "";
      String name = (row[2]?.value?.toString() ?? "").replaceAll('"', '\\"')             // 따옴표 이스케이프
          .replaceAll(RegExp(r'\r?\n'), ' ') // \n 또는 \r\n을 공백으로 치환
          .trim();
      String purpose = (row[3]?.value?.toString() ?? "")
          .replaceAll('"', '\\"')             // 따옴표 이스케이프
          .replaceAll(RegExp(r'\r?\n'), ' ') // \n 또는 \r\n을 공백으로 치환
          .trim();
      String law = (row[4]?.value?.toString() ?? "").replaceAll('"', '\\"')             // 따옴표 이스케이프
          .replaceAll(RegExp(r'\r?\n'), ' ') // \n 또는 \r\n을 공백으로 치환
          .trim();
      String type = (row[5]?.value?.toString() ?? "").replaceAll('"', '\\"')             // 따옴표 이스케이프
          .replaceAll(RegExp(r'\r?\n'), ' ') // \n 또는 \r\n을 공백으로 치환
          .trim();

      // 2. 클래스 생성자 형식으로 출력
      print('''  ExcelRowData(
    permitDate: "$permitDate",
    name: "$name",
    purpose: "$purpose",
    law: "$law",
    type: "$type",
  ),''');
    }
  }

  // 3. 끝 부분 출력
  print("];");
}