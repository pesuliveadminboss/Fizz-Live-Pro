import 'package:get/get.dart';

enum ConnectionStateEnum { connected, disconnected, connecting }

class FizzCoreController extends GetxController {
  var connectionState = ConnectionStateEnum.connected.obs;
}
