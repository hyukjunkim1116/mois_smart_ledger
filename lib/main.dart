import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
// 1. excel 패키지에 별칭(as excel_pkg)을 붙입니다.
import 'package:excel/excel.dart' as excel_pkg;

void main() {
  runApp(const MoisSmartLedger());
}

class MoisSmartLedger extends StatelessWidget {
  const MoisSmartLedger({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '중복 데이터 분석기',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      home: const UploadPage(),
    );
  }
}

class ExcelRowData {
  final int rowIdx;
  final List<String> columnValues;

  ExcelRowData({required this.rowIdx, required this.columnValues});
}

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool _isProcessing = false;

  Future<void> _pickExcelFile() async {
    setState(() => _isProcessing = true);

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        withData: true,
      );

      if (result != null && result.files.first.bytes != null) {
        final bytes = result.files.first.bytes!;
        // 2. Excel 클래스 앞에 별칭을 붙여서 사용합니다.
        final excel = excel_pkg.Excel.decodeBytes(bytes);

        Map<String, List<ExcelRowData>> duplicateMap = {};

        for (var table in excel.tables.keys) {
          var sheet = excel.tables[table]!;

          for (int i = 4; i < sheet.maxRows; i++) {
            var row = sheet.row(i);
            if (row.length < 3) continue;

            var cCellValue = row[2]?.value?.toString().trim() ?? "";
            if (cCellValue.isEmpty) continue;

            List<String> rowDataList = [];
            for (int j = 0; j < 6; j++) {
              rowDataList.add(row.length > j ? row[j]?.value?.toString() ?? "" : "");
            }

            var data = ExcelRowData(rowIdx: i + 1, columnValues: rowDataList);

            if (duplicateMap.containsKey(cCellValue)) {
              duplicateMap[cCellValue]!.add(data);
            } else {
              duplicateMap[cCellValue] = [data];
            }
          }
        }

        duplicateMap.removeWhere((key, value) => value.length < 2);

        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(duplicates: duplicateMap),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('파일 분석 중 오류 발생: $e')),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MOIS 비영리법인 명칭 중복 확인하기 테스토')),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.analytics_outlined, size: 100, color: Colors.indigo),
            const SizedBox(height: 30),
            const Text(
              '엑셀 파일을 업로드하여\n중복 데이터를 확인하세요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 40),
            _isProcessing
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
              onPressed: _pickExcelFile,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.file_upload),
              label: const Text('엑셀 파일 선택', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final Map<String, List<ExcelRowData>> duplicates;

  const ResultPage({super.key, required this.duplicates});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('중복 분석 결과'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: duplicates.isEmpty
          ? const Center(child: Text('중복된 이름이 없습니다! 🎉'))
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: duplicates.length,
        itemBuilder: (context, index) {
          String name = duplicates.keys.elementAt(index);
          List<ExcelRowData> items = duplicates[name]!;

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              title: Text(
                name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 17, color: Colors.redAccent),
              ),
              subtitle: Text('중복 횟수: ${items.length}회'),
              children: items.map((data) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    // 이제 여기서 Border는 Flutter의 Border로 정상 인식됩니다.
                    border: Border(top: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📍 위치: ${data.rowIdx}행',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        runSpacing: 5,
                        children: [
                          _dataChip('연번', data.columnValues[0]),
                          _dataChip('허가 연월일', data.columnValues[1]),
                          _dataChip('법인 명칭', data.columnValues[2]),
                          _dataChip('기능 및 목적', data.columnValues[3]),
                          _dataChip('근거 법률', data.columnValues[4]),
                          _dataChip('법인 성적', data.columnValues[5]),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _dataChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}