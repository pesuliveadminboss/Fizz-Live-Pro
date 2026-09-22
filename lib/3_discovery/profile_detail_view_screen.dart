import 'package:flutter/material.dart';
import 'streamer_model.dart' as model;
import '../4_interactions/call_screen.dart';

class ProfileDetailViewScreen extends StatelessWidget {
  final dynamic streamer;
  const ProfileDetailViewScreen({super.key, required this.streamer});

  @override
  Widget build(BuildContext context) {
    final sName = streamer is model.StreamerItemData ? streamer.name : 'Jocelyn Kidmat';
    final sIdDigit = streamer is model.StreamerItemData ? streamer.idDigit : '8002023';
    final sCountry = streamer is model.StreamerItemData ? streamer.country : 'Delhi';
    final sInduction = streamer is model.StreamerItemData ? streamer.induction : 'main tumhen chaahati hoon. aap kitane hot hain. mere hothon ko chhuuo, aao aur mere pyaas bujhao';
    final sLang = streamer is model.StreamerItemData ? streamer.language : 'English, Hindi';

    return Scaffold(
      backgroundColor: const Color(0xFF0F0B1E),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.52,
            child: Container(
              color: Colors.black38,
              child: const Center(
                child: Icon(Icons.person, size: 100, color: Colors.white24),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black54,
                    radius: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 14),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Row(
                    children: [
                      Icon(Icons.volume_up, color: Colors.white75, size: 18),
                      SizedBox(width: 14),
                      Icon(Icons.person_add, color: Colors.white75, size: 18),
                      SizedBox(width: 14),
                      Icon(Icons.more_horiz, color: Colors.white75, size: 18),
                    ],
                  ),
                ],
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.60,
            minChildSize: 0.60,
            maxChildSize: 0.92,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF181329),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(16),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.pinkAccent,
                          ),
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    sName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.favorite_border, color: Colors.white75, size: 22),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text('ID $sIdDigit', style: const TextStyle(color: Colors.white60, fontSize: 12)),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.copy, color: Colors.white54, size: 12),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: Colors.green.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                                    child: const Text('🟢 Active', style: TextStyle(color: Colors.greenAccent, fontSize: 10)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: Colors.pink.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                                    child: const Text('Hindi', style: TextStyle(color: Colors.pinkAccent, fontSize: 10)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: Colors.purple.withOpacity(0.3), borderRadius: BorderRadius.circular(10)),
                                    child: Text('📍 $sCountry', style: const TextStyle(color: Colors.purpleAccent, fontSize: 10)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text('Introduction', style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(
                      sInduction,
                      style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.35),
                    ),
                    const SizedBox(height: 18),
                    const Text('Interest tag', style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['sexy body', 'fun show baby', 'dirtytalk'].map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(tag, style: const TextStyle(color: Colors.white, fontSize: 12)),
                      )).toList(),
                    ),
                    const SizedBox(height: 18),
                    const Text('Speaking language', style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: sLang.split(',').map<Widget>((lang) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(lang.trim(), style: const TextStyle(color: Colors.white, fontSize: 12)),
                      )).toList(),
                    ),
                    const SizedBox(height: 18),
                    const Text('Honor', style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.diamond, color: Colors.amber, size: 20),
                          const SizedBox(width: 8),
                          const Text('Charm Level', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Container(
                            width: 100,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 0.35,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CallScreen()));
                    },
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.videocam, size: 16, color: Colors.white),
                            SizedBox(width: 6),
                            Text('Video Call', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                        Text('❤️ 1800/min', style: TextStyle(color: Colors.white70, fontSize: 10)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
