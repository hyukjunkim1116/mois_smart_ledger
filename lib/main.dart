import 'package:flutter/material.dart';
import 'package:mois_smart_ledger/infrastructure/repository.dart';
import 'services/excel_service.dart';
import 'models/raw_data.dart';

void main() => runApp(const MoisSmartLedger());

class MoisSmartLedger extends StatelessWidget {
  const MoisSmartLedger({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(fontFamily: 'Pretendard', colorSchemeSeed: Colors.indigo),
      home: const InitialLoader(),
    );
  }
}

class InitialLoader extends StatelessWidget {
  const InitialLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataRepository.init(), // 데이터 초기화 호출
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // 로딩 완료 시 메인 화면으로 이동
          return const SearchPage();
        } else {
          // 로딩 중일 때 보여줄 UI
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        }
      },
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
        title: const Text('비영리법인 명칭 검색하기',
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
      padding: const EdgeInsets.all(8),
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
                  Expanded(
                      child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  )),
                  const SizedBox(width: 2), // 제목과 배지 사이의 간격
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
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
    final displayDate = item.permitDate.contains('T')
        ? item.permitDate.split('T')[0]
        : item.permitDate;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: Colors.indigo.withOpacity(0.05),
                  width: 1,
                ),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              item.remit.isEmpty ? '-' : item.remit,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.indigo,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.account_balance_outlined, '법인성격', item.type),
          _buildInfoRow(Icons.calendar_today_outlined, '허가일자', displayDate),
          _buildInfoRow(Icons.gavel_rounded, '근거법률', item.law),
          _buildInfoRow(Icons.description_outlined, '기능/목적', item.purpose),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: Colors.indigo),
          const SizedBox(width: 4),
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
