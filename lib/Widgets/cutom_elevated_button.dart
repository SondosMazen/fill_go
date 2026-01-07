import 'package:flutter/material.dart';
import 'package:fill_go/Helpers/assets_color.dart';
import 'package:fill_go/Utils/utils.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.onNext,
    required this.text,
  });

  final VoidCallback? onNext;
  final String text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onNext,
      style: ElevatedButton.styleFrom(
        //minimumSize: const Size(300, 50),
        padding: const EdgeInsets.only(top: 12.0, bottom: 14.0),
        backgroundColor: AssetsColors.color_black_392C23,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      child: Text(
        text,
        style: AppTextStyles.getHeavyTextStyle(
            fontSize: 18.0, colorValue: Colors.white),
      ),
    );
  }
}
