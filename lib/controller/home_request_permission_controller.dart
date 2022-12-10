import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeRequestPermissionController extends GetxController {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void onInit() {
    requestPermission();
    update();
    super.onInit();
  }

  void requestPermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      }
      update();
      FocusManager.instance.primaryFocus?.unfocus();
    }
    await Permission.storage.request();
  }
}
