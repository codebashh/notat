part of 'cubit.dart';

abstract class SectionsState extends Equatable {
  final List<Section>? allSections;
  final List<Note>? allNotes;
  const SectionsState({this.allSections, this.allNotes});

  @override
  List<Object> get props => [];
}

class SectionsInitial extends SectionsState {}

class SectionsLoadingData extends SectionsState {
  const SectionsLoadingData();
}

class SectionsDataLoaded extends SectionsState {
  const SectionsDataLoaded(List<Section> allSections, List<Note> allNotes)
      : super(allSections: allSections, allNotes: allNotes);
}
