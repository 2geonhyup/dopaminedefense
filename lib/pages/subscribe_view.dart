import 'package:flutter/material.dart';

import '../constants.dart';

class ThreeMonthCard extends StatelessWidget {
  final bool selected;
  const ThreeMonthCard({Key? key, required this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              height: 104,
              decoration: BoxDecoration(
                color: selected ? orangePoint : greyE,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '3개월',
                    style: mediumBlack20.copyWith(
                        color: selected ? Colors.white : black1),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 17,
                      ),
                      PriceWidget(
                          priceString: '6,000',
                          fontSize: 20,
                          color: selected ? Colors.white : black1),
                      PriceWidget(
                          priceString: '2,000/월',
                          fontSize: 12,
                          color: selected ? Colors.white : orangePoint)
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              TagCard(title: "인기", color: orangePoint),
              SizedBox(
                width: 6,
              ),
              TagCard(title: "2달 결제시, 1달 무료!", color: greenPoint)
            ],
          ),
        ],
      ),
    );
  }
}

class OneMonthCard extends StatelessWidget {
  final bool selected;
  const OneMonthCard({Key? key, required this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      height: 104,
      decoration: BoxDecoration(
        color: selected ? orangePoint : greyE,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '1개월',
            style:
                mediumBlack20.copyWith(color: selected ? Colors.white : black1),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PriceWidget(
                  priceString: '3,000/월',
                  fontSize: 20,
                  color: selected ? Colors.white : black1),
            ],
          ),
        ],
      ),
    );
  }
}

class TagCard extends StatelessWidget {
  final String title;
  final Color color;

  const TagCard({
    Key? key,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 22,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: color),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$title',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PriceWidget extends StatelessWidget {
  final String priceString;
  final double fontSize;
  final Color color;
  const PriceWidget({
    required this.priceString,
    required this.fontSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '₩',
                style: TextStyle(
                  color: color,
                  fontSize: fontSize,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 1.42,
                  letterSpacing: -0.17,
                ),
              ),
              TextSpan(
                text: priceString,
                style: TextStyle(
                  color: color,
                  fontSize: fontSize,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  height: 1.42,
                  letterSpacing: -0.17,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
