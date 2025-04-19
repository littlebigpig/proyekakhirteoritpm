import 'dart:async';
import 'package:flutter/material.dart';

class CountdownPage extends StatefulWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  Duration duration = Duration.zero;
  Timer? timer;
  bool isRunning = false;
  final List<Duration> laps = [];

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    if (timer != null && timer!.isActive) return;
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
    setState(() => isRunning = true);
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
    setState(() => isRunning = false);
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      duration = Duration.zero;
      laps.clear();
    });
  }

  void addLap() {
    setState(() {
      laps.insert(0, duration);
    });
  }

  void addTime() {
    const addSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lightBlue = Colors.lightBlue;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stopwatch',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: lightBlue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          children: [
            const SizedBox(height: 30),
            buildTime(),
            const SizedBox(height: 40),
            buildButtons(),
            const SizedBox(height: 20),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Laps',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: lightBlue,
                    ),
                  ),
                  Text(
                    'Time',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: lightBlue,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  laps.isEmpty
                      ? Center(
                        child: Text(
                          'No laps recorded',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      )
                      : ListView.builder(
                        itemCount: laps.length,
                        itemBuilder: (context, index) {
                          return buildLapItem(index);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLapItem(int index) {
    final lap = laps[index];
    final lapNumber = laps.length - index;
    final formattedTime = formatDuration(lap);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.lightBlue,
          child: Text(
            '$lapNumber',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          formattedTime,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          textAlign: TextAlign.end,
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return '$hours:$minutes:$seconds';
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimeCard(time: hours, header: 'HOURS'),
        buildTimeSeparator(),
        buildTimeCard(time: minutes, header: 'MINUTES'),
        buildTimeSeparator(),
        buildTimeCard(time: seconds, header: 'SECONDS'),
      ],
    );
  }

  Widget buildTimeSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        ':',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.lightBlue,
          fontSize: 60,
        ),
      ),
    );
  }

  Widget buildTimeCard({required String time, required String header}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.lightBlue,
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            time,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 48,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          header,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildButton(
          onPressed: isRunning ? stopTimer : startTimer,
          icon: isRunning ? Icons.pause : Icons.play_arrow,
          label: isRunning ? 'PAUSE' : 'START',
          backgroundColor: isRunning ? Colors.orange : Colors.green,
          iconColor: Colors.white,
        ),
        const SizedBox(width: 20),
        buildButton(
          onPressed: resetTimer,
          icon: Icons.refresh,
          label: 'RESET',
          backgroundColor: Colors.red,
          iconColor: Colors.white,
        ),
        const SizedBox(width: 20),
        buildButton(
          onPressed: isRunning ? addLap : null,
          icon: Icons.flag,
          label: 'LAP',
          backgroundColor: Colors.lightBlue,
          iconColor: Colors.white,
        ),
      ],
    );
  }

  Widget buildButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required Color backgroundColor,
    Color iconColor = Colors.black,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: onPressed == null ? Colors.grey : backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
      ),
      icon: Icon(icon, color: iconColor), 
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
