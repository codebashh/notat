import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/translations/locale_keys.g.dart';
import 'package:noteapp/utils/enums.dart';

class SectionSearchBar extends StatefulWidget {
  final SearchBarState? searchBarState;
  final Function(String)? onChanged;
  const SectionSearchBar({Key? key, this.searchBarState, this.onChanged})
      : super(key: key);

  @override
  State<SectionSearchBar> createState() => _SectionSearchBarState();
}

class _SectionSearchBarState extends State<SectionSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: widget.searchBarState == SearchBarState.stattic
          ? staticState()
          : dynamicState(),
    );
  }

  Widget staticState() => ListTile(
        leading: const Icon(Icons.search),
        title: Text(LocaleKeys.search.tr()),
        trailing: Icon(isArabic()
            ? Icons.arrow_back_ios_new_rounded
            : Icons.arrow_right_alt_rounded),
      );

  Widget dynamicState() => ListTile(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: TextField(
          onChanged: widget.onChanged!,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: LocaleKeys.search.tr(),
          ),
        ),
        trailing: const Icon(Icons.search),
      );
  bool isArabic() =>
      EasyLocalization.of(context)!.currentLocale == const Locale('ar', 'SA');
}
