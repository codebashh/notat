import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:noteapp/configs/app_dimensions.dart';
import 'package:noteapp/configs/app_theme.dart';
import 'package:noteapp/cubits/sections_cubit/cubit.dart';
import 'package:noteapp/screens/sections/widgets/section_card.dart';
import 'package:noteapp/widgets/text_fields/universal_text_field.dart';

import '../../../animations/bottom_animation.dart';
import '../../../configs/space.dart';
import '../../../models/section.dart';
import '../../../translations/locale_keys.g.dart';
import '../../../widgets/loader/full_screen_loader.dart';

class AllSectionArea extends StatefulWidget {
  List<Section>? allSection;
  final String? notebookId;
  AllSectionArea({Key? key, this.allSection, this.notebookId})
      : super(key: key);

  @override
  State<AllSectionArea> createState() => _AllSectionAreaState();
}

class _AllSectionAreaState extends State<AllSectionArea> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SectionsCubit, SectionsState>(
      builder: ((context, state) {
        if (state is SectionsInitial) {
          return _sectionArea();
        } else if (state is SectionsLoadingData) {
          return const FullScreenLoader(
            loading: true,
          );
        } else if (state is SectionsDataLoaded) {
          widget.allSection = state.allSections!.reversed.toList();
          return _sectionArea();
        }
        return _sectionArea();
      }),
    );
  }

  Widget _sectionArea() {
    return BlocBuilder<SectionsCubit, SectionsState>(
      builder: (context, state) {
        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.allSection!.length,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, index) => WidgetAnimator(
                    key: ValueKey(widget.allSection![index].id),
                    child: GestureDetector(
                      onLongPress: () {
                        showEditDeleteSheet(widget.allSection![index]);
                      },
                      child: SectionCard(
                        section: widget.allSection![index],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  onEditSectionPressed(Section section) {
    String newTitle = section.title;
    String newDescription = section.body;
    String currentTitle = section.title;
    String currentDescription = section.body;
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
                const Text("Update Section Details"),
                UniversalTextField(
                  label: LocaleKeys.sectionTitle.tr(),
                  onChange: (value) {
                    newTitle = value;
                  },
                  initialValue: currentTitle,
                ),
                UniversalTextField(
                  label: LocaleKeys.sectionDescription.tr(),
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
                      Section newSection = Section(
                        body: newDescription,
                        id: section.id,
                        title: newTitle,
                        reference: section.reference,
                        notes: section.notes,
                      );
                      onMakeChangesPressed(newSection);
                      BlocProvider.of<SectionsCubit>(context)
                          .getAllSectionsAndPages(widget.notebookId!);
                    }
                  },
                  child: const Text("Update"),
                )
              ],
            ),
          );
        });
  }

  onMakeChangesPressed(Section section) async{
    await BlocProvider.of<SectionsCubit>(context).editAndSaveSection(section);
    Navigator.pop(context);
    Fluttertoast.showToast(msg: "Section Updated");
  }

  void showEditDeleteSheet(Section section) {
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
                onTap: () {
                  Navigator.pop(context);
                  onEditSectionPressed(section);
                },
                leading: const Icon(
                  Icons.edit,
                ),
                title: const Text("Edit Section"),
              ),
              Space.yf(0.3),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  BlocProvider.of<SectionsCubit>(context)
                      .deleteSection(section);
                  BlocProvider.of<SectionsCubit>(context)
                        .getAllSectionsAndPages(widget.notebookId!);
                  Fluttertoast.showToast(msg: "Section Deleted");
                },
                leading: const Icon(
                  Icons.delete_outline,
                ),
                title: const Text("Delete Section"),
              ),
            ],
          ),
        );
      },
    );
  }
}
