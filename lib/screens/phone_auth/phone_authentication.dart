import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:noteapp/app_navigations/custom_navigate.dart';
import 'package:noteapp/configs/configs.dart';
import 'package:noteapp/cubits/phone_auth/cubit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../translations/locale_keys.g.dart';
import '../../utils/app_utils.dart';
import '../../widgets/loader/full_screen_loader.dart';

class PhoneAuthentication extends StatefulWidget {
  const PhoneAuthentication({Key? key}) : super(key: key);

  @override
  State<PhoneAuthentication> createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication> {
  bool showOtpContainer = false;
  final _formKey = GlobalKey<FormBuilderState>();
  String currentOTP = "";
  String countryCode = "";
  String phoneBody = "";
  String phone = "";

  @override
  void initState() {
    currentOTP = "";
    countryCode = "";
    phoneBody = "";
    phone = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
          builder: ((context, state) {
            if (state is PhoneAuthDefault) {
              return _form();
            } else if (state is PhoneAuthLoading) {
              return const FullScreenLoader(
                loading: true,
              );
            } else if (state is OTPAuthLoading) {
              return const FullScreenLoader(
                loading: true,
              );
            }
            return _form();
          }),
          listener: (context, state) {
            if (state is PhoneAuthLoading) {
            } else if (state is PhoneAuthSuccess) {
              showOtpContainer = true;
              Fluttertoast.showToast(msg: "Wait for verification");
            } else if (state is PhoneAuthFailed) {
              Fluttertoast.showToast(msg: "Invalid phone number!");
            } else if (state is OTPAuthSuccess) {
              Navigator.pop(context);
              Fluttertoast.showToast(msg: "Logged In");
              CustomNavigate.navigateReplacement(context, 'home');
            } else if (state is OTPAuthFailed) {
              Fluttertoast.showToast(msg: "Wrong OTP Verification Failed!");
            }
          },
        ),
      ),
    );
  }

  Widget _form() {
    return Scaffold(
      body: SafeArea(
        child: FormBuilder(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Space.yf(5),
                SvgPicture.asset(
                  StaticAssets.icon,
                  height: AppDimensions.normalize(40),
                ),
                Space.yf(2),
                Text(
                  LocaleKeys.noteApp.tr(),
                  style: AppText.h1b!.copyWith(
                    fontSize: AppDimensions.normalize(15),
                  ),
                ),
                Space.yf(2),
                Container(
                  alignment: Alignment.center,
                  margin: Space.all(5, 0),
                  child: Text(
                    "OTP Verification!",
                    style: AppText.h2,
                  ),
                ),
                Space.y1!,
                !showOtpContainer
                    ? Column(
                        children: [
                          Padding(
                            padding: Space.all(2, 0),
                            child: FormBuilderTextField(
                              name: 'name',
                              decoration: InputDecoration(
                                contentPadding: Space.all(3, 0),
                                hintText: 'First Name',
                                prefixIcon: const Icon(Icons.person),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    width: 1,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Color(0xFF63707B)),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              validator: FormBuilderValidators.compose([
                                (value) {
                                  if (value == null ||
                                      value.length < 3 ||
                                      !(RegExp(r'^[A-Za-z]+$'))
                                          .hasMatch(value)) {
                                    Fluttertoast.showToast(msg: "Invalid name");
                                  }
                                },
                                FormBuilderValidators.required(context),
                              ]),
                              keyboardType: TextInputType.name,
                            ),
                          ),
                          Space.y1!,
                          Padding(
                            padding: Space.all(2, 0),
                            child: IntlPhoneField(
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                              ),
                              onChanged: (phone) {
                                setState(() {
                                  phoneBody = phone.number.toString().trim();
                                  countryCode =
                                      phone.countryCode.toString().trim();
                                });
                              },
                              onCountryChanged: (country) {},
                              keyboardType: TextInputType.number,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                              ]),
                            ),
                          ),
                        ],
                      )
                    : Space.yf(0.3),
                !showOtpContainer
                    ? Padding(
                        padding: Space.all(3, 0),
                        child: ElevatedButton(
                          onPressed: () async {
                            phone = "$countryCode $phoneBody";
                            if (_formKey.currentState!.validate() &&
                                (RegExp(r'^[0-9]+$')).hasMatch(phoneBody)) {
                              final authCubit = BlocProvider.of<PhoneAuthCubit>(
                                context,
                              );
                              await authCubit.authenticatePhone(phone);
                            }
                          },
                          child: const Text(
                            'Get OTP',
                          ),
                        ),
                      )
                    : Space.yf(0.3),
                Space.y1!,
                showOtpContainer
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 5),
                        child: Column(
                          children: [
                            const Text("Enter the 6 digit code sent to you"),
                            Space.yf(0.6),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: PinCodeTextField(
                                appContext: context,
                                pastedTextStyle: TextStyle(
                                  color: AppTheme.c!.primary,
                                  backgroundColor: AppTheme.c!.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                length: 6,
                                pinTheme: PinTheme(
                                  activeFillColor: AppTheme.c!.primary,
                                  selectedColor: const Color(0xFFEFC745),
                                  inactiveColor: Colors.black26,
                                  inactiveFillColor: Colors.grey[200],
                                  selectedFillColor: const Color(0xFFEECE64),
                                ),
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                cursorColor: Colors.black,
                                animationDuration:
                                    const Duration(milliseconds: 300),
                                enableActiveFill: true,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    currentOTP = value;
                                  });
                                },
                              ),
                            ),
                            Space.yf(1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Did not receive a code ? | "),
                                TextButton(
                                    onPressed: () async {
                                      final authCubit =
                                          BlocProvider.of<PhoneAuthCubit>(
                                              context);
                                      await authCubit.authenticatePhone(phone);
                                    },
                                    child: const Text("Resend Code")),
                              ],
                            ),
                            Space.y2!,
                            Padding(
                              padding: Space.all(3, 0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (currentOTP.isEmpty ||
                                        currentOTP.length < 6) {
                                      Fluttertoast.showToast(msg: "Enter OTP!");
                                    } else {
                                      final authCubit =
                                          BlocProvider.of<PhoneAuthCubit>(
                                              context);
                                      await authCubit
                                          .authenticateOTP(currentOTP);
                                    }
                                  }
                                },
                                child: const Text(
                                  'Authenticate',
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Space.yf(0.3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
