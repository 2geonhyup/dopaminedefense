import 'package:dopamine_defense_1/functions.dart';
import 'package:dopamine_defense_1/models/custom_error.dart';
import 'package:dopamine_defense_1/models/defense.dart';
import 'package:dopamine_defense_1/prompt.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dart_openai/openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/read.dart';
import '../models/user.dart';

class ReadRepository {
  final SupabaseClient supabaseClient;
  ReadRepository({required this.supabaseClient});

  Future<List<ReadModel>> getRead({required String userId}) async {
    try {
      final data = await supabaseClient
          .from('AppReadData')
          .select()
          .eq('user_id', userId) as List;
      List<ReadModel> appReadData = data.map((e) {
        return ReadModel.fromDoc(e);
      }).toList();
      print(appReadData);
      return appReadData;
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<void> sendSummary(
      {required DefenseModel defense,
      required String summary,
      required int time,
      required UserModel user}) async {
    // 채점부 코드
    OpenAI.apiKey = dotenv.get('OPEN_AI_KEY');
    var parsedFeedback; //피드백

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
        'length': defense.content.length
      });
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
