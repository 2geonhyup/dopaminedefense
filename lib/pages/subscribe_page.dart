import 'package:dopamine_defense_1/models/custom_error.dart';
import 'package:dopamine_defense_1/pages/loading_page.dart';
import 'package:dopamine_defense_1/providers/profile/profile_provider.dart';
import 'package:dopamine_defense_1/utils/error_dialog.dart';
import 'package:dopamine_defense_1/widgets/navigate_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../constants.dart';

class SubscribePage extends StatefulWidget {
  const SubscribePage({Key? key}) : super(key: key);

  @override
  State<SubscribePage> createState() => _SubscribePageState();
}

enum SubscribeStatus { loading, loaded, complete, error, progress }

class _SubscribePageState extends State<SubscribePage> {
  SubscribeStatus subscribeStatus = SubscribeStatus.loading;
  Offerings? offerings;
  Future<void> performMagic() async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    //이미 구독한 상태 -> 홈화면으로 가야 함
    if (customerInfo.entitlements.all[entitlementID] != null &&
        customerInfo.entitlements.all[entitlementID]?.isActive == true) {
      // appData.currentData = WeatherData.generateData();
      subscribeStatus = SubscribeStatus.complete;
    } else {
      try {
        offerings = await Purchases.getOfferings();
      } on PlatformException catch (e) {
        subscribeStatus = SubscribeStatus.error;

        errorDialog(context, CustomError(message: e.toString()));
      }

      if (offerings == null || offerings?.current == null) {
        // offerings are empty, show a message to your user

        subscribeStatus = SubscribeStatus.error;

        errorDialog(
            context, CustomError(message: "구독 목록을 불러올 수 없습니다. 앱을 다시 실행해주세요."));
      } else {
        subscribeStatus = SubscribeStatus.loaded;

        print(offerings!.current!);
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    performMagic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SubscribeView(
            subscribeStatus: subscribeStatus, offerings: offerings));
  }
}

class SubscribeView extends StatefulWidget {
  SubscribeStatus subscribeStatus;
  final Offerings? offerings;

  SubscribeView(
      {Key? key, required this.subscribeStatus, required this.offerings})
      : super(key: key);

  @override
  State<SubscribeView> createState() => _SubscribeViewState();
}

class _SubscribeViewState extends State<SubscribeView> {
  int selectedBox = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.subscribeStatus == SubscribeStatus.loading)
      return Center(child: CircularProgressIndicator());
    if (widget.subscribeStatus == SubscribeStatus.progress)
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "구독 정보 준비중...",
              style: informationStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Center(child: CircularProgressIndicator()),
        ],
      );
    else if (widget.subscribeStatus == SubscribeStatus.error)
      return Center(
        child: Text(
          "앱을 다시 실행해주세요.",
          style: informationStyle,
        ),
      );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "매일 새로운 지문",
          style: subTitleStyle.copyWith(color: pointColor),
          textAlign: TextAlign.center,
        ),
        Text("AI채점과 피드백까지", style: subTitleStyle),
        SizedBox(
          height: 70,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedBox = 0;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                width: 300,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                        color: selectedBox == 0 ? pointColor : fontGrey,
                        width: 2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "1개월",
                      style: informationStyle.copyWith(
                          fontWeight: FontWeight.w700,
                          color: selectedBox == 0 ? pointColor : fontGrey),
                    ),
                    Text(
                      "월 ₩3,000",
                      style: informationStyle.copyWith(
                          fontWeight: FontWeight.w700,
                          color: selectedBox == 0 ? pointColor : fontGrey),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedBox = 1;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                width: 300,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                        color: selectedBox == 1 ? pointColor : fontGrey,
                        width: 2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "3개월",
                      style: informationStyle.copyWith(
                          fontWeight: FontWeight.w700,
                          color: selectedBox == 1 ? pointColor : fontGrey),
                    ),
                    Text(
                      "월 ₩2,000",
                      style: informationStyle.copyWith(
                          fontWeight: FontWeight.w700,
                          color: selectedBox == 1 ? pointColor : fontGrey),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 70,
            ),
            Center(
              child: NavigateButton(
                  onPressed: () async {
                    if (widget.subscribeStatus == SubscribeStatus.progress)
                      return;
                    setState(() {
                      widget.subscribeStatus = SubscribeStatus.progress;
                    });
                    var myProductList =
                        widget.offerings!.current!.availablePackages;
                    print(myProductList);
                    try {
                      CustomerInfo customerInfo =
                          await Purchases.purchasePackage(
                              myProductList[selectedBox]);
                      EntitlementInfo? entitlement =
                          customerInfo.entitlements.all[entitlementID];
                      print(entitlement);

                      if (entitlement != null && entitlement.isActive) {
                        print("subscribe");
                        context.read<ProfileProvider>().setSubscribe();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoadingPage()));
                      }
                      setState(() {
                        widget.subscribeStatus = SubscribeStatus.complete;
                      });
                    } catch (e) {
                      final error = e as PlatformException;
                      print(error.code);
                      if (int.parse(error.code) != 1) {
                        errorDialog(
                            context,
                            CustomError(
                                code: '구독 실패', message: error.message ?? ''));
                      }
                      setState(() {
                        widget.subscribeStatus = SubscribeStatus.loaded;
                      });
                    }
                  },
                  width: 345,
                  text: "3일간 무료체험 시작하기",
                  foregroundColor: Colors.white,
                  backgroundColor: pointColor),
            )
          ],
        )
      ],
    );
  }
}
