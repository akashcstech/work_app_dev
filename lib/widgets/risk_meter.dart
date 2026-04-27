import 'package:flutter/material.dart';
import '../providers/checklist_provider.dart';

class RiskMeter extends StatelessWidget {
  final RiskLevel level;
  final double progress;

  const RiskMeter({super.key, required this.level, required this.progress});

  Color get _color {
    switch (level) {
      case RiskLevel.low:
        return const Color(0xFF2E7D32);
      case RiskLevel.medium:
        return const Color(0xFFFFC107);
      case RiskLevel.high:
        return const Color(0xFFD32F2F);
    }
  }

  String get _label {
    switch (level) {
      case RiskLevel.low:
        return 'LOW RISK';
      case RiskLevel.medium:
        return 'MEDIUM RISK';
      case RiskLevel.high:
        return 'HIGH RISK';
    }
  }

  IconData get _icon {
    switch (level) {
      case RiskLevel.low:
        return Icons.check_circle;
      case RiskLevel.medium:
        return Icons.warning_amber_rounded;
      case RiskLevel.high:
        return Icons.dangerous;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: _color, width: 3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_icon, color: _color, size: 32),
              const SizedBox(width: 8),
              const Text(
                'RISK LEVEL',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const Spacer(),
              Text(
                _label,
                style: TextStyle(
                  color: _color,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 18,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(_color),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toInt()}% gear equipped',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
