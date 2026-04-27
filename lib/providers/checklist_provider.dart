import 'package:flutter/foundation.dart';
import '../models/task.dart';

enum RiskLevel { low, medium, high }

class ChecklistProvider extends ChangeNotifier {
  SafetyTask? _task;
  final Set<String> _checked = {};

  SafetyTask? get task => _task;
  Set<String> get checked => _checked;

  void startTask(SafetyTask t) {
    _task = t;
    _checked.clear();
    notifyListeners();
  }

  void toggle(String gearId) {
    if (_checked.contains(gearId)) {
      _checked.remove(gearId);
    } else {
      _checked.add(gearId);
    }
    notifyListeners();
  }

  bool isChecked(String gearId) => _checked.contains(gearId);

  int get missingCount =>
      (_task?.gear.length ?? 0) - _checked.length;

  RiskLevel get risk {
    final m = missingCount;
    if (m <= 0) return RiskLevel.low;
    if (m == 1) return RiskLevel.medium;
    return RiskLevel.high;
  }

  double get progress {
    if (_task == null || _task!.gear.isEmpty) return 0;
    return _checked.length / _task!.gear.length;
  }

  bool get allChecked => _task != null && missingCount == 0;
}
