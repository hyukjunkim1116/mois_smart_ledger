import 'package:mois_smart_ledger/infrastructure/database.dart';
import '../models/excel_row_data.dart';

class ExcelService {



  // 검색 로직 (한 글자라도 포함되면 결과에 표시)
  Map<String, List<ExcelRowData>> search(String query) {
    if (query.isEmpty) return {};

    // 검색어와 데이터 모두 공백 제거 및 소문자화
    final cleanQuery = query.replaceAll(' ', '').toLowerCase();
    final filtered = excelRawData.where((data) {
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