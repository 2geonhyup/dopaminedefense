import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/custom_error.dart';
import '../models/feedback.dart';

class FeedbackRepository {
  final SupabaseClient supabaseClient;
  FeedbackRepository({required this.supabaseClient});

  Future<FeedbackModel> getFeedback({required int defenseId}) async {
    try {
      var summaryData = await supabaseClient
          .from('AppReadData')
          .select()
          .eq('user_id', supabaseClient.auth.currentUser!.email.toString())
          .eq('text_id', defenseId)
          .limit(1);

      String removeJsonTags(String input) {
        return input.replaceAll('```json', '').replaceAll('```', '');
      }

      String feedbackJson = removeJsonTags(summaryData[0]["feedback"]);
      final jsonData = jsonDecode(feedbackJson) as Map<String, dynamic>;

      return FeedbackModel.fromJson(jsonData);
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }
}
