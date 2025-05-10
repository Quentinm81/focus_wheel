import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:focus_wheel/ui/localization/app_localizations.dart';
import '../models/timer_session.dart';
import '../providers/timer_session_provider.dart';
import '../services/motivational_engine.dart';

class TimerCircle extends ConsumerStatefulWidget {
  const TimerCircle({super.key});

  @override
  ConsumerState<TimerCircle> createState() => _TimerCircleState();
}

class _TimerCircleState extends ConsumerState<TimerCircle>
    with SingleTickerProviderStateMixin {
  static const durations = [10, 20, 30, 45];
  int _selectedDuration = durations[0];
  int _remainingSeconds = durations[0] * 60;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _remainingSeconds = _selectedDuration * 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _timer?.cancel();
        setState(() => _isRunning = false);
        _showCompletionFeedback();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _showCompletionFeedback() async {
    // Log session to Hive
    final session = TimerSession(
      id: const Uuid().v4(),
      durationMinutes: _selectedDuration,
      startedAt: DateTime.now().subtract(Duration(minutes: _selectedDuration)),
      completedAt: DateTime.now(),
    );
    ref.read(timerSessionsProvider.notifier).addSession(session);
    // Show context-aware motivational feedback
    final phrase = await MotivationalEngine.getPhrase(tags: ['timer', 'focus']);
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(AppLocalizations.of(context)!.translate('wellDone')),
        content: Text(AppLocalizations.of(context)!
                .translate('youCompletedFocusSession') +
            '\n\n"$phrase"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.translate('ok')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final percent = _remainingSeconds / (_selectedDuration * 60);
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    final timerStats = ref.watch(timerSessionsProvider);
    final totalSessions = timerStats.length;
    final totalMinutes =
        timerStats.fold(0, (sum, s) => sum + s.durationMinutes);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final d in durations)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: ChoiceChip(
                  label: Text('$d min'),
                  selected: _selectedDuration == d,
                  onSelected: _isRunning
                      ? null
                      : (selected) {
                          if (selected) {
                            setState(() {
                              _selectedDuration = d;
                              _remainingSeconds = d * 60;
                            });
                          }
                        },
                  selectedColor: const Color(0xFFAED581),
                  backgroundColor: Colors.grey[200],
                  labelStyle: TextStyle(
                    color: _selectedDuration == d
                        ? Colors.white
                        : Colors.grey[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 32),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 220,
              height: 220,
              child: CircularProgressIndicator(
                value: percent,
                strokeWidth: 14,
                backgroundColor: Colors.grey[200],
                color: const Color(0xFFAED581),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$minutes:$seconds',
                    style: const TextStyle(
                        fontSize: 48, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                    _isRunning
                        ? AppLocalizations.of(context)!.translate('focusing')
                        : AppLocalizations.of(context)!.translate('ready'),
                    style: TextStyle(color: Colors.grey[600], fontSize: 18)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
        _isRunning
            ? ElevatedButton.icon(
                icon: const Icon(Icons.stop),
                label: Text(AppLocalizations.of(context)!.translate('stop')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _stopTimer,
              )
            : ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: Text(AppLocalizations.of(context)!.translate('start')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAED581),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _startTimer,
              ),
        const SizedBox(height: 28),
        Text(
            AppLocalizations.of(context)!.translate('sessions') +
                ': $totalSessions',
            style: TextStyle(color: Colors.grey[700], fontSize: 16)),
        Text(
            AppLocalizations.of(context)!.translate('totalTime') +
                ': $totalMinutes min',
            style: TextStyle(color: Colors.grey[700], fontSize: 16)),
      ],
    );
  }
}
