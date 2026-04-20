import 'package:flutter/services.dart' show rootBundle;
import 'package:excel/excel.dart' as excel_pkg;
import '../models/excel_row_data.dart';

class ExcelService {
  List<ExcelRowData> _allData = [];

  // 엑셀 로드
  Future<void> loadData() async {
    try {
      final data = await rootBundle.load('data.xlsx');
      final bytes = data.buffer.asUint8List();
      final excel = excel_pkg.Excel.decodeBytes(bytes);

      List<ExcelRowData> loadedData = [];

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table]!;
        // 5행부터 데이터 읽기
        for (int i = 4; i < sheet.maxRows; i++) {
          var row = sheet.row(i);
          if (row.length < 3) continue;

          final name = row[2]?.value?.toString().trim() ?? "";
          if (name.isEmpty) continue;

          loadedData.add(ExcelRowData(
            permitDate: row[1]?.value?.toString() ?? "",
            name: name,
            purpose: row[3]?.value?.toString() ?? "",
            law: row[4]?.value?.toString() ?? "",
            type: row[5]?.value?.toString() ?? "",
          ));
        }
      }
      _allData = loadedData;
    } catch (e) {
      print("엑셀 로드 중 오류 발생: $e");
      _allData = []; // 에러 발생 시 빈 리스트로 초기화하여 무한 로딩 방지
    }
  }

  // 검색 로직 (한 글자라도 포함되면 결과에 표시)
  Map<String, List<ExcelRowData>> search(String query) {
    if (query.isEmpty) return {};

    // 검색어와 데이터 모두 공백 제거 및 소문자화
    final cleanQuery = query.replaceAll(' ', '').toLowerCase();
    final filtered = _allData.where((data) {
      final cleanName = data.name.replaceAll(' ', '').toLowerCase();

      return cleanName.contains(cleanQuery);
    }).toList();

    // 그룹화 로직
    Map<String, List<ExcelRowData>> groups = {};
    for (var item in filtered) {
      groups.putIfAbsent(item.name, () => []).add(item);
    }
    var sortedKeys = groups.keys.toList()..sort();
    Map<String, List<ExcelRowData>> sortedGroups = {
      for (var key in sortedKeys) key: groups[key]!
    };

    return sortedGroups; // groups 대신
  }
}