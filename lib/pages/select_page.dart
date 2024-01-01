import 'package:dopamine_defense_1/models/defense.dart';
import 'package:flutter/material.dart';

class SelectPage extends StatefulWidget {
  final DefenseModel defense;
  const SelectPage({Key? key, required this.defense}) : super(key: key);

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
