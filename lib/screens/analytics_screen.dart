import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Streamer Analytics 📊'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Overview (Last 7 Days)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _MetricCard(title: 'DAU', value: '1.2K', color: Colors.blueAccent)),
                const SizedBox(width: 12),
                Expanded(child: _MetricCard(title: 'Live Mins', value: '1,450', color: Colors.purpleAccent)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _MetricCard(title: 'Peak Viewers', value: '3.4K', color: Colors.orangeAccent)),
                const SizedBox(width: 12),
                Expanded(child: _MetricCard(title: 'Gift Value', value: '12.5K 💎', color: Color(0xFFE94057))),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Retention (D1 / D7 / D30)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: const [
                  _RetentionRow(label: 'Day 1 Retention', percentage: '45%'),
                  Divider(color: Colors.white10),
                  _RetentionRow(label: 'Day 7 Retention', percentage: '22%'),
                  Divider(color: Colors.white10),
                  _RetentionRow(label: 'Day 30 Retention', percentage: '12%'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('System Health', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: const [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Crash-free sessions'),
                      Text('99.8%', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Network failure rate'),
                      Text('0.4%', style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.title, required this.value, required this.color});
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _RetentionRow extends StatelessWidget {
  const _RetentionRow({required this.label, required this.percentage});
  final String label;
  final String percentage;

  @override
    Widget build(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(percentage, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE94057))),
        ],
      );
    }
}

