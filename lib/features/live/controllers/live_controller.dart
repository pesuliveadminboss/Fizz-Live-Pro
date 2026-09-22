import 'package:get/get.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import '../../core/constants.dart';

class LiveController extends GetxController {
  var isJoined = false.obs;
  var isCameraOn = true.obs;
  var isMicOn = true.obs;

  final String streamID = 'stream_${DateTime.now().millisecondsSinceEpoch}';
  final String userID = 'user_${DateTime.now().millisecondsSinceEpoch}';

  @override
  void onInit() {
    super.onInit();
    initZegoEngine();
  }

  Future<void> initZegoEngine() async {
    await ZegoExpressEngine.createEngineWithProfile(
      ZegoEngineProfile(
        AppConstants.zegoAppId,
        ZegoScenario.LiveStreaming,
        appSign: AppConstants.zegoAppSign,
      ),
    );
  }

  Future<void> startLive() async {
    ZegoExpressEngine.instance.loginRoom(
      'fizz_room_1',
      ZegoUser(userID, 'Streamer'),
    );
    ZegoExpressEngine.instance.startPublishingStream(streamID);
    isJoined.value = true;
  }

  Future<void> stopLive() async {
    ZegoExpressEngine.instance.stopPublishingStream();
    ZegoExpressEngine.instance.logoutRoom('fizz_room_1');
    isJoined.value = false;
  }

  @override
  void onClose() {
    stopLive();
    ZegoExpressEngine.destroyEngine();
    super.onClose();
  }
}
