import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noteapp/cubits/local_database_cubit/cubit.dart';
import 'package:noteapp/models/message_modal.dart';

part 'state.dart';

class NotepageCubit extends Cubit<NotepageState> {
  NotepageCubit() : super(const NotepageInitial());
  final ImagePicker _picker = ImagePicker();
  final LocalDatabaseCubit localDatabase = LocalDatabaseCubit();

  showSendButton() {
    emit(const NotePageShowSendButton());
  }

  hideSendButton() {
    emit(const NotePageHideSendButton());
  }

  pickImage(ImageSource source) async {
    File fileImage;
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      fileImage = File(image.path);

      emit(ImageSelected(fileImage));
    } else {
      emit(const NoImageSelected());
    }
  }

  Future<void> saveMessage(
    MessageModal m1,
    String pageID,
  ) async {
    await localDatabase.insertPageMessage(m1);
    List<MessageModal> messages = await localDatabase.fetchPageMessages(pageID);
    emit(NotePageDataLoaded(messages));
  }

  getPageMessages(String pageID) async {
    emit(const NotePageLoadingdata());
    List<MessageModal> messages = await localDatabase.fetchPageMessages(pageID);
    emit(NotePageDataLoaded(messages));
  }

  Future<void> reorderMessage(
      MessageModal m1, int newIndex, int oldIndex, String pageID) async {
    emit(const NotePageLoadingdata());
    await localDatabase.reorderMessage(m1, newIndex, oldIndex);
    List<MessageModal> messages = await localDatabase.fetchPageMessages(pageID);
    emit(NotePageDataLoaded(messages));
  }

  Future<void> deleteMessage(MessageModal mm, pageID) async {
    emit(const NotePageLoadingdata());
    await localDatabase.deleteMessage(mm);
    List<MessageModal> messages = await localDatabase.fetchPageMessages(pageID);
    messages.remove(mm);
    emit(NotePageDataLoaded(messages));
  }

  Future<void> printDatabase() async {
    localDatabase.printMessageTable("dummyPage");
  }

  Future<void> editMessage(MessageModal message) async {
    emit(const NotePageLoadingdata());
    await localDatabase.editMessage(message);
    await Future.delayed(const Duration(milliseconds: 500));
    List<MessageModal> messages = await localDatabase.fetchPageMessages(message.pageID.toString());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(NotePageDataLoaded(messages));
  }
}
