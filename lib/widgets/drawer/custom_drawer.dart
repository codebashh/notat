import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:noteapp/configs/app_theme.dart';
import 'package:noteapp/configs/app_typography.dart';
import 'package:noteapp/configs/space.dart';
import 'package:noteapp/cubits/phone_auth/cubit.dart';
import 'package:noteapp/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';
import 'package:noteapp/configs/app.dart';
import 'package:noteapp/providers/app_provider.dart';
import 'package:noteapp/app_navigations/custom_navigate.dart';

part 'widgets/_social_button.dart';

enum Language {
  en,
  ar,
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final appProvider = Provider.of<AppProvider>(context);

    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.835,
      height: size.height,
      child: Material(
        color: appProvider.isDark ? Colors.grey[900] : Colors.white,
        child: Padding(
          padding: Space.all(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Space.top!,
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: ' ${LocaleKeys.note.tr()}',
                              style: AppText.h2b!.copyWith(
                                color: AppTheme.c!.text,
                              ),
                            ),
                            TextSpan(
                              text: ' ${LocaleKeys.app.tr()}',
                              style: AppText.h2!.copyWith(
                                color: AppTheme.c!.text,
                              ),
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      Platform.isIOS
                          ? Transform.scale(
                              scale: 0.9,
                              child: CupertinoSwitch(
                                value: appProvider.isDark,
                                activeColor: AppTheme.c!.primary,
                                onChanged: (value) {
                                  appProvider.setTheme(
                                    value ? ThemeMode.dark : ThemeMode.light,
                                  );
                                },
                              ),
                            )
                          : Switch(
                              value: appProvider.isDark,
                              activeColor: AppTheme.c!.primary,
                              onChanged: (value) {
                                appProvider.setTheme(
                                  value ? ThemeMode.dark : ThemeMode.light,
                                );
                              },
                            ),
                      if (Platform.isIOS) Space.x!,
                    ],
                  ),
                  Space.y!,
                  Divider(
                    color: Colors.grey.withAlpha(50),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(
                      Icons.person_outline,
                    ),
                    title: Text(
                      LocaleKeys.profile.tr(),
                      style: AppText.b1,
                    ),
                    subtitle: Text(
                      LocaleKeys.profileSlogan.tr(),
                      style: AppText.l1,
                    ),
                  ),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      leading: const Icon(
                        Icons.person_outline,
                      ),
                      title: Text(
                        LocaleKeys.linkAccount.tr(),
                        style: AppText.b1,
                      ),
                      subtitle: Text(
                        LocaleKeys.linkAccountSub.tr(),
                        style: AppText.l1,
                      ),
                      childrenPadding: Space.all(),
                      children: [
                        _SocialButton(
                          icon: FontAwesomeIcons.google,
                          label: LocaleKeys.connectGoogle.tr(),
                          color: const Color(0xffD11F1F),
                          onPressed: () {},
                        ),
                        Space.yf(0.3),
                        _SocialButton(
                          icon: FontAwesomeIcons.facebook,
                          label: LocaleKeys.connectFacebook.tr(),
                          color: const Color(0xff4267B2),
                          onPressed: () {},
                        ),
                        Space.yf(0.3),
                        _SocialButton(
                          icon: FontAwesomeIcons.phone,
                          label: phoneConnected(),
                          color: phoneConnectColor(),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      leading: const Icon(
                        Icons.language,
                      ),
                      title: Text(
                        LocaleKeys.language.tr(),
                        style: AppText.b1,
                      ),
                      subtitle: Text(
                        LocaleKeys.languageSub.tr(),
                        style: AppText.l1,
                      ),
                      childrenPadding: Space.all(),
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: const Locale('en', 'US'),
                              groupValue: appProvider.currentLocale,
                              onChanged: (Locale? value) {
                                appProvider.langauge = value!;
                                context.setLocale(value);
                              },
                            ),
                            Text(LocaleKeys.english.tr())
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: const Locale('ar', 'SA'),
                              groupValue: appProvider.currentLocale,
                              onChanged: (Locale? value) {
                                appProvider.langauge = value!;
                                context.setLocale(value);
                              },
                            ),
                            Text(LocaleKeys.arabic.tr())
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _SocialButton(
                        icon: Icons.logout,
                        label: "Logout",
                        color: AppTheme.c!.primary!,
                        onPressed: () {
                          BlocProvider.of<PhoneAuthCubit>(context).signOut();
                          Navigator.pop(context);
                          CustomNavigate.navigateReplacement(
                              context, 'phoneAuthPage');
                          Fluttertoast.showToast(msg: "Logged Out");
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  phoneConnected() {
    String connect = "";
    FirebaseAuth.instance.currentUser != null
        ? connect = "Connected with Phone"
        : connect = "Connect with Phone";
    return connect;
  }

  Color phoneConnectColor() {
    Color color = const Color.fromARGB(255, 132, 130, 130);
    phoneConnected() == "Connected with Phone"
        ? color = const Color.fromARGB(255, 132, 130, 130)
        : const Color.fromARGB(255, 255, 136, 146);
    return color;
  }
}
