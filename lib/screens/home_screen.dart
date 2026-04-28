import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/checklist_provider.dart';
import '../providers/score_provider.dart';
import '../services/auth_service.dart';
import '../widgets/task_card.dart';
import 'checklist_screen.dart';
import 'incident_log_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final score = context.watch<ScoreProvider>();
    final user = AuthService.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RAKSHA-KAVACH',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () {
              if (!AuthService.firebaseReady) {
                AuthService.instance.webLogout(); // Web demo: go back to LoginScreen
              } else {
                AuthService.instance.signOut(); // Real Firebase logout
              }
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Score card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC107),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black, width: 3),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield, size: 48, color: Colors.black),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, ${user?.email?.split('@').first ?? 'Worker'}',
                            style: const TextStyle(
                                color: Colors.black87, fontSize: 14),
                          ),
                          Text(
                            'SAFETY SCORE: ${score.score}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            'Safe Streak: ${score.streak} day(s)',
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'SELECT TODAY\'S TASK',
                style: TextStyle(
                  color: Color(0xFFFFC107),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              ...kTasks.map((t) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TaskCard(
                      task: t,
                      onTap: () {
                        context.read<ChecklistProvider>().startTask(t);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const ChecklistScreen(),
                        ));
                      },
                    ),
                  )),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _RakshaBottomNav(
        onHomeTap: () {},
        onQuizTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const QuizScreen()),
        ),
        onProfileTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const IncidentLogScreen()),
        ),
      ),
    );
  }
}

class _RakshaBottomNav extends StatelessWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onQuizTap;
  final VoidCallback onProfileTap;

  const _RakshaBottomNav({
    required this.onHomeTap,
    required this.onQuizTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(color: Color(0xFFFFC107), width: 2),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black54, blurRadius: 12, offset: Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavCircleButton(
              icon: Icons.home,
              iconColor: Colors.black,
              onTap: onHomeTap,
            ),
            _NavCircleButton(
              icon: Icons.quiz,
              iconColor: Colors.black,
              onTap: onQuizTap,
            ),
            _NavCircleButton(
              icon: Icons.person,
              iconColor: Colors.white,
              onTap: onProfileTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavCircleButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _NavCircleButton({
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: Color(0xFFFFC107),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: 28),
      ),
    );
  }
}
