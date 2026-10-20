import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'game_wallet_manager.dart';

class GamesPlayWebviewScreen extends StatefulWidget {
  final String gameTitle;
  final String gameUrl;
  final int betAmount;

  const GamesPlayWebviewScreen({
    super.key,
    required this.gameTitle,
    required this.gameUrl,
    required this.betAmount,
  });

  @override
  State<GamesPlayWebviewScreen> createState() => _GamesPlayWebviewScreenState();
}

class _GamesPlayWebviewScreenState extends State<GamesPlayWebviewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.gameUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F051D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A0B2E),
        title: Text(widget.gameTitle, style: const TextStyle(color: Colors.white, fontSize: 16)),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '💎 Gems: ${GameWalletManager.currentUserGemsBalance}',
                style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.pinkAccent),
            ),
        ],
      ),
    );
  }
}
