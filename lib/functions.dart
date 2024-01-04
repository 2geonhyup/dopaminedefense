import 'dart:convert';

String getCurrentDate() {
  DateTime now = DateTime.now();
  String year = now.year.toString();
  String month = now.month.toString().padLeft(2, '0'); // 한 자리 수일 경우 앞에 '0'을 추가
  String day = now.day.toString().padLeft(2, '0'); // 한 자리 수일 경우 앞에 '0'을 추가

  return "$year-$month-$day";
}

String getKoreanWeekday(DateTime date) {
  List<String> weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  return weekdays[date.weekday - 1];
}

String getDateWithWeekday() {
  DateTime now = DateTime.now();
  String formattedDate = '${now.month}월 ${now.day}일 (${getKoreanWeekday(now)})';
  return formattedDate;
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

List<String> splitStringEvenly(String text) {
  List<String> words = text.split(' ');
  String firstPart = '';
  String secondPart = '';
  int firstPartLength = 0;

  // 전체 길이의 절반을 계산
  int halfLength = text.replaceAll(' ', '').length ~/ 2;

  for (var word in words) {
    if ((firstPartLength + word.length) <= halfLength) {
      firstPart = (firstPart.isEmpty) ? word : '$firstPart $word';
      firstPartLength += word.length;
    } else {
      secondPart = (secondPart.isEmpty) ? word : '$secondPart $word';
    }
  }

  return [firstPart, secondPart];
}
