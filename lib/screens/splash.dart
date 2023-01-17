import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noteapp/animations/entrance_fader.dart';
import 'package:noteapp/app_navigations/custom_navigate.dart';
import 'package:noteapp/configs/app.dart';
import 'package:noteapp/configs/configs.dart';
import 'package:noteapp/cubits/local_database_cubit/cubit.dart';
import 'package:noteapp/providers/app_provider.dart';
import 'package:noteapp/translations/locale_keys.g.dart';
import 'package:noteapp/utils/app_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _next() {
    if (FirebaseAuth.instance.currentUser != null) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
        CustomNavigate.navigateReplacement(context, 'home');
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
        CustomNavigate.navigateReplacement(context, 'phoneAuthPage');
      });
    }
  }

  void initTheme() {
    final appProvider = AppProvider.state(context);
    appProvider.init();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _next();
      initTheme();
      final localDatabaseCubit = LocalDatabaseCubit.cubit(context);
      localDatabaseCubit.initDatabase();
    });
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EntranceFader(
              offset: const Offset(0, -20),
              duration: const Duration(seconds: 1),
              child: SvgPicture.asset(
                StaticAssets.icon,
                height: AppDimensions.normalize(40),
              ),
            ),
            Space.y!,
            EntranceFader(
              offset: const Offset(0, 20),
              duration: const Duration(seconds: 1),
              child: Text(
                LocaleKeys.noteApp.tr(),
                style: AppText.h1b!.copyWith(
                  fontSize: AppDimensions.normalize(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
