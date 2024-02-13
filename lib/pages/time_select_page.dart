import 'package:dopamine_defense_1/constants.dart';
import 'package:dopamine_defense_1/providers/profile/profile_provider.dart';
import 'package:dopamine_defense_1/widgets/navigate_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:provider/provider.dart';
import '../amplitude_config.dart';
import '../widgets/back_icon.dart';

class TimeSelectPage extends StatefulWidget {
  const TimeSelectPage({Key? key}) : super(key: key);
  static const String routeName = "time_select_page";

  @override
  State<TimeSelectPage> createState() => _TimeSelectPageState();
}

class _TimeSelectPageState extends State<TimeSelectPage> {
  DateTime _dateTime = DateTime.parse('2023-01-31 07:00');

  @override
  void initState() {
    //앰플리튜드 시간 설정 화면
    AmplitudeConfig.amplitude.logEvent("time-select-page");
    super.initState();
  }

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
                const SizedBox(
                  height: 60,
                ),
                const BackIcon(),
                const SizedBox(
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
                const SizedBox(
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
                  child: SizedBox(
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
                  context.mounted ? Navigator.pop(context) : null;
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
  const TimePickerWidget({Key? key, required this.onChange}) : super(key: key);
  final String initDatetime = '2024-01-31 07:00';
  final String dateFormat = 'HH시:mm분';

  @override
  Widget build(BuildContext context) {
    return DateTimePickerWidget(
      initDateTime: DateTime.parse(initDatetime),
      dateFormat: dateFormat,
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
