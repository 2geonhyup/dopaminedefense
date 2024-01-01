import 'package:dopamine_defense_1/functions.dart';
import 'package:dopamine_defense_1/main.dart';
import 'package:dopamine_defense_1/models/user.dart';
import 'package:dopamine_defense_1/providers/profile/profile_provider.dart';
import 'package:dopamine_defense_1/providers/profile/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String? _grade;
  String? _difficulty;

  List<String> _gradeOptions = ['중3', '고1', '고2', '고3', '재수생', "대학생"];
  List<String> _difficultyOptions = ["고1 모의고사", "고2 모의고사", "수능 대비"];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: '이름'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이름을 입력해주세요';
                }
                return null;
              },
              onSaved: (value) {
                _name = value!;
              },
            ),
            DropdownButtonFormField(
              isExpanded: true,
              value: _grade,
              validator: (value) {
                if (value == null) {
                  return '학년을 선택해주세요';
                }
                return null;
              },
              items: _gradeOptions.map((String grade) {
                return DropdownMenuItem(
                  value: grade,
                  child: Text(grade),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _grade = newValue!;
                });
              },
              decoration: InputDecoration(labelText: '학년'),
            ),
            DropdownButtonFormField(
              value: _difficulty,
              validator: (value) {
                if (value == null) {
                  return '난이도를 선택해주세요';
                }
                return null;
              },
              items: _difficultyOptions.map((String difficulty) {
                return DropdownMenuItem(
                  value: difficulty,
                  child: Text(difficulty),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _difficulty = newValue!;
                });
              },
              decoration: InputDecoration(labelText: '희망 난이도'),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  print('이름: $_name, 학년: $_grade, 난이도: $_difficulty');
                  context.read<ProfileProvider>().setProfile(
                          user: UserModel(
                        id: supabaseClient.auth.currentUser!.email!,
                        name: _name,
                        grade: _grade!,
                        level: _difficulty!,
                        time: 0,
                        word: 0,
                        date:
                            getCurrentDate(), // 온보딩 날짜가 새로운 날짜로 들어감 (하지만 서버와의 통신부에 없으므로 첫 가입 날짜가 남음)
                      ));
                }
              },
              child: Text('제출'),
            ),
          ],
        ),
      ),
    );
  }
}
