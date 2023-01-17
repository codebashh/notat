part of 'cubit.dart';

@immutable
class PhoneAuthState extends Equatable {
  final User? data;
  final String? message;

  const PhoneAuthState({
    this.data,
    this.message,
  });

  @override
  List<Object?> get props => [
        data,
        message,
      ];
}

@immutable
class PhoneAuthDefault extends PhoneAuthState {}

@immutable
class PhoneAuthLoading extends PhoneAuthState {
  const PhoneAuthLoading() : super();
}

@immutable
class PhoneAuthSuccess extends PhoneAuthState {
  const PhoneAuthSuccess({User? data}) : super();
}

@immutable
class PhoneAuthFailed extends PhoneAuthState {
  const PhoneAuthFailed({String? message}) : super(message: message);
}

@immutable
class OTPAuthLoading extends PhoneAuthState {
  const OTPAuthLoading() : super();
}
@immutable
class OTPAuthSuccess extends PhoneAuthState {
  const OTPAuthSuccess({User? data}) : super(data: data);
}
@immutable
class OTPAuthFailed extends PhoneAuthState {
  const OTPAuthFailed({String? message}) : super(message: message);
}
