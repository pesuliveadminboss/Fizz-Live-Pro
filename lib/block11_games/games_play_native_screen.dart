import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'game_sound_helper.dart';
import '../block10_monetization/admob_monetization_helper.dart';

class GamesPlayNativeScreen extends StatefulWidget {
  final String gameTitle;
  final String gameUrl; // 👉 Real HTML5 game URL

  const GamesPlayNativeScreen({
    super.key,
    required this.gameTitle,
    required this.gameUrl,
  });

  @override
  State<GamesPlayNativeScreen> createState() => _GamesPlayNativeScreenState();
}

class _GamesPlayNativeScreenState extends State<GamesPlayNativeScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    
    AdmobMonetizationHelper.initializeAdSdk();
    GameSoundHelper.playClickSound();

    // Default fallback to Bubble Tower 3D if url is empty
    String targetUrl = widget.gameUrl.isNotEmpty 
        ? widget.gameUrl 
        : 'https://html5games.com/Game/Bubble-Tower-3D/1385d98a-b5f2-4339-bce7-b99a8dd2e8b0';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0F051D))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(targetUrl));
  }

  @override
  void dispose() {
    AdmobMonetizationHelper.initializeAdSdk();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F051D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A0B2E),
        title: Text(
          widget.gameTitle,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            GameSoundHelper.playClickSound();
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.pinkAccent,
              ),
            ),
        ],
      ),
    );
  }
}
