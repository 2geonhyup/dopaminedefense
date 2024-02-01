import 'package:flutter/material.dart';

const Color orangePoint = Color(0xffF15736);
const Color black1 = Color(0xff111115);
const Color grey3 = Color(0xff333438);
const Color grey7 = Color(0xff707178);
const Color greyF = Color(0xffFAFBFC);
const Color greyA = Color(0xffAAAAB2);
const Color greyC = Color(0xffCDCED3);
const Color greyE = Color(0xffEBEBEF);
const Color greenPoint = Color(0xff60B7B7);
const Color purplePoint = Color(0xff9062DB);
TextStyle titleStyle = TextStyle(
    fontSize: 50,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w900,
    color: black1);

TextStyle subTitleStyle = TextStyle(
    fontSize: 30,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w800,
    color: black1);

TextStyle informationStyle = TextStyle(
    fontSize: 25,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w500,
    color: grey7);

TextStyle buttonTextStyle = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    fontFamily: 'Pretendard');

TextStyle textStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    color: grey7,
    fontFamily: 'Pretendard');

TextStyle mediumBlack20 = TextStyle(
  color: black1,
  fontSize: 20,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w500,
  letterSpacing: -0.17,
);

TextStyle semiBoldBlack20 = TextStyle(
  color: black1,
  fontSize: 20,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w600,
  letterSpacing: -0.17,
);

TextStyle regularOrange12 = TextStyle(
  color: orangePoint,
  fontSize: 12,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w400,
  letterSpacing: -0.17,
);

TextStyle regularGrey16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: grey7,
    fontFamily: 'Pretendard',
    letterSpacing: -0.17,
    height: 1.42);

TextStyle regularGrey14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: grey7,
    height: 1.42,
    letterSpacing: -0.17,
    fontFamily: 'Pretendard');

TextStyle regularWhite14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    fontFamily: 'Pretendard');

TextStyle regularOrange14 = TextStyle(
    height: 1.42,
    letterSpacing: 0.1,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: orangePoint,
    fontFamily: 'Pretendard');

TextStyle mediumGreen14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: greenPoint,
    fontFamily: 'Pretendard');

TextStyle regularBlack16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: black1,
    fontFamily: 'Pretendard');

TextStyle semiBoldWhite20 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: 'Pretendard');

TextStyle semiBoldBlack24 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: black1,
    fontFamily: 'Pretendard');

TextStyle semiBoldOrange24 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: orangePoint,
    fontFamily: 'Pretendard');

TextStyle semiBoldWhite22 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: 'Pretendard');

TextStyle semiBoldWhite24 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: 'Pretendard');

TextStyle semiBold14 = TextStyle(
  fontSize: 14,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w600,
  letterSpacing: 0,
);

TextStyle mediumWhite12 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    fontFamily: 'Pretendard');

TextStyle mediumWhite14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    fontFamily: 'Pretendard');

TextStyle mediumWhite16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    fontFamily: 'Pretendard');

TextStyle mediumLightGreyC16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: greyC,
    fontFamily: 'Pretendard',
    height: 1.58,
    letterSpacing: 0.1);

TextStyle mediumGreyE16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: greyC,
    fontFamily: 'Pretendard',
    height: 1.58,
    letterSpacing: 0.1);

TextStyle mediumGrey3_16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: grey3,
    fontFamily: 'Pretendard',
    height: 1.58,
    letterSpacing: 0.1);

TextStyle mediumGreyA_16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: greyA,
    fontFamily: 'Pretendard',
    height: 1.42,
    letterSpacing: 0.1);

TextStyle mediumGrey7_14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: grey7,
    fontFamily: 'Pretendard',
    letterSpacing: 0);

TextStyle mediumGrey7_16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.42,
    color: grey7,
    fontFamily: 'Pretendard',
    letterSpacing: 0.1);

TextStyle mediumGrey32 = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.w500,
  color: greyA,
  fontFamily: 'Pretendard',
);

TextStyle numberStyle =
    TextStyle(fontFamily: 'Hakgyo', color: Colors.white, fontSize: 82);

TextStyle typoBoldStyle = TextStyle(
    fontFamily: 'SinDongYup',
    color: orangePoint,
    fontSize: 38.19,
    letterSpacing: -1.8,
    height: 1,
    fontWeight: FontWeight.w700);

Row defenseTypo = Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Text(
      "De",
      style: typoBoldStyle,
    ),
    SizedBox(
      width: 0.12,
    ),
    Text(
      "fense",
      style: TextStyle(
          fontFamily: 'Sulphur Point',
          fontSize: 28.64,
          letterSpacing: 1.4,
          height: 1,
          color: orangePoint),
    )
  ],
);

const entitlementID = 'premium';
