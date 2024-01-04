import 'package:dopamine_defense_1/functions.dart';
import 'package:dopamine_defense_1/models/custom_error.dart';
import 'package:dopamine_defense_1/models/defense.dart';
import 'package:dopamine_defense_1/models/feedback.dart';
import 'package:dopamine_defense_1/prompt.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dart_openai/openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/read.dart';
import '../models/user.dart';

class ReadRepository {
  final SupabaseClient supabaseClient;
  ReadRepository({required this.supabaseClient});

  Future<List<ReadModel>> getReadByUser({required String userId}) async {
    try {
      final data = await supabaseClient
          .from('AppReadData')
          .select()
          .eq('user_id', userId) as List;
      List<ReadModel> appReadData = data.map((e) {
        return ReadModel.fromDoc(e);
      }).toList();
      return appReadData;
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<List<ReadModel>> getReadByDefense({required int defenseId}) async {
    try {
      final data = await supabaseClient
          .from('AppReadData')
          .select()
          .eq('text_id', defenseId) as List;
      List<ReadModel> appReadData = data.map((e) {
        return ReadModel.fromDoc(e);
      }).toList();
      return appReadData;
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<List> sendSummary(
      {required DefenseModel defense,
      required String summary,
      required int time,
      required UserModel user}) async {
    // 채점부 코드
    OpenAI.apiKey = dotenv.get('OPEN_AI_KEY');
    var parsedFeedback; //피드백
    int? score;

    final systemMessage = const OpenAIChatCompletionChoiceMessageModel(
      content: summarySystemPrompt,
      role: OpenAIChatMessageRole.system,
    );

    final userMessage = OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.user,
        content: summaryUserPrompt(defense: defense.content, summary: summary));

    try {
      final chatCompletion = await OpenAI.instance.chat.create(
          model: "gpt-4-1106-preview",
          temperature: 0,
          topP: 1,
          frequencyPenalty: 0,
          presencePenalty: 0,
          maxTokens: 2048,
          messages: [
            systemMessage,
            userMessage,
          ]);

      print(chatCompletion.choices.first.message.content);
      parsedFeedback =
          safeParseJson(chatCompletion.choices.first.message.content);

      try {
        final scoreCompletion = await OpenAI.instance.chat.create(
          model: "gpt-3.5-turbo",
          messages: [
            OpenAIChatCompletionChoiceMessageModel(
              content: scoreSystemPrompt,
              role: OpenAIChatMessageRole.system,
            ),
            OpenAIChatCompletionChoiceMessageModel(
              content: parsedFeedback["Comprehensive Feedback"],
              role: OpenAIChatMessageRole.system,
            ),
          ],
          temperature: 0,
        );
        var responseData = scoreCompletion.choices.first.message.content;
        score = allToInt(responseData);
      } catch (e) {
        throw CustomError(
          code: 'Exception',
          message: e.toString(),
          plugin: 'flutter_error/server_error',
        );
      }
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }

    //제출부 코드
    try {
      await supabaseClient.from('AppReadData').insert({
        'user_id': user.id,
        'name': user.name,
        'summary': summary,
        'feedback': parsedFeedback,
        'time': time,
        'text_id': defense.id,
        'length': defense.content.length,
        "score": score,
      });
      return [score, FeedbackModel.fromJson(parsedFeedback)];
    } catch (e) {
      print(e.toString());
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }
}

int allToInt(var input) {
  if (input is String) {
    var number = double.tryParse(input);
    if (number != null) {
      return number.floor();
    } else {
      return 0;
    }
  } else if (input is num) {
    return input.floor();
  } else {
    return 0;
  }
}
