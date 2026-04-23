import 'package:mois_smart_ledger/infrastructure/부/%EA%B3%A0%EC%9A%A9%EB%85%B8%EB%8F%99%EB%B6%80.dart';
import 'package:mois_smart_ledger/infrastructure/부/%EA%B3%BC%EA%B8%B0%EB%B6%80.dart';
import 'package:mois_smart_ledger/infrastructure/부/%EA%B5%90%EC%9C%A1%EB%B6%80.dart';
import 'package:mois_smart_ledger/infrastructure/부/%EA%B5%AD%EA%B0%80%EB%B3%B4%ED%9B%88%EB%B6%80.dart';
import 'package:mois_smart_ledger/infrastructure/부/%EA%B5%AD%EB%B0%A9%EB%B6%80.dart';
import 'package:mois_smart_ledger/infrastructure/부/%EA%B5%AD%ED%86%A0%EA%B5%90%ED%86%B5%EB%B6%80.dart';
import 'package:mois_smart_ledger/infrastructure/부/%EA%B8%B0%ED%9B%84%EC%97%90%EB%84%88%EC%A7%80%ED%99%98%EA%B2%BD%EB%B6%80.dart';
import 'package:mois_smart_ledger/infrastructure/부/%EB%86%8D%EB%A6%BC%EC%B6%95%EC%82%B0%EC%8B%9D%ED%92%88%EB%B6%80.dart';
import 'package:mois_smart_ledger/infrastructure/부/%EB%AC%B8%EC%B2%B4%EB%B6%80.dart';
import 'package:mois_smart_ledger/infrastructure/부/%EB%B2%95%EB%AC%B4%EB%B6%80.dart';
import 'package:mois_smart_ledger/infrastructure/부/%EB%B3%B4%EA%B1%B4%EB%B3%B5%EC%A7%80%EB%B6%80.dart';
import 'package:mois_smart_ledger/infrastructure/부/%EC%82%B0%EC%97%85%ED%86%B5%EC%83%81%EB%B6%80.dart';
import 'package:mois_smart_ledger/infrastructure/부/%EC%84%B1%ED%8F%89%EB%93%B1%EA%B0%80%EC%A1%B1%EB%B6%80.dart';
import 'package:mois_smart_ledger/infrastructure/부/%EC%99%B8%EA%B5%90%EB%B6%80.dart';
import 'package:mois_smart_ledger/infrastructure/부/%EC%9E%AC%EC%A0%95%EA%B2%BD%EC%A0%9C%EB%B6%80.dart';
import 'package:mois_smart_ledger/infrastructure/부/%EC%A4%91%EC%86%8C%EB%B2%A4%EC%B2%98%EA%B8%B0%EC%97%85%EB%B6%80.dart';
import 'package:mois_smart_ledger/infrastructure/부/%ED%86%B5%EC%9D%BC%EB%B6%80.dart';
import 'package:mois_smart_ledger/infrastructure/부/%ED%95%B4%EC%96%91%EC%88%98%EC%82%B0%EB%B6%80.dart';
import 'package:mois_smart_ledger/infrastructure/부/%ED%96%89%EC%A0%95%EC%95%88%EC%A0%84%EB%B6%80.dart';
import 'package:mois_smart_ledger/models/raw_data.dart';
class DataRepository {
  // 전체 데이터를 담을 싱글톤 변수
  static List<ExcelRowData> all_data = [];

  static Future<void> init() async {

    all_data = [
      ...moelRawData,
      ...msitRawData,
      ...moeRawData,
      ...mpvaRawData,
      ...mndRawData,
      ...molitRawData,
      ...mceeRawData,
      ...mafraRawData,
      ...mcstRawData,
      ...mojRawData,
      ...mohwRawData,
      ...motirRawData,
      ...mogefRawData,
      ...mofaRawData,
      ...mofeRawData,
      ...mssRawData,
      ...mowRawData,
      ...mofRawData,
      ...moisRawData,
    ];
  }
}
