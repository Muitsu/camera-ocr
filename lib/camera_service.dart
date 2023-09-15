import 'package:permission_handler/permission_handler.dart';
// import 'package:camera/camera.dart';

class CameraService {
  Future<bool> checkPermission() async {
    bool cameraGranted = false;
    var status = await Permission.camera.status;
    if (status.isGranted) {
      cameraGranted = true;
    }
    return cameraGranted;
  }
}
