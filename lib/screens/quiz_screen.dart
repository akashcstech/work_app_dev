import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/score_provider.dart';

class _Q {
  final String question;
  final List<String> options;
  final int answerIndex;
  const _Q(this.question, this.options, this.answerIndex);
}

const _questions = <_Q>[
  _Q(
    'Which gear is mandatory for welding?',
    ['Sunglasses', 'Welding Goggles', 'Cap'],
    1,
  ),
  _Q(
    'Before working at height you must wear a:',
    ['Harness', 'Sandals', 'Shirt only'],
    0,
  ),
  _Q(
    'A near miss should be:',
    ['Ignored', 'Reported', 'Laughed off'],
    1,
  ),
];

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final Map<int, int> _selected = {};
  bool _submitted = false;

  int get _correct {
    var c = 0;
    _selected.forEach((qi, ai) {
      if (_questions[qi].answerIndex == ai) c++;
    });
    return c;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DAILY SAFETY QUIZ')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ..._questions.asMap().entries.map((e) {
                final qi = e.key;
                final q = e.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color(0xFFFFC107), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Q${qi + 1}. ${q.question}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...q.options.asMap().entries.map((oe) {
                        final oi = oe.key;
                        final option = oe.value;
                        final isSelected = _selected[qi] == oi;
                        final correctAnswer =
                            _submitted && oi == q.answerIndex;
                        final wrongPicked = _submitted &&
                            isSelected &&
                            oi != q.answerIndex;
                        Color tile;
                        if (correctAnswer) {
                          tile = Colors.green.withOpacity(0.4);
                        } else if (wrongPicked) {
                          tile = Colors.red.withOpacity(0.4);
                        } else if (isSelected) {
                          tile = const Color(0xFFFFC107);
                        } else {
                          tile = Colors.transparent;
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: InkWell(
                            onTap: _submitted
                                ? null
                                : () => setState(() => _selected[qi] = oi),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: tile,
                                border: Border.all(
                                    color: Colors.white24, width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(option,
                                  style: TextStyle(
                                    color: isSelected && !_submitted
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }),
              if (!_submitted)
                ElevatedButton(
                  onPressed: _selected.length == _questions.length
                      ? () async {
                          setState(() => _submitted = true);
                          await context
                              .read<ScoreProvider>()
                              .addQuizScore(_correct);
                        }
                      : null,
                  child: const Text('SUBMIT'),
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC107),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.emoji_events,
                          color: Colors.black, size: 48),
                      const SizedBox(height: 8),
                      Text(
                        'YOU SCORED $_correct / ${_questions.length}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                          '+${_correct * 2} added to your Safety Score',
                          style: const TextStyle(color: Colors.black87)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
