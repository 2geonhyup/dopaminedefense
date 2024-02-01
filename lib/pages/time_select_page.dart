import 'package:dopamine_defense_1/constants.dart';
import 'package:dopamine_defense_1/models/user.dart';
import 'package:dopamine_defense_1/pages/home_page.dart';
import 'package:dopamine_defense_1/pages/subscribe_page.dart';
import 'package:dopamine_defense_1/pages/time_picker.dart';
import 'package:dopamine_defense_1/providers/profile/profile_provider.dart';
import 'package:dopamine_defense_1/providers/profile/profile_state.dart';
import 'package:dopamine_defense_1/repositories/profile_repository.dart';
import 'package:dopamine_defense_1/widgets/navigate_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:provider/provider.dart';
import '../widgets/back_icon.dart';
import 'loading_page.dart';

class TimeSelectPage extends StatefulWidget {
  const TimeSelectPage({Key? key}) : super(key: key);
  static const String routeName = "time_select_page";

  @override
  State<TimeSelectPage> createState() => _TimeSelectPageState();
}

class _TimeSelectPageState extends State<TimeSelectPage> {
  DateTime _dateTime = DateTime.parse('2023-01-31 07:00');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 60,
                ),
                BackIcon(),
                SizedBox(
                  height: 32,
                ),
                Row(
                  children: [
                    Image.asset(
                      "assets/images/time-select-title.png",
                      width: 225,
                      height: 68,
                    ),
                  ],
                ),
                SizedBox(
                  height: 13,
                ),
                Row(
                  children: [
                    Text(
                      '원하시는 시간에 글을 보내드릴게요',
                      style: regularGrey16,
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    width: double.maxFinite,
                    child: TimePickerWidget(
                      onChange: (dateTime) {
                        _dateTime = dateTime;
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 34.0),
              child: NavigateButton(
                onPressed: () async {
                  String hour = _dateTime.hour.toString().padLeft(2, '0');
                  String min = _dateTime.minute.toString().padLeft(2, '0');
                  await context
                      .read<ProfileProvider>()
                      .setTime(push: '$hour:$min');
                  Navigator.pushNamed(context, HomePage.routeName);
                },
                width: 342,
                text: "완료",
                backgroundColor: orangePoint,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TimePickerWidget extends StatelessWidget {
  final Function(DateTime) onChange;
  TimePickerWidget({Key? key, required this.onChange}) : super(key: key);
  String INIT_DATETIME = '2024-01-31 07:00';
  String DATE_FORMAT = 'HH시:mm분';

  @override
  Widget build(BuildContext context) {
    return DateTimePickerWidget(
      initDateTime: DateTime.parse(INIT_DATETIME),
      dateFormat: DATE_FORMAT,
      minuteDivider: 15,
      pickerTheme: DateTimePickerTheme(
        itemTextStyle: semiBoldBlack24,
        itemHeight: 60,
        pickerHeight: MediaQuery.of(context).size.height,
        showTitle: false,
      ),
      onChange: (dateTime, selectedIndex) {
        onChange(dateTime);
      },
    );
  }
}
