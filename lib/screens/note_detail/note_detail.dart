import 'dart:io';

import 'package:flutter/material.dart' hide ReorderableList;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noteapp/configs/configs.dart';
import 'package:noteapp/screens/note_detail/message_holders/message_holder.dart';
import 'package:noteapp/widgets/loader/full_screen_loader.dart';
import 'package:noteapp/widgets/screen/screen.dart';
import 'package:record/record.dart';

import 'package:noteapp/cubits/note_page_cubit/cubit.dart';
import 'package:noteapp/models/message_modal.dart';
import 'package:noteapp/screens/note_detail/widgets/message_composer.dart';
import 'package:noteapp/screens/note_detail/widgets/note_page_appbar.dart';
import 'package:noteapp/utils/enums.dart';
import 'package:noteapp/widgets/my_reordable_list_view.dart';

class NoteDetailScreen extends StatefulWidget {
  final String? pageID;
  final String? noteTitle;
  const NoteDetailScreen({Key? key, this.pageID, this.noteTitle})
      : super(key: key);

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _noteController = TextEditingController();
  late AnimationController animationController;
  bool reorderActivated = false;
  bool shouldChangeState = true;

  final FocusNode _keyboardFocus = FocusNode();
  Widget myOverlay = const SizedBox();
  List<MessageModal> _allMessages = [];
  void checkPermissions() async {
    await Record().hasPermission();
  }

  @override
  void dispose() {
    _noteController.dispose();

    animationController.dispose();
    debugPrint("Note Detail Page Disposed");

    super.dispose();
  }

  reorderCallBack() {
    if (reorderActivated) {
      Fluttertoast.showToast(msg: "Reorder Disabled");
      setState(() {
        shouldChangeState = false;
        reorderActivated = false;
      });
    } else {
      Fluttertoast.showToast(msg: "Reorder Activated");
      setState(() {
        shouldChangeState = false;

        reorderActivated = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<NotepageCubit>(context).getPageMessages(widget.pageID!);
      checkPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      overlayWidgets: [
        BlocBuilder<NotepageCubit, NotepageState>(
          builder: (context, state) {
            if (state is NotePageLoadingdata) {
              return const FullScreenLoader(
                loading: true,
              );
            }
            if (state is NotePageDataLoaded) {
              if (shouldChangeState) {
                debugPrint("All Messages Updated");
                _allMessages = state.pageMessages!.reversed.toList();
                shouldChangeState = true;
              }
            }
            return Container();
          },
        )
      ],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: NotePageAppBar(
            title: widget.noteTitle,
            reorderCallBack: reorderCallBack,
          ),
          body: BlocBuilder<NotepageCubit, NotepageState>(
            builder: (context, NotepageState state) {
              if (state is ImageSelected) {
                insertImage(state.image);
              }
              if (state is NoImageSelected) {
                Navigator.pop(context);
              }
              return Column(
                children: [
                  Expanded(
                    child: getMessagesList(reorderActivated),
                  ),
                  if (!reorderActivated)
                    MessageComposer(
                      pageID: widget.pageID,
                      state: state,
                      unfocusKeyboard: () {
                        _keyboardFocus.unfocus();
                      },
                      keboardFocus: _keyboardFocus,
                      noteController: _noteController,
                      refreshState: refreshState,
                      insertMessageCallBack: insertMessageInVirtualDOM,
                      animationController: animationController,
                    ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void insertImage(File? image) {
    Navigator.pop(context);
    _allMessages.insert(
      0,
      MessageModal(
        actualMessage: image!.path,
        messageDate: DateTime.now().toIso8601String(),
        messageTime: DateTime.now().microsecondsSinceEpoch.toString(),
        pageID: widget.pageID,
        messageType: ChatMessageType.text,
      ),
    );
  }

  void pickImage(ImageSource source) {
    BlocProvider.of<NotepageCubit>(context).pickImage(source);
  }

  void refreshState() {
    BlocProvider.of<NotepageCubit>(context).getPageMessages(widget.pageID!);
  }

  Future<bool> insertMessageInVirtualDOM(MessageModal mm) async {
    await BlocProvider.of<NotepageCubit>(context)
        .saveMessage(mm, widget.pageID!);
    return true;
  }

  Widget getMessagesList(bool isReorderable) {
    return isReorderable
        ? MyReorderableListView.builder(
            padding: Space.hf(0.3),
            reverse: true,
            itemBuilder: (context, index) {
              return Row(
                key: ObjectKey(_allMessages[index]),
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MessageHolder(
                    message: _allMessages[index],
                    isReordarable: isReorderable,
                    pageID: widget.pageID,
                  ),
                ],
              );
            },
            itemCount: _allMessages.length,
            onReorder: (oldIndex, newIndex) {
              int index = newIndex > oldIndex ? newIndex - 1 : newIndex;

              final message = _allMessages.removeAt(oldIndex);

              _allMessages.insert(index, message);

              BlocProvider.of<NotepageCubit>(context).reorderMessage(
                message,
                index,
                oldIndex,
                widget.pageID!,
              );
            },
          )
        : ListView.builder(
            padding: Space.hf(0.3),
            reverse: true,
            itemCount: _allMessages.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MessageHolder(
                    message: _allMessages[index],
                    isReordarable: isReorderable,
                    pageID: widget.pageID,
                  ),
                ],
              );
            });
  }
}
