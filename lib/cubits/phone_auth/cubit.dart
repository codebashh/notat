import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'data_provider.dart';
part 'state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  static PhoneAuthCubit cubit(BuildContext context, [bool listen = false]) =>
      BlocProvider.of<PhoneAuthCubit>(context, listen: listen);

  PhoneAuthCubit() : super(PhoneAuthDefault());
  final userRepository = PhoneAuthDataProvider();

  Future<void> authenticatePhone(String phone) async {
    emit(const PhoneAuthLoading());
    try {
      await userRepository.authenticatePhone(phone);
      emit(const PhoneAuthSuccess());
    } catch (e) {
      emit(PhoneAuthFailed(message: e.toString()));
    }
  }

  Future<void> authenticateOTP(String otp) async {
    emit(const OTPAuthLoading());
    try {
      bool isAuthenticated = await userRepository.authenticateOTP(otp);
      if (isAuthenticated) {
        emit(const OTPAuthSuccess());
      } else {
        emit(const OTPAuthFailed());
      }
    } catch (e) {
      emit(const OTPAuthFailed());
    }
  }

  Future<void> signOut() async {
    await userRepository.signout();
  }
}
