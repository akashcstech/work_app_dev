import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/incident.dart';
import '../models/task.dart';
import '../providers/score_provider.dart';
import '../services/db_service.dart';

class IncidentLogScreen extends StatefulWidget {
  const IncidentLogScreen({super.key});

  @override
  State<IncidentLogScreen> createState() => _IncidentLogScreenState();
}

class _IncidentLogScreenState extends State<IncidentLogScreen> {
  List<Incident> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _items = await DbService.instance.getIncidents();
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _openAddSheet() async {
    String task = kTasks.first.id;
    final desc = TextEditingController();
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: StatefulBuilder(
          builder: (ctx, setS) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'REPORT NEAR MISS',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFFFC107),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 1.5),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: task,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                items: kTasks
                    .map((t) => DropdownMenuItem(
                          value: t.id,
                          child: Text(t.name),
                        ))
                    .toList(),
                onChanged: (v) => setS(() => task = v ?? task),
                decoration: _decor('Task'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: desc,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: _decor('What happened?'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (desc.text.trim().isEmpty) return;
                  await DbService.instance.insertIncident(Incident(
                    task: task,
                    description: desc.text.trim(),
                    date: DateTime.now().toIso8601String(),
                  ));
                  if (!mounted) return;
                  await context.read<ScoreProvider>().penalizeForIncident();
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                  _load();
                },
                child: const Text('SAVE REPORT'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _decor(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFFC107), width: 2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('INCIDENT LOG')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFFFC107),
        foregroundColor: Colors.black,
        onPressed: _openAddSheet,
        icon: const Icon(Icons.add_alert),
        label: const Text('REPORT',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFC107)))
          : _items.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'No near-miss reports yet.\nTap REPORT to log one.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final it = _items[i];
                    final date = DateFormat('dd MMM yyyy, HH:mm')
                        .format(DateTime.parse(it.date));
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFFFFC107), width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.report_problem,
                                  color: Color(0xFFFFC107)),
                              const SizedBox(width: 8),
                              Text(
                                it.task.toUpperCase(),
                                style: const TextStyle(
                                    color: Color(0xFFFFC107),
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Text(date,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(it.description,
                              style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
