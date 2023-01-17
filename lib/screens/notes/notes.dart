import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:noteapp/animations/bottom_animation.dart';
import 'package:noteapp/app_navigations/custom_navigate.dart';
import 'package:noteapp/configs/app_typography.dart';
import 'package:noteapp/configs/space.dart';
import 'package:noteapp/cubits/notes_cubit/cubit.dart';
import 'package:noteapp/models/note.dart';
import 'package:noteapp/screens/note_detail/note_detail.dart';
import 'package:noteapp/translations/locale_keys.g.dart';
import 'package:noteapp/widgets/custom_label_maker.dart';
import 'package:noteapp/utils/enums.dart';
import 'package:noteapp/widgets/buttons/custom_back_button.dart';
import 'package:noteapp/widgets/loader/full_screen_loader.dart';
import 'package:noteapp/widgets/note_card/note_card.dart';
import 'package:noteapp/widgets/screen/screen.dart';

import '../../configs/app_dimensions.dart';
import '../../configs/app_theme.dart';
import '../../widgets/no_data_found.dart';
import '../../widgets/text_fields/universal_text_field.dart';

class NotesScreen extends StatefulWidget {
  final String? sectionName;
  final String? sectionId;
  const NotesScreen({Key? key, this.sectionName, this.sectionId})
      : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note> allNotes = [];
  bool dataLoaded = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<NotesCubit>(context).getAllNotesBySection(widget.sectionId);
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      overlayWidgets: [
        BlocBuilder<NotesCubit, NotesState>(builder: (context, state) {
          if (state is NotesLoadingData) {
            return const FullScreenLoader(
              loading: true,
            );
          }
          if (state is NotesDataLoaded && !dataLoaded) {
            allNotes = state.allNotes!.reversed.toList();
            dataLoaded = true;
          }
          return const SizedBox();
        })
      ],
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<NotesCubit, NotesState>(
            builder: (context, state) {
              return Padding(
                padding: Space.all(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const CustomBackButton(),
                        Text(
                          widget.sectionName!,
                          style: AppText.h3b,
                        ),
                      ],
                    ),
                    Space.y!,
                    allNotes.isEmpty
                        ? NoDataFound(
                            message: LocaleKeys.notesNoDataDialog.tr(),
                          )
                        : Expanded(
                            child: ReorderableListView.builder(
                              itemCount: allNotes.length,
                              onReorder: (oldIndex, newIndex) {
                                int index = newIndex > oldIndex
                                    ? newIndex - 1
                                    : newIndex;

                                final note = allNotes.removeAt(oldIndex);
                                allNotes.insert(index, note);
                                BlocProvider.of<NotesCubit>(context)
                                    .reorderNote(note, index, oldIndex,
                                        widget.sectionId!);
                              },
                              itemBuilder: (context, index) => WidgetAnimator(
                                key: ValueKey(allNotes[index].id),
                                child: NoteCard<Note>(
                                  note: allNotes[index],
                                  noteCardType: NoteCardType.notes,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: LocaleKeys.addNewNote.tr(),
          onPressed: onAddNotesTapped,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  onAddNotesTapped() {
    String title = '';
    List<String> labels = [];
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: Space.all(),
          decoration: BoxDecoration(
            color: AppTheme.c!.background!,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          height: AppDimensions.size!.height * 0.5,
          child: Column(
            children: [
              Text(LocaleKeys.createNewNote.tr()),
              UniversalTextField(
                label: LocaleKeys.noteTitle.tr(),
                onChange: (value) {
                  title = value;
                },
              ),
              CustomLabelMaker(
                onLabelChanged: (List<String> selectedLabels) {
                  labels = selectedLabels;
                },
              ),
              Row(
                children: [
                  Space.xf(0.5),
                  Text(
                    LocaleKeys.pressSpace.tr(),
                    style: AppText.l1!.copyWith(color: Colors.grey),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (title.isEmpty) {
                    Fluttertoast.showToast(
                        msg: LocaleKeys.allFieldsAreMandatory.tr());
                    return;
                  }
                  onCreatePressed(title, labels);
                },
                child: Text(
                  LocaleKeys.create.tr(),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void onCreatePressed(String title, List<String> labels) {
    Note note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      reference: widget.sectionId!,
      labels: labels,
    );

    setState(() {
      allNotes.insert(0, note);
    });
    BlocProvider.of<NotesCubit>(context).createAndSaveNote(note);

    Navigator.pop(context);
    CustomNavigate.navigateToClass(
      context,
      NoteDetailScreen(
        pageID: note.id,
        noteTitle: note.title,
      ),
    );
  }
}
