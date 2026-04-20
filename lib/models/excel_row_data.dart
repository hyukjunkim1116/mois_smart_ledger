class ExcelRowData {
  final String permitDate;   // 허가일
  final String name;         // 법인명칭
  final String purpose;      // 목적
  final String law;          // 근거법률
  final String type;

  const ExcelRowData({
    required this.permitDate,
    required this.name,
    required this.purpose,
    required this.law,
    required this.type
  });
}