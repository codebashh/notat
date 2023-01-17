import 'package:flutter/material.dart';
import 'package:noteapp/models/section.dart';
import 'package:noteapp/screens/section_search_page/widgets/searched_item_tile.dart';
import 'package:noteapp/screens/sections/widgets/section_search_bar.dart';
import 'package:noteapp/utils/enums.dart';

class SectionSearchPage extends StatefulWidget {
  final List<dynamic>? searchSource;
  const SectionSearchPage({Key? key, this.searchSource}) : super(key: key);

  @override
  State<SectionSearchPage> createState() => _SectionSearchPageState();
}

class _SectionSearchPageState extends State<SectionSearchPage> {
  List<bool> searchFilter = [true, true];
  List<SearchedItemTile> result = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SectionSearchBar(
              searchBarState: SearchBarState.dynamic,
              onChanged: (val) {
                updateSearchResults(val);
              },
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  return result[index];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  onSearchFilterChange(index, state) {
    searchFilter[index] = state;
  }

  updateSearchResults(String query) {
    result = [];
    for (Section element in widget.searchSource![0]) {
      if (element.title.toLowerCase().contains(query.toLowerCase())) {
        result.add(SearchedItemTile(
          type: SearchedTileType.section,
          data: element,
        ));
      }
    }
    setState(() {});
  }
}
