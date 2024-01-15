import 'dart:async';

import 'package:dopamine_defense_1/functions.dart';
import 'package:dopamine_defense_1/models/defense.dart';
import 'package:dopamine_defense_1/pages/summary_page.dart';
import 'package:dopamine_defense_1/widgets/navigate_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class ReadingPage extends StatelessWidget {
  final DefenseModel todayDefense;
  const ReadingPage({Key? key, required this.todayDefense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Route _createRoute() {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SummaryPage(todayDefense: todayDefense),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: Duration(seconds: 1), // 전환 지속 시간을 1초로 설정
      );
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 60, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getDateWithWeekday(), style: textStyle),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(text: "오늘의 ", style: subTitleStyle),
                          TextSpan(
                              text: "디펜스",
                              style: subTitleStyle.copyWith(color: pointColor))
                        ]),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 19,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      color: backGrey,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            todayDefense.content,
                            style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 17,
                                height: 1.7,
                                fontWeight: FontWeight.w400,
                                color: black1),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// import 'dart:async';
//
// import 'package:dopamine_defense_1/functions.dart';
// import 'package:dopamine_defense_1/models/defense.dart';
// import 'package:dopamine_defense_1/widgets/navigate_button.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import '../constants.dart';
//
// class ReadingPage extends StatefulWidget {
//   final DefenseModel todayDefense;
//   const ReadingPage({Key? key, required this.todayDefense}) : super(key: key);
//
//   @override
//   State<ReadingPage> createState() => _ReadingPageState();
// }
//
// class _ReadingPageState extends State<ReadingPage> {
//   final TextEditingController _controller = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//   bool _keyboardVisible = false;
//
//   int _seconds = 300;
//   int _sec = 0;
//   int _min = 5;
//   late Timer _timer;
//
//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_seconds > 0) {
//           _seconds--;
//           _sec = _seconds % 60;
//           _min = _seconds ~/ 60;
//         }
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _timer.cancel();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//     _focusNode.addListener(() {
//       if (_focusNode.hasFocus) {
//         setState(() => _keyboardVisible = true);
//       } else {
//         setState(() => _keyboardVisible = false);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 20.0, top: 60, right: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(getDateWithWeekday(), style: textStyle),
//                       RichText(
//                         text: TextSpan(children: [
//                           TextSpan(text: "오늘의 ", style: subTitleStyle),
//                           TextSpan(
//                               text: "디펜스",
//                               style: subTitleStyle.copyWith(color: pointColor))
//                         ]),
//                       ),
//                     ],
//                   ),
//                   TimerWidget(
//                     sec: _sec,
//                     min: _min,
//                     seconds: _seconds,
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 19,
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 15),
//                   color: backGrey,
//                   child: ListView(
//                     padding: EdgeInsets.zero,
//                     children: [
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Text(
//                         widget.todayDefense.content,
//                         style: TextStyle(
//                             fontFamily: 'Pretendard',
//                             fontSize: 17,
//                             height: 1.7,
//                             fontWeight: FontWeight.w400,
//                             color: black1),
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             SummaryField(
//               controller: _controller,
//               focusNode: _focusNode,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class TimerWidget extends StatelessWidget {
//   final int seconds;
//   final int sec;
//   final int min;
//   const TimerWidget(
//       {Key? key, required this.seconds, required this.sec, required this.min})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         SizedBox(
//           width: 49,
//           height: 49,
//           child: CircularProgressIndicator(
//             strokeWidth: 5,
//             value: (300 - seconds).toDouble() / 300,
//             backgroundColor: widgetGrey,
//             color: pointColor,
//           ),
//         ),
//         SizedBox(
//           width: 49,
//           height: 49,
//           child: Center(
//             child: Text('${min} : ${sec >= 10 ? sec : '0${sec}'}',
//                 style: textStyle.copyWith(fontSize: 12)),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class SummaryField extends StatelessWidget {
//   final TextEditingController controller;
//   final FocusNode focusNode;
//   const SummaryField(
//       {Key? key, required this.controller, required this.focusNode})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
//       color: Colors.white, // 배경색은 이미지에 맞게 조정
//       child: Row(
//         children: [
//           Expanded(
//             child: TextFormField(
//               focusNode: focusNode,
//               controller: controller,
//               style: TextStyle(color: Colors.white), // 텍스트 색상
//               decoration: InputDecoration(
//                 hintText: '글을 가볍게 요약해주세요.',
//                 hintStyle: TextStyle(color: Colors.grey), // 힌트 텍스트 색상
//                 border: InputBorder.none, // 테두리 제거
//               ),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               // 전송 버튼 동작
//             },
//             style: TextButton.styleFrom(
//               backgroundColor: Colors.pink, // 버튼 배경색
//             ),
//             child: Text(
//               '완료',
//               style: TextStyle(color: Colors.white), // 버튼 텍스트 색상
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
