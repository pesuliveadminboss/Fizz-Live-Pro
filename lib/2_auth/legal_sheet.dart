import 'package:flutter/material.dart';
import '../1_core/core_data.dart';

void showLegalModal(BuildContext context, String title, String content) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppTheme.cardDark,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollCtrl) => Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          controller: scrollCtrl,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close, color: Colors.white70), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const Divider(color: Colors.white24),
            const SizedBox(height: 12),
            Text(content, style: const TextStyle(color: Colors.white70, height: 1.5, fontSize: 13)),
          ],
        ),
      ),
    ),
  );
}

const String userAgreementText = '''
FIZZ LIVE PRO — USER AGREEMENT
1. Eligibility: 18+ mature platform required.
2. Zero tolerance for harassment, hate speech, or exploitation.
3. Gems are digital virtual goods for tips, private calls (1800 gems/min standard), and party rooms.
''';

const String privacyPolicyText = '''
FIZZ LIVE PRO — PRIVACY POLICY
1. Data collected: Profile name, DOB, gender identity, device/diagnostic info.
2. Video/Audio routing encrypted via ZegoCloud.
3. No Google/OAuth passwords stored locally or server-side.
''';
