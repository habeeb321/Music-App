import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends GetxController {
  void requestPermission() async {
    await Permission.storage.request();
    update();
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
