import 'package:flutter/material.dart';

import '../constants.dart';
import '../pages/loading_page.dart';

class ReloadingScreen extends StatelessWidget {
  final String text;
  const ReloadingScreen({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: regularGrey16,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, LoadingPage.routeName);
              },
              icon: const Icon(
                Icons.replay_circle_filled,
                color: greyA,
                size: 50,
              ))
        ],
      ),
    );
  }
}
