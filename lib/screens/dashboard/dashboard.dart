import 'package:flutter/material.dart';
import 'package:noteapp/app_navigations/custom_navigate.dart';
import 'package:noteapp/configs/app.dart';
import 'package:noteapp/configs/configs.dart';

class TemporaryDashboard extends StatelessWidget {
  const TemporaryDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Scaffold(
      body: Padding(
        padding: Space.all(2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Add Buttuns for screens and stuff temporaily so we dont have to edit main route again and again',
              textAlign: TextAlign.center,
            ),
            const Divider(),
            ElevatedButton(
              onPressed: () {
                CustomNavigate.navigateTo(context,"noteDetail");
              },
              child: const Text("Note Screen"),
            ),
          ],
        ),
      ),
    );
  }
}
