// Horizontal Spacing , media query , dividers

import 'package:doctors_appointment_application/utils/components/kdrt_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UIHelpers {
  static Widget horizontalSpaceTiny = const SizedBox(width: 5.0);
  static Widget horizontalSpaceSmall = const SizedBox(width: 10.0);
  static Widget horizontalSpaceRegular = const SizedBox(width: 15.0);
  static Widget horizontalSpaceSmallRegular = const SizedBox(width: 20.0);
  static Widget horizontalSpaceMedium = const SizedBox(width: 30.0);
  static Widget horizontalSpaceLarge = const SizedBox(width: 35.0);
  static Widget horizontalSpaceLargePlus = const SizedBox(height: 40.0);
  static Widget horizontalSpaceExtraLarge = const SizedBox(height: 45.0);

  static Widget verticalSpaceTiny = const SizedBox(height: 5.0);
  static Widget verticalSpaceSmall = const SizedBox(height: 10.0);
  static Widget verticalSpaceRegular = const SizedBox(height: 15.0);
  static Widget verticalSpaceSmallRegular = const SizedBox(height: 20.0);
  static Widget verticalSpaceMedium = const SizedBox(height: 30.0);
  static Widget verticalSpaceLarge = const SizedBox(height: 35.0);
  static Widget verticalSpaceLargePlus = const SizedBox(height: 40.0);
  static Widget verticalSpaceExtraLarge = const SizedBox(height: 45.0);
  static Widget verticalSpaceHuge = const SizedBox(height: 300.0);

  static hideKeyBoard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  // Screen Size helpers

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double screenHeightPercentage(BuildContext context,
          {double percentage = 1}) =>
      screenHeight(context) * percentage;

  static double screenWidthPercentage(BuildContext context,
          {double percentage = 1}) =>
      screenWidth(context) * percentage;

  static Widget spacedDivider({required double spaceHeight}) {
    return Column(
      children: <Widget>[
        verticalSpaceTiny,
        Divider(height: spaceHeight, color: KDRTColors.grey),
        verticalSpaceTiny,
      ],
    );
  }

  static Widget listDivider = const Divider(
    color: KDRTColors.grey,
    thickness: 1,
  );

  static Widget listDividerBlue = const Divider(
    color: KDRTColors.blue,
    thickness: 1,
  );

  static Widget listDividerWhite = const Divider(
    color: KDRTColors.white,
    thickness: 1,
  );

  static Widget listDividerWhite2 = const Divider(
    color: KDRTColors.white,
    thickness: 2,
  );

  static Widget listDividerBlack = const Divider(
    color: KDRTColors.black,
    thickness: 1,
  );

  static Widget listDividerBlack2 = const Divider(
    color: KDRTColors.black,
    thickness: 2,
  );
}
