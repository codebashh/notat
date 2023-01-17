import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:noteapp/app_navigations/custom_navigate.dart';
import 'package:noteapp/configs/app_typography.dart';
import 'package:noteapp/configs/space.dart';
import 'package:noteapp/cubits/sections_cubit/cubit.dart';
import 'package:noteapp/models/section.dart';
import 'package:noteapp/screens/section_search_page/section_search_page.dart';
import 'package:noteapp/screens/sections/widgets/all_section_area.dart';
import 'package:noteapp/screens/sections/widgets/section_page_card.dart';
import 'package:noteapp/screens/sections/widgets/section_search_bar.dart';
import 'package:noteapp/utils/enums.dart';
import 'package:noteapp/widgets/buttons/custom_back_button.dart';
import 'package:noteapp/widgets/loader/full_screen_loader.dart';
import 'package:noteapp/widgets/screen/screen.dart';
import '../../configs/app_dimensions.dart';
import '../../configs/app_theme.dart';
import '../../cubits/notes_cubit/cubit.dart';
import '../../models/note.dart';
import '../../translations/locale_keys.g.dart';
import '../../widgets/custom_label_maker.dart';
import '../../widgets/no_data_found.dart';
import '../../widgets/text_fields/universal_text_field.dart';

class SectionsScreen extends StatefulWidget {
  final String? noteBookName;
  final String? notebookId;
  const SectionsScreen({Key? key, this.noteBookName, this.notebookId})
      : super(key: key);

  @override
  State<SectionsScreen> createState() => _SectionsScreenState();
}

class _SectionsScreenState extends State<SectionsScreen> {
  List<Section>? allSection = [];
  List<Note>? allNotes = [];
  bool dataLoaded = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SectionsCubit>(context)
        .getAllSectionsAndPages(widget.notebookId!);
  }

  bool isArabic() =>
      EasyLocalization.of(context)!.currentLocale == const Locale('ar', 'SA');
  @override
  Widget build(BuildContext context) {
    return Screen(
      overlayWidgets: [
        BlocBuilder<SectionsCubit, SectionsState>(builder: (context, state) {
          if (state is SectionsLoadingData) {
            return const FullScreenLoader(
              loading: true,
            );
          }
          if (state is SectionsDataLoaded && !dataLoaded) {
            allSection = state.allSections!;
            allNotes = state.allNotes!;
            dataLoaded = true;
          }
          return const SizedBox();
        })
      ],
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<SectionsCubit, SectionsState>(
            builder: (context, state) {
              return SizedBox(
                  height: AppDimensions.size!.height,
                  child: Padding(
                    padding: Space.all(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const CustomBackButton(),
                            Expanded(
                              child: Text(
                                widget.noteBookName!,
                                style: AppText.h3b,
                              ),
                            ),
                          ],
                        ),
                        (allSection!.isEmpty && allNotes!.isEmpty)
                            ? NoDataFound(
                                message: LocaleKeys.sectionNoDataDialog.tr(),
                                bottomPadding: 6,
                              )
                            : Expanded(
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        CustomNavigate.navigateToClass(
                                            context,
                                            SectionSearchPage(
                                              searchSource: [
                                                allSection
                                              ],
                                            ));
                                      },
                                      child: const SectionSearchBar(
                                        searchBarState: SearchBarState.stattic,
                                      ),
                                    ),
                                    Space.y!,
                                    Visibility(
                                        visible: allNotes!.isNotEmpty,
                                        child: SectionPageNoteCard(
                                            allNotes: allNotes)),
                                    const Divider(),
                                    Visibility(
                                      visible: allSection!.isNotEmpty,
                                      child: AllSectionArea(
                                        allSection: allSection,
                                        notebookId: widget.notebookId,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add Section',
          onPressed: onAddSectionTapped,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  onAddSectionTapped() {
    String title = '';
    String description = '';
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
                Text(LocaleKeys.createNewSection.tr()),
                UniversalTextField(
                  label: LocaleKeys.sectionTitle.tr(),
                  onChange: (value) {
                    title = value;
                  },
                ),
                UniversalTextField(
                  label: LocaleKeys.sectionDescription.tr(),
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

  void onCreatePressed(String title, String desc) {
    Section sec = Section(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: desc,
      notes: "0",
      reference: widget.notebookId!,
    );

    setState(() {
      allSection!.insert(0, sec);
    });
    BlocProvider.of<SectionsCubit>(context).createAndSaveSection(sec);

    Navigator.pop(context);
  }

  void onAddNotesTapped() {
    String title = '';
    List<String> labels = [];
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
                    if (title.isEmpty || labels.isEmpty) {
                      Fluttertoast.showToast(
                          msg: LocaleKeys.allFieldsAreMandatory.tr());
                      return;
                    }
                    onNoteCreatePressed(title, labels);
                  },
                  child: Text(LocaleKeys.create.tr()),
                )
              ],
            ),
          );
        });
  }

  void onNoteCreatePressed(String title, List<String> labels) {
    Note note = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        reference: widget.notebookId!,
        labels: labels);
    BlocProvider.of<NotesCubit>(context).createAndSaveNote(note);

    setState(() {
      allNotes!.insert(0, note);
    });

    Navigator.pop(context);
  }
}
