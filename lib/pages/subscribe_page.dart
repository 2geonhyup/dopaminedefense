import 'package:dopamine_defense_1/models/custom_error.dart';
import 'package:dopamine_defense_1/pages/home_page.dart';
import 'package:dopamine_defense_1/pages/loading_page.dart';
import 'package:dopamine_defense_1/pages/subscribe_view.dart';
import 'package:dopamine_defense_1/providers/profile/profile_provider.dart';
import 'package:dopamine_defense_1/utils/error_dialog.dart';
import 'package:dopamine_defense_1/utils/navigate_dialog.dart';
import 'package:dopamine_defense_1/widgets/back_icon.dart';
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
  static const String routeName = "subscribe_page";

  @override
  State<SubscribePage> createState() => _SubscribePageState();
}

enum SubscribeStatus {
  loading, // 로딩중인 경우
  success, // 상품목록을 정상적으로 받아온 경우
  complete, // 화면 들어오기 전에 이미 구독한 경우
  failure, // 상품 목록을 받아올 때, 에러가 발생한 경우
}

class _SubscribePageState extends State<SubscribePage> {
  Offerings? offerings;
  late Future myFuture; // getofferings함수 initstate에서만 실행되게 함

  Future<SubscribeStatus> getOfferings() async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    // 이미 구독 완료 한 경우
    if (customerInfo.entitlements.all[entitlementID] != null &&
        customerInfo.entitlements.all[entitlementID]?.isActive == true) {
      // 홈으로 돌아가기
      return SubscribeStatus.complete;
    }
    // 아직 구독 안한 경우
    else {
      try {
        // 상품 목록 받아오기
        offerings = await Purchases.getOfferings();
      } on PlatformException catch (e) {
        print('상품 목록 로딩 실패${e.toString()}');
        // 상품 목록 로딩 실패 - 홈으로 돌아가기 화면
        return SubscribeStatus.failure;
      }
      // 상품 목록 로딩 실패 (빈 경우)
      if (offerings == null || offerings?.current == null) {
        // 상품 목록 로딩 실패 - 홈으로 돌아가기 화면
        return SubscribeStatus.failure;
      }
      // 상품 목록 로딩 성공
      else {
        // 세팅하기
        return SubscribeStatus.success;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFuture = getOfferings();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
        future: myFuture,
        builder: (context, snapshot) {
          Widget body;
          // 로딩 중
          if (!snapshot.hasData) {
            body = Center(child: CircularProgressIndicator());
          }
          // 에러 발생
          else if (snapshot.hasError ||
              snapshot.data == SubscribeStatus.failure) {
            body = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "상품 목록 로딩에 실패했습니다. \n아래 버튼을 누르고 다시 시도해주세요!",
                    style: regularGrey16,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoadingPage.routeName);
                      },
                      icon: Icon(
                        Icons.replay_circle_filled,
                        color: greyA,
                        size: 50,
                      ))
                ],
              ),
            );
          }
          // 이미 구독함
          else if (snapshot.data == SubscribeStatus.complete) {
            body = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "이미 상품 구독을 완료했습니다!\n아래 버튼을 통해 홈화면으로 돌아가주세요.",
                    style: regularGrey16,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoadingPage.routeName);
                      },
                      icon: Icon(
                        Icons.replay_circle_filled,
                        color: greyA,
                        size: 50,
                      ))
                ],
              ),
            );
          }
          // 정상적 로딩 완료
          else {
            body = OfferingView(
              offering: offerings!.current!,
            );
          }
          return Scaffold(
            backgroundColor: Colors.white,
            body: body,
          );
        });
  }
}

class OfferingView extends StatefulWidget {
  final Offering offering;

  OfferingView({Key? key, required this.offering}) : super(key: key);

  @override
  State<OfferingView> createState() => _OfferingViewState();
}

class _OfferingViewState extends State<OfferingView> {
  int selected = 1; // 처음엔 3개월

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
              ),
              BackIcon(),
              SizedBox(
                height: 32,
              ),
              Image.asset(
                "assets/images/subscribe-title.png",
                width: 225,
                height: 68,
              ),
              SizedBox(
                height: 13,
              ),
              Text(
                'AI채점과 피드백까지!',
                style: regularGrey16,
              ),
              SizedBox(
                height: 62,
              ),
              Text(
                '멤버십',
                style:
                    mediumGrey3_16.copyWith(height: 1.42, letterSpacing: -0.17),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "요금제를 선택한 후 3일간 무료체험 해보세요",
                style: regularGrey14.copyWith(color: greyA),
              ),
              SizedBox(
                height: 24,
              ),
              ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: widget.offering.availablePackages.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () async {
                        setState(() {
                          selected = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          child: index == 0
                              ? OneMonthCard(
                                  selected: selected == 0,
                                )
                              : ThreeMonthCard(
                                  selected: selected == index,
                                ),
                        ),
                      ));
                },
                shrinkWrap: true,
                reverse: true,
                physics: const ClampingScrollPhysics(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 34.0),
            child: NavigateButton(
              onPressed: () async {
                var myProductList = widget.offering.availablePackages;
                print(myProductList[selected].storeProduct.title);
                print(myProductList[selected].storeProduct.description);
                print(myProductList[selected].storeProduct.priceString);
                try {
                  // 구매하기
                  CustomerInfo customerInfo =
                      await Purchases.purchasePackage(myProductList[selected]);
                  // 구매 정보 가져오기
                  EntitlementInfo? entitlement =
                      customerInfo.entitlements.all[entitlementID];
                  // 구독 성공
                  if (entitlement != null && entitlement.isActive) {
                    context.read<ProfileProvider>().setSubscribe();
                    Navigator.pushNamed(context, HomePage.routeName);
                  }
                  //구독 실패
                  else {
                    errorDialog(
                        context,
                        CustomError(
                            code: "알림", message: "구독이 정상적으로 완료되지 않았습니다."));
                  }
                }
                //구독 실패
                catch (e) {
                  print("catch!!$e");
                  errorDialog(
                      context,
                      CustomError(
                          code: "알림", message: "구독이 정상적으로 완료되지 않았습니다."));
                }
              },
              width: 342,
              text: "3일간 무료체험 시작하기",
              foregroundColor: orangePoint,
              backgroundColor: black1,
              icon: Icon(
                Icons.arrow_forward,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
