import 'package:zego_express_engine/zego_express_engine.dart';

class ZegoService {
  static const int appID = 0; // Replace with your Zego AppID
  static const String appSign = "YOUR_APP_SIGN_HERE";

  static Future<void> initEngine() async {
    await ZegoExpressEngine.createEngineWithProfile(
      ZegoEngineProfile(
        appID,
        ZegoScenario.LiveStreaming,
        appSign: appSign,
      ),
    );
  }

  static Future<void> startPreview(int viewID) async {
    ZegoCanvas canvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFill);
    ZegoExpressEngine.instance.startPreview(canvas: canvas);
    ZegoExpressEngine.instance.startPublishingStream("stream_${DateTime.now().millisecondsSinceEpoch}");
  }

  static Future<void> stopRoom() async {
    await ZegoExpressEngine.instance.stopPublishingStream();
    await ZegoExpressEngine.instance.stopPreview();
  }
}

