import 'package:flutter/material.dart';
import 'services/excel_service.dart';
import 'models/excel_row_data.dart';

void main() => runApp(const MoisSmartLedger());

class MoisSmartLedger extends StatelessWidget {
  const MoisSmartLedger({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(fontFamily: 'Pretendard', colorSchemeSeed: Colors.indigo),
      home: const SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ExcelService _excelService = ExcelService();
  final TextEditingController _searchController = TextEditingController();
  Map<String, List<ExcelRowData>> _groupedResults = {};

  void _handleSearch(String query) {
    setState(() {
      _groupedResults = _excelService.search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MOIS 명칭 검색하기',
            style: TextStyle(fontWeight: FontWeight.w800)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildSearchInput(),
          _buildResultList(),
        ],
      ),
    );
  }

  Widget _buildSearchInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.indigo.withOpacity(0.05),
      child: TextField(
        controller: _searchController,
        onChanged: _handleSearch,
        decoration: InputDecoration(
          hintText: '검색할 명칭 입력 (예: 대한)',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildResultList() {
    final names = _groupedResults.keys.toList();
    if (names.isEmpty) {
      return Expanded(
        child: Center(
            child: Text(
                _searchController.text.isEmpty ? '검색어를 입력하세요' : '결과가 없습니다')),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          final name = names[index];
          final items = _groupedResults[name]!;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide.none,
            ),
            child: ExpansionTile(
              shape: const Border(),
              collapsedShape: const Border(),
              title: Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(width: 2), // 제목과 배지 사이의 간격
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: Text(
                      '${items.length}건',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              children: items.asMap().entries.map((entry) {
                int idx = entry.key;
                ExcelRowData item = entry.value;
                bool isLast = idx == items.length - 1; // 마지막 아이템인지 판별
                return _buildDetail(item, isLast);
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetail(ExcelRowData item, bool isLast) {
    // 날짜에서 'T' 이후 문자열 제거 (예: 2023-10-27T00:00:00 -> 2023-10-27)
    final displayDate = item.permitDate.contains('T')
        ? item.permitDate.split('T')[0]
        : item.permitDate;

    return Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.indigo[50], // 기존 color를 여기로 이동
          border: isLast
              ? null // 마지막 아이템이면 보더 없음
              : Border(
                  bottom: BorderSide(
                    color: Colors.indigo.withOpacity(0.2), // 선 색상 (연한 인디고)
                    width: 1, // 선 두께
                  ),
                ),
        ),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 영역: 유형과 날짜

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      '법인성격: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item.type.isEmpty ? '-' : item.type,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      '허가 연월일: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      displayDate,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      '근거법률: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item.law.isEmpty ? '-' : item.law,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      '기능 및 목적: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item.purpose.isEmpty ? '-' : item.purpose,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            )));
  }
}
