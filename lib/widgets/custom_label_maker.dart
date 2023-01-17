import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/configs/configs.dart';
import 'package:noteapp/translations/locale_keys.g.dart';

class CustomLabelMaker extends StatefulWidget {
  final Function? onLabelChanged;
  const CustomLabelMaker({Key? key, this.onLabelChanged}) : super(key: key);

  @override
  CustomLabelMakerState createState() => CustomLabelMakerState();
}

class CustomLabelMakerState extends State<CustomLabelMaker> {
  List<String> labels = [];
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        children: <Widget>[
          ...labels
              .map(
                (label) => Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Chip(
                    label: Text(label),
                    deleteIcon: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.close,
                          size: AppDimensions.normalize(5),
                        )),
                    onDeleted: () {
                      setState(() {
                        labels.remove(label);
                        widget.onLabelChanged!(labels);
                      });
                    },
                  ),
                ),
              )
              .toList(),
          Visibility(
            visible: labels.length < 5,
            child: SizedBox(
              height: AppDimensions.normalize(17),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: Space.h!,
                  hintText: LocaleKeys.labels.tr(),
                  hintStyle: AppText.b2,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(UIProps.radius),
                    borderSide: BorderSide(
                      color: AppTheme.c!.text!.withOpacity(0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(UIProps.radius),
                    borderSide: BorderSide(
                      color: AppTheme.c!.text!,
                    ),
                  ),
                ),
                controller: _emailController,
                onChanged: (String val) {
                  if (val.trim().isNotEmpty && val.endsWith(' ')) {
                    setState(() {
                      labels.add(_emailController.text.trim());
                      _emailController.text = '';
                      widget.onLabelChanged!(labels);
                    });
                  }
                },
                onEditingComplete: () {
                  if (_emailController.text.trim().isNotEmpty) {
                    setState(() {
                      labels.add(_emailController.text);
                      _emailController.text = '';
                      widget.onLabelChanged!(labels);
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
