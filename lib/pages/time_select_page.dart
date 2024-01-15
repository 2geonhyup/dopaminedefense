import 'package:dopamine_defense_1/constants.dart';
import 'package:dopamine_defense_1/models/user.dart';
import 'package:dopamine_defense_1/pages/subscribe_page.dart';
import 'package:dopamine_defense_1/providers/profile/profile_state.dart';
import 'package:dopamine_defense_1/repositories/profile_repository.dart';
import 'package:dopamine_defense_1/widgets/navigate_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';
import 'loading_page.dart';

class TimeSelectPage extends StatefulWidget {
  const TimeSelectPage({Key? key}) : super(key: key);

  @override
  State<TimeSelectPage> createState() => _TimeSelectPageState();
}

class _TimeSelectPageState extends State<TimeSelectPage> {
  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final UserModel user = context.watch<ProfileState>().user;
    String hour = _dateTime.hour.toString().padLeft(2, '0');
    String min = _dateTime.minute.toString().padLeft(2, '0');
    print(min);
    print(hour);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "글을 읽기에\n언제가 가장 좋은가요?",
            textAlign: TextAlign.center,
            style: subTitleStyle,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "선택한 시간에 글을 보내드릴께요.",
            style: textStyle,
          ),
          SizedBox(
            height: 50,
          ),
          hourMinute(),
          SizedBox(
            height: 50,
          ),
          NavigateButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      title: Text(
                        '시간 설정',
                      ),
                      content: Text(
                        '${_dateTime.hour}시 ${_dateTime.minute}분에 매일 글을 보내드릴께요!\n(해당 시간은 수정할 수 없습니다)',
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('확인'),
                          onPressed: () async {
                            //최종제출
                            context.read<ProfileRepository>().setTime(
                                user: context.read<ProfileState>().user,
                                time: '${hour}:${min}');

                            Navigator.of(context).pop(); // 다이얼로그 닫기

                            if (user.entitlementIsActive) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => LoadingPage()),
                              );
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => SubscribePage()),
                              );
                            }
                          },
                        ),
                        TextButton(
                          child: Text('취소'),
                          onPressed: () {
                            Navigator.of(context).pop(); // 다이얼로그 닫기
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              width: 300,
              text: "무료체험 시작하기",
              foregroundColor: Colors.white,
              backgroundColor: black1)
        ],
      ),
    );
  }

  Widget hourMinute() {
    return new TimePickerSpinner(
      spacing: 30,
      minutesInterval: 10,
      itemHeight: 80,
      isForce2Digits: true,
      normalTextStyle: subTitleStyle.copyWith(color: fontGrey),
      highlightedTextStyle: subTitleStyle,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }
}
