import 'dart:convert';

String getCurrentDate() {
  DateTime now = DateTime.now();
  String year = now.year.toString();
  String month = now.month.toString().padLeft(2, '0'); // 한 자리 수일 경우 앞에 '0'을 추가
  String day = now.day.toString().padLeft(2, '0'); // 한 자리 수일 경우 앞에 '0'을 추가

  return "$year-$month-$day";
}

int getDateDifference(String startDate, String endDate) {
  DateTime start = DateTime.parse(startDate);
  DateTime end = DateTime.parse(endDate);
  Duration difference = end.difference(start);

  return difference.inDays;
}

String convertDateFormat(String originalDate) {
  // 'yyyy-MM-dd' 형식에서 연도, 월, 일을 추출합니다.
  String year = originalDate.substring(0, 4);
  String month = originalDate.substring(5, 7);
  String day = originalDate.substring(8, 10);

  // 월과 일 앞의 0을 제거합니다 (예: '01' -> '1').
  month = month.startsWith('0') ? month.substring(1) : month;
  day = day.startsWith('0') ? day.substring(1) : day;

  // 'm월 d일' 형식으로 조합합니다.
  return '$month월 $day일';
}

dynamic safeParseJson(String inputStr) {
  try {
    return jsonDecode(inputStr);
  } catch (e) {
    int firstCurly = inputStr.indexOf('{');
    int lastCurly = inputStr.lastIndexOf('}');

    if (firstCurly == -1 || lastCurly == -1 || firstCurly >= lastCurly) {
      return "Parsing Error";
    }

    String jsonString = inputStr.substring(firstCurly, lastCurly + 1);
    return jsonDecode(jsonString);
  }
}
