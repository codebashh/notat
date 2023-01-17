import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/screens/home/home.dart';
import 'package:noteapp/widgets/drawer/custom_drawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:noteapp/configs/app_dimensions.dart';
import 'package:noteapp/providers/app_provider.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  void askRequiredPermissions() async {
    await [
      Permission.storage,
      Permission.microphone,
      Permission.camera,
    ].request();
  }

  @override
  void initState() {
    super.initState();

    askRequiredPermissions();

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
  }

  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

  late bool _canBeDragged;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = animationController.isDismissed;
    bool isDragCloseFromRight = animationController.isCompleted;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragEnd(DragEndDetails details) {
    double kMinFlingVelocity = 365.0;

    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    bool isArabic =
        EasyLocalization.of(context)!.currentLocale == const Locale('ar', 'SA');

    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: (details) {
        if (_canBeDragged) {
          double delta = isArabic
              ? details.primaryDelta! / -AppDimensions.normalize(140)
              : details.primaryDelta! / AppDimensions.normalize(140);
          animationController.value += delta;
        }
      },
      onHorizontalDragEnd: _onDragEnd,
      behavior: HitTestBehavior.translucent,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          return Material(
            color: appProvider.isDark ? Colors.grey[850] : Colors.white70,
            child: Stack(
              children: <Widget>[
                Transform.translate(
                  offset: Offset(
                      isArabic
                          ? MediaQuery.of(context).size.width *
                              0.8325 *
                              (1 - animationController.value)
                          : MediaQuery.of(context).size.width *
                              0.8325 *
                              (animationController.value - 1),
                      0),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(isArabic
                          ? math.pi / 2 * (animationController.value - 1)
                          : math.pi / 2 * (1 - animationController.value)),
                    alignment:
                        isArabic ? Alignment.centerLeft : Alignment.centerRight,
                    child: const CustomDrawer(),
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                      isArabic
                          ? -MediaQuery.of(context).size.width *
                              0.8325 *
                              animationController.value
                          : MediaQuery.of(context).size.width *
                              0.8325 *
                              animationController.value,
                      0),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(isArabic
                          ? math.pi / 2 * animationController.value
                          : -math.pi / 2 * animationController.value),
                    alignment:
                        isArabic ? Alignment.centerRight : Alignment.centerLeft,
                    child: const HomeScreen(),
                  ),
                ),
                Positioned(
                  top: 8.0 + MediaQuery.of(context).padding.top,
                  left: isArabic
                      ? MediaQuery.of(context).size.width * 0.85 +
                          -animationController.value *
                              MediaQuery.of(context).size.width *
                              0.83
                      : MediaQuery.of(context).size.width * 0.01 +
                          animationController.value *
                              MediaQuery.of(context).size.width *
                              0.83,
                  child: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: toggle,
                    color: appProvider.isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
