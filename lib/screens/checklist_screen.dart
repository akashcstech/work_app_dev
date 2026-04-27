import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/checklist_provider.dart';
import '../providers/score_provider.dart';
import '../widgets/avatar_view.dart';
import '../widgets/risk_meter.dart';

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cl = context.watch<ChecklistProvider>();
    final task = cl.task;
    if (task == null) {
      return const Scaffold(body: Center(child: Text('No task selected')));
    }

    return Scaffold(
      appBar: AppBar(title: Text(task.name.toUpperCase())),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AvatarView(gear: task.gear, checked: cl.checked),
              const SizedBox(height: 16),
              RiskMeter(level: cl.risk, progress: cl.progress),
              const SizedBox(height: 16),
              // Likely injury warning
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.15),
                  border: Border.all(color: Colors.redAccent),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.redAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Likely Injury: ${task.likelyInjury}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'SAFETY GEAR CHECKLIST',
                style: TextStyle(
                  color: Color(0xFFFFC107),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              ...task.gear.map((g) {
                final isChecked = cl.isChecked(g.id);
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: isChecked
                        ? const Color(0xFFFFC107)
                        : Colors.transparent,
                    border: Border.all(
                      color: const Color(0xFFFFC107),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CheckboxListTile(
                    value: isChecked,
                    onChanged: (_) =>
                        context.read<ChecklistProvider>().toggle(g.id),
                    activeColor: Colors.black,
                    checkColor: const Color(0xFFFFC107),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Row(
                      children: [
                        Icon(g.icon,
                            size: 28,
                            color: isChecked
                                ? Colors.black
                                : const Color(0xFFFFC107)),
                        const SizedBox(width: 12),
                        Text(
                          g.name.toUpperCase(),
                          style: TextStyle(
                            color: isChecked
                                ? Colors.black
                                : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.check_circle),
                label: const Text('COMPLETE CHECKLIST'),
                onPressed: cl.allChecked
                    ? () async {
                        await context
                            .read<ScoreProvider>()
                            .addChecklistCompletion();
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('+10 Safety Score. Stay safe!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.of(context).pop();
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
