import 'package:dopamine_defense_1/pages/time_select_page.dart';
import 'package:dopamine_defense_1/widgets/navigate_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/profile/profile_state.dart';
import '../repositories/profile_repository.dart';

class PushTimeDialog extends StatelessWidget {
  const PushTimeDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          type: MaterialType.transparency, //전체 페이지를 차지하지 않기 위함
          child: Container(
            width: 342,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "알림 설정",
                      style: mediumGrey7_16.copyWith(letterSpacing: -0.17),
                    ),
                    //끄기 아이콘
                    GestureDetector(
                      onTap: () {
                        // 껐을 때, 시간 오전 8시로 설정
                        context.read<ProfileRepository>().setPushTime(
                            user: context.read<ProfileState>().user,
                            push: '08:00');
                        Navigator.pop(context);
                      },
                      child: const Center(
                        child: Icon(
                          Icons.close,
                          size: 24,
                          color: grey3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/push-time-dialog-title.png",
                      width: 230,
                      height: 68,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 54,
                ),
                Container(
                  height: 54,
                  width: double.maxFinite,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: orangePoint),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        'assets/images/info-icon.png',
                        width: 32,
                        height: 32,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: '시간을 선택하지 않으시면,\n매일 ',
                                style: regularGrey14),
                            TextSpan(
                                text: '오전 8시',
                                style: regularGrey14.copyWith(
                                    fontWeight: FontWeight.w600)),
                            TextSpan(
                                text: '에 글을 보내드립니다.', style: regularGrey14),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                NavigateButton(
                    width: double.maxFinite,
                    height: 50,
                    onPressed: () {
                      //알림 설정 화면으로 전환
                      Navigator.pushNamed(context, TimeSelectPage.routeName);
                    },
                    text: "알림 설정하러 기기"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
