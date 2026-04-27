import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class ScoreProvider extends ChangeNotifier {
  static const _kScoreKey = 'safety_score';
  static const _kStreakKey = 'safety_streak';
  static const _kLastCompletedKey = 'last_completed_date';

  int _score = 0;
  int _streak = 0;

  int get score => _score;
  int get streak => _streak;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _score = prefs.getInt(_kScoreKey) ?? 0;
    _streak = prefs.getInt(_kStreakKey) ?? 0;
    notifyListeners();
  }

  Future<void> addChecklistCompletion() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final last = prefs.getString(_kLastCompletedKey);
    if (last == today) return; // one per day

    _score += 10;
    final yesterday = DateTime.now()
        .subtract(const Duration(days: 1))
        .toIso8601String()
        .substring(0, 10);
    _streak = (last == yesterday) ? _streak + 1 : 1;

    await prefs.setInt(_kScoreKey, _score);
    await prefs.setInt(_kStreakKey, _streak);
    await prefs.setString(_kLastCompletedKey, today);
    notifyListeners();
    _syncFirestore();
  }

  Future<void> penalizeForIncident() async {
    final prefs = await SharedPreferences.getInstance();
    _score = (_score - 5).clamp(0, 100000);
    _streak = 0;
    await prefs.setInt(_kScoreKey, _score);
    await prefs.setInt(_kStreakKey, _streak);
    notifyListeners();
    _syncFirestore();
  }

  Future<void> addQuizScore(int correct) async {
    final prefs = await SharedPreferences.getInstance();
    _score += correct * 2;
    await prefs.setInt(_kScoreKey, _score);
    notifyListeners();
    _syncFirestore();
  }

  Future<void> _syncFirestore() async {
    try {
      final user = AuthService.instance.currentUser;
      if (user == null) return;
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'score': _score,
        'streak': _streak,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {
      // silently fail; local is source of truth
    }
  }
}
