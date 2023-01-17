part of 'cubit.dart';

abstract class NotepageState extends Equatable {
  final File? image;
  final List<MessageModal>? pageMessages;
  const NotepageState({this.image, this.pageMessages});

  @override
  List<Object> get props => [pageMessages!];
}

class NotepageInitial extends NotepageState {
  const NotepageInitial();
}

class NotePageShowSendButton extends NotepageState {
  const NotePageShowSendButton() : super();
}

class NotePageHideSendButton extends NotepageState {
  const NotePageHideSendButton() : super();
}

class NoImageSelected extends NotepageState {
  const NoImageSelected() : super();
}

class ImageSelected extends NotepageState {
  const ImageSelected(File image) : super(image: image);
}

class NotePageLoadingdata extends NotepageState {
  const NotePageLoadingdata();
}

class NotePageDataLoaded extends NotepageState {
  const NotePageDataLoaded(List<MessageModal> messages)
      : super(pageMessages: messages);
}
