import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomImageSlider extends StatefulWidget {
  CustomImageSlider({
    super.key,
    required this.children,
    this.width = double.infinity,
    this.height = 200,
    this.initialPage = 0,
    this.indicatorColor,
    this.indicatorBackgroundColor = Colors.grey,
    this.onPageChanged,
    this.autoPlayInterval,
    this.isLoop = false,
    this.isTextFromOutside = false,
    this.isBottomCenterIndicator = false,
  });

  /// The widgets to display in the [CustomImageSlider].
  ///
  /// Mainly intended for image widget, but other widgets can also be used.
  final List<Widget> children;
  bool isTextFromOutside = false;

  /// Width of the [CustomImageSlider].
  final double width;

  /// Height of the [CustomImageSlider].
  final double height;

  /// The page to show when first creating the [CustomImageSlider].
  final int initialPage;

  /// The color to paint the indicator.
  final Color? indicatorColor;

  /// The color to paint behind th indicator.
  final Color? indicatorBackgroundColor;

  /// Called whenever the page in the center of the viewport changes.
  final ValueChanged<int>? onPageChanged;

  /// Auto scroll interval.
  ///
  /// Do not auto scroll when you enter null or 0.
  final int? autoPlayInterval;

  /// Loops back to first slide.
  final bool isLoop;

  /// Loops back to first slide.
  final bool isBottomCenterIndicator;

  @override
  _CustomImageSliderState createState() => _CustomImageSliderState();
}

class _CustomImageSliderState extends State<CustomImageSlider> {
  final _currentPageNotifier = ValueNotifier(0);
  late PageController _pageController;

  void _onPageChanged(int index) {
    _currentPageNotifier.value = index;
    if (widget.onPageChanged != null) {
      final correctIndex = index % widget.children.length;
      widget.onPageChanged!(correctIndex);
    }
  }

  void _autoPlayTimerStart() {
    Timer.periodic(
      Duration(milliseconds: widget.autoPlayInterval!),
      (timer) {
        int nextPage;
        if (widget.isLoop) {
          nextPage = _currentPageNotifier.value + 1;
        } else {
          if (_currentPageNotifier.value < widget.children.length - 1) {
            nextPage = _currentPageNotifier.value + 1;
          } else {
            return;
          }
        }

        if (_pageController.hasClients) {
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
        }
      },
    );
  }

  @override
  void initState() {
    _pageController = PageController(
      initialPage: widget.initialPage,
    );
    _currentPageNotifier.value = widget.initialPage;

    if (widget.autoPlayInterval != null && widget.autoPlayInterval != 0) {
      _autoPlayTimerStart();
    }
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          PageView.builder(
            scrollBehavior: const ScrollBehavior().copyWith(
              scrollbars: false,
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            onPageChanged: _onPageChanged,
            itemCount: widget.isLoop ? null : widget.children.length,
            controller: _pageController,
            itemBuilder: (context, index) {
              final correctIndex = index % widget.children.length;
              return widget.children[correctIndex];
            },
          ),
          widget.isTextFromOutside
              ? const SizedBox(
                  width: 0,
                  height: 0,
                )
              : Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black54,
                          Colors.black38,
                          Colors.black12
                        ]),
                  ),
                ),
          Container(
            padding: const EdgeInsetsDirectional.all(16),
            margin: widget.isBottomCenterIndicator
                ? const EdgeInsetsDirectional.only(bottom: 10)
                : EdgeInsetsDirectional.zero,
            alignment: widget.isBottomCenterIndicator
                ? AlignmentDirectional.bottomCenter
                : AlignmentDirectional.topStart,
            child: ValueListenableBuilder<int>(
              valueListenable: _currentPageNotifier,
              builder: (context, value, child) {
                return CustomIndicator(
                  count: widget.children.length,
                  currentIndex: value % widget.children.length,
                  activeColor: widget.indicatorColor,
                  backgroundColor: widget.indicatorBackgroundColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomIndicator extends StatelessWidget {
  const CustomIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.activeColor,
    this.backgroundColor,
  });

  final int count;
  final int currentIndex;
  final Color? activeColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      alignment: WrapAlignment.center,
      children: List.generate(
        count,
        (index) {
          return Container(
              alignment: AlignmentDirectional.center,
              margin: currentIndex != index
                  ? const EdgeInsetsDirectional.only(top: 2)
                  : EdgeInsetsDirectional.zero,
              width: currentIndex == index ? 14 : 10,
              height: currentIndex == index ? 14 : 10,
              decoration: BoxDecoration(
                color: currentIndex == index ? Colors.transparent : activeColor,
                border: currentIndex == index
                    ? Border.all(color: activeColor!)
                    : null,
                shape: BoxShape.circle,
              ));
        },
      ),
    );
  }
}
