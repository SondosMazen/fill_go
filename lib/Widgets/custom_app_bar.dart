import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fill_go/Helpers/assets_color.dart';
import 'package:fill_go/Helpers/assets_helper.dart';
import 'package:fill_go/Utils/utils.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback onPressed;
  final String title;
  final Color color;
  final List<Widget>? actions;
  final double? titleSize;

  const CustomAppBar(
      {super.key,
      required this.onPressed,
      required this.title,
      this.actions,
      this.titleSize =20,
      this.color = Colors.white})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: widget.actions,
      leading: IconButton(
        onPressed: () {
          widget.onPressed();
        },
        icon: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 20,
            )),
      ),
      centerTitle: true,
      title: Text(
        widget.title,
        textAlign: TextAlign.center,
        style:  TextStyle(
            color: AssetsColors.color_text_black_392C23,
            fontSize: widget.titleSize,
            fontFamily: AssetsHelper.FONT_Avenir,
            fontWeight: FontWeight.w500),
      ),
      iconTheme: const IconThemeData(
        color: AssetsColors.color_text_black_392C23,
      ),
      backgroundColor: widget.color,
      flexibleSpace: null,
      elevation: 0,
    );
  }
}

class CustomXAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback onPressed;
  final String title;

  const CustomXAppBar({
    super.key,
    required this.onPressed,
    required this.title,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomXAppBarState createState() => _CustomXAppBarState();
}

class _CustomXAppBarState extends State<CustomXAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const SizedBox(),
      actions: [
        IconButton(
          onPressed: () {
            widget.onPressed();
          },
          icon: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: AssetsColors.color_gray_F7F7F8,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 23,
                color: AssetsColors.color_text_black_392C23,
              )),
        ),
      ],
      centerTitle: true,
      title: Text(
        widget.title,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: AssetsColors.color_text_black_392C23,
            fontSize: 18,
            fontFamily: AssetsHelper.FONT_Avenir,
            fontWeight: FontWeight.w700),
      ),
      iconTheme: const IconThemeData(
        color: AssetsColors.color_text_black_392C23,
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}

class CustomAppBar2 extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar2({
    this.title,
    super.key,
    this.actions,
  });
  final String? title;
  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: const Color(0xffEFEFF5),
          height: 1.0,
        ),
      ),
      //iconTheme: IconThemeData(color: mainTextColor),
      title: Text(title!, style: AppTextStyles.getHeavyTextStyle(fontSize: 18)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      leading: Builder(
        builder: (BuildContext context) {
          return InkWell(
            child: SvgPicture.asset(AssetsHelper.ic_menu,
                color: AssetsColors.color_text_black_392C23,
                fit: BoxFit.scaleDown),
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55.0);
}

class CustomBadge extends StatelessWidget {
  final double top;
  final double right;
  final Widget child; // our badge widget will wrap this child widget
  final String value; // what displays inside the badge
  final Color color; // the  background color of the badge - default is red

  const CustomBadge(
      {super.key,
      required this.child,
      required this.value,
      this.color = Colors.red,
      required this.top,
      required this.right});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: right,
          top: top,
          child: Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color,
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        )
      ],
    );
  }
}
