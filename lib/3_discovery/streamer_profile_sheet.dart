import 'package:flutter/material.dart';
import '../1_core/core_data.dart';
import 'streamer_model.dart';

void showStreamerProfileModal(BuildContext context, StreamerItemData streamer) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF140D26),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) => StatefulBuilder(
      builder: (context, setModalState) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollCtrl) => SingleChildScrollView(
          controller: scrollCtrl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(streamer.imageUrl, width: double.infinity, height: 260, fit: BoxFit.cover),
                  Positioned(
                    top: 16, right: 16,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ),
                  Positioned(
                    bottom: 12, left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: const [
                          Icon(Icons.diamond, color: Colors.amber, size: 14),
                          SizedBox(width: 4),
                          Text('3', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.amber, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(streamer.imageUrl),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(streamer.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text('ID ${streamer.id8Digit}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                    child: Text(streamer.status, style: const TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(streamer.country, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: Colors.pinkAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                                    child: Text('${streamer.age}', style: const TextStyle(color: Colors.pinkAccent, fontSize: 10)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setModalState(() {
                              streamer.isFollowed = !streamer.isFollowed;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(streamer.isFollowed ? 'Following' : 'Unfollowing'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.1),
                            child: Icon(
                              streamer.isFollowed ? Icons.favorite : Icons.favorite_border,
                              color: streamer.isFollowed ? Colors.white : Colors.pinkAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Text('Close Friends (0/3)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        const Spacer(),
                        const Icon(Icons.info_outline, color: Colors.white54, size: 16),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(3, (index) => Container(
                        width: 100, height: 90,
                        decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.person_add_outlined, color: Colors.white54),
                            SizedBox(height: 6),
                            Text('Waiting for\nsomeone', style: TextStyle(color: Colors.white54, fontSize: 10), textAlign: TextAlign.center),
                          ],
                        ),
                      )),
                    ),
                    const SizedBox(height: 24),
                    const Text('Introduction', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.pinkAccent.withOpacity(0.2), Colors.purpleAccent.withOpacity(0.2)]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(streamer.introduction, style: const TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                    const SizedBox(height: 24),
                    const Text('Speaking language', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    Wrap(
                      children: streamer.language.split(', ').map((lang) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(20)),
                        child: Text(lang, style: const TextStyle(color: Colors.white, fontSize: 12)),
                      )).toList(),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(color: Colors.white12, shape: BoxShape.circle),
                          child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Starting Video Call with ${streamer.name}...')));
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.video_call, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text('Video Call', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
    
