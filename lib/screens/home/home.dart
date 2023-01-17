import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:noteapp/cubits/notebook_cubit/cubit.dart';
import 'package:noteapp/models/notebook.dart';
import 'package:noteapp/utils/enums.dart';
import 'package:noteapp/widgets/loader/full_screen_loader.dart';
import 'package:noteapp/widgets/no_data_found.dart';
import 'package:noteapp/widgets/text_fields/universal_text_field.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import 'package:noteapp/animations/bottom_animation.dart';
import 'package:noteapp/configs/configs.dart';
import 'package:noteapp/translations/locale_keys.g.dart';
import 'package:noteapp/widgets/note_card/note_card.dart';
import 'package:noteapp/widgets/screen/screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Notebook> notebooks = [];
  bool dataLoaded = false;
  bool isListView = true;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<NotebookCubit>(context).getAllNoteBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Screen(
      overlayWidgets: [
        BlocBuilder<NotebookCubit, NotebookState>(builder: (context, state) {
          if (state is NotebookLoadingData) {
            return const FullScreenLoader(
              loading: true,
            );
          }
          if (state is NotebookDataLoaded) {
            notebooks = state.allNoteBooks!.reversed.toList();
          }
          return const SizedBox();
        })
      ],
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<NotebookCubit, NotebookState>(
            builder: (context, state) {
              return Padding(
                padding: Space.all(1, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Space.y!,
                    Row(
                      children: [
                        const Spacer(),
                        Expanded(
                          child: Text(
                            LocaleKeys.notebooks.tr(),
                            style: AppText.h3b,
                          ),
                        ),
                        Space.xf(4),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isListView = !isListView;
                            });
                          },
                          icon: isListView
                              ? const Icon(Icons.grid_view_outlined)
                              : const Icon(
                                  Icons.view_agenda_outlined,
                                ),
                        ),
                      ],
                    ),
                    Space.y1!,
                    notebooks.isEmpty
                        ? NoDataFound(
                            message: LocaleKeys.homeNoDataDialog.tr(),
                          )
                        : getAllNotebooks()
                  ],
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add Notebook',
          onPressed: onAddNoteBookPressed,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  onAddNoteBookPressed() {
    String title = '';
    String description = '';
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: Space.all(),
            decoration: BoxDecoration(
              color: AppTheme.c!.background!,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: AppDimensions.size!.height * 0.4,
            child: Column(
              children: [
                Text(LocaleKeys.createNewNotebook.tr()),
                UniversalTextField(
                  label: LocaleKeys.notebookTitle.tr(),
                  onChange: (value) {
                    title = value;
                  },
                ),
                UniversalTextField(
                  label: LocaleKeys.notebookDesc.tr(),
                  maxLines: 3,
                  onChange: (value) {
                    description = value;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (title.isEmpty) {
                      Fluttertoast.showToast(
                          msg: LocaleKeys.allFieldsAreMandatory.tr());
                      return;
                    }
                    onCreatePressed(title, description);
                  },
                  child: Text(LocaleKeys.create.tr()),
                )
              ],
            ),
          );
        });
  }

  onCreatePressed(String title, String desc) {
    Notebook nb = Notebook(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: desc,
      sections: ["empty"],
    );
    BlocProvider.of<NotebookCubit>(context).createAndSaveNotebook(nb);
    nb = nb.copyWith(sections: []);
    setState(() {
      notebooks.insert(0, nb);
    });

    Navigator.pop(context);
  }

  editNote(Notebook note) {
    String newTitle = note.title;
    String newDescription = note.body;
    String currentTitle = note.title;
    String currentDescription = note.body;
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: Space.all(),
            decoration: BoxDecoration(
              color: AppTheme.c!.background!,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: AppDimensions.size!.height * 0.4,
            child: Column(
              children: [
                const Text("Update Notebook Details"),
                UniversalTextField(
                  label: LocaleKeys.notebookTitle.tr(),
                  onChange: (value) {
                    newTitle = value;
                  },
                  initialValue: currentTitle,
                ),
                UniversalTextField(
                  label: LocaleKeys.notebookDesc.tr(),
                  maxLines: 3,
                  onChange: (value) {
                    newDescription = value;
                  },
                  initialValue: currentDescription,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (newTitle.isEmpty) {
                      Fluttertoast.showToast(
                          msg: LocaleKeys.allFieldsAreMandatory.tr());
                      return;
                    } else if (currentTitle == newTitle &&
                        currentDescription == newDescription) {
                      Fluttertoast.showToast(msg: "No Changes Made");
                      Navigator.pop(context);
                    } else {
                      Notebook notebook = Notebook(
                        id: note.id,
                        title: newTitle,
                        body: newDescription,
                        sections: note.sections,
                      );
                      onUpdatePressed(notebook);
                    }
                  },
                  child: const Text("Update"),
                )
              ],
            ),
          );
        });
  }

  void onUpdatePressed(Notebook notebook) async {
    BlocProvider.of<NotebookCubit>(context).editNotebook(notebook);
    Navigator.pop(context);
    setState(() {});
    Fluttertoast.showToast(msg: "Notebook updated");
  }

  getAllNotebooks() {
    return isListView
        ? Expanded(
            child: ReorderableListView.builder(
              onReorder: (oldIndex, newIndex) {
                int index = newIndex > oldIndex ? newIndex - 1 : newIndex;
                final note = notebooks.removeAt(oldIndex);
                notebooks.insert(index, note);
                BlocProvider.of<NotebookCubit>(context)
                    .reorderNotebook(note, index, oldIndex);
              },
              itemCount: notebooks.length,
              itemBuilder: (context, index) => WidgetAnimator(
                key: ObjectKey(notebooks[index]),
                child: Stack(
                  children: [
                    NoteCard<Notebook>(
                      note: notebooks[index],
                      noteCardType: NoteCardType.notebook,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () => showEditDeleteSheet(notebooks[index]),
                        icon: const Icon(Icons.more_horiz),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Expanded(
            child: ReorderableGridView.count(
              childAspectRatio: Platform.isIOS
                  ? 0.94
                  : MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 1.8),
              crossAxisSpacing: AppDimensions.normalize(5),
              onReorder: (oldIndex, newIndex) {
                //int index = newIndex > oldIndex ? newIndex - 1 : newIndex;
                final note = notebooks.removeAt(oldIndex);
                notebooks.insert(newIndex, note);
                BlocProvider.of<NotebookCubit>(context)
                    .reorderNotebook(note, newIndex, oldIndex);
                
                setState(() {});
              },
              crossAxisCount: 2,
              children: List.generate(
                notebooks.length,
                (index) => WidgetAnimator(
                  key: ObjectKey(notebooks[index]),
                  child: Stack(
                    children: [
                      NoteCard<Notebook>(
                        note: notebooks[index],
                        noteCardType: NoteCardType.notebook,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () =>
                              showEditDeleteSheet(notebooks[index]),
                          icon: const Icon(Icons.more_horiz),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  void showEditDeleteSheet(Notebook note) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.c!.background!,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                tileColor: AppTheme.c!.background!,
                onTap: () {
                  Navigator.pop(context);
                  editNote(note);
                },
                leading: const Icon(
                  Icons.edit,
                ),
                title: const Text("Edit Notebook"),
              ),
              Space.yf(0.3),
              ListTile(
                tileColor: AppTheme.c!.background!,
                onTap: () {
                  Navigator.pop(context);
                  BlocProvider.of<NotebookCubit>(context).deleteNotebook(note);
                  Fluttertoast.showToast(msg: "Notebook Deleted");
                },
                leading: const Icon(
                  Icons.delete_outline,
                ),
                title: const Text("Delete Notebook"),
              ),
            ],
          ),
        );
      },
    );
  }
}
