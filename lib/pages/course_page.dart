import 'package:dopamine_defense_1/constants.dart';
import 'package:dopamine_defense_1/functions.dart';
import 'package:dopamine_defense_1/pages/select_page.dart';
import 'package:dopamine_defense_1/pages/summary_page.dart';
import 'package:dopamine_defense_1/providers/profile/profile_state.dart';
import 'package:dopamine_defense_1/providers/read/read_state.dart';
import 'package:dopamine_defense_1/repositories/defense_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/defense.dart';
import '../models/read.dart';
import 'feedback_page.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({Key? key}) : super(key: key);

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  List<DefenseModel>? course;
  void _getCourse() async {
    course = await context
        .read<DefenseRepository>()
        .getCourse(course: context.read<ProfileState>().user.level);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getCourse();
  }

  @override
  Widget build(BuildContext context) {
    // process ->> end 참여정보 다시 로딩
    // end ->> process 이면 채점중 띄우기
    List<ReadModel> reads = context.watch<ReadListState>().reads;
    String userDate = context.read<ProfileState>().user.date;
    print(reads);
    return ListView(
      children: course == null
          ? []
          : course!
              .map((e) => CourseCard(
                    defense: e,
                    readCheck: readCheck(
                        reads,
                        e.id,
                        e.day >
                            getDateDifference(userDate, getCurrentDate()) + 1),
                  ))
              .toList(),
    );
  }
}

class CourseCard extends StatelessWidget {
  final DefenseModel defense;
  final ReadCheck readCheck;
  const CourseCard({Key? key, required this.defense, required this.readCheck})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (readCheck == ReadCheck.process || readCheck == ReadCheck.lock)
          return;
        else if (readCheck == ReadCheck.end) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FeedbackPage(
                      defenseId: defense.id,
                    )),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SummaryPage(
                      defense: defense,
                    )),
          );
        }
      },
      splashColor: backGrey,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black45, width: 0.2))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Day ${defense.day.toString()}",
                      style: titleStyle.copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      defense.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(width: 50, height: 50, child: readCheckIcon(readCheck)),
            ],
          ),
        ),
      ),
    );
  }
}

Widget readCheckIcon(ReadCheck readCheck) {
  switch (readCheck) {
    case ReadCheck.start:
      return Icon(Icons.check_box_outline_blank);
    case ReadCheck.end:
      return Icon(
        Icons.check_box,
        color: pointColor,
      );
    case ReadCheck.process:
      return Center(
          child: SizedBox(
        width: 15,
        height: 15,
        child: CircularProgressIndicator(
          color: pointColor,
        ),
      ));
    default:
      return Icon(Icons.lock);
  }
}

enum ReadCheck { start, end, process, lock }

ReadCheck readCheck(List<ReadModel> reads, int defenseId, bool lock) {
  if (lock) return ReadCheck.lock;
  if (reads.any((element) => element.defenseId == defenseId)) {
    if (reads.any((element) =>
        element.defenseId == defenseId &&
        element.readStatus == ReadStatus.process)) {
      return ReadCheck.process;
    } else {
      return ReadCheck.end;
    }
  } else {
    return ReadCheck.start;
  }
}
