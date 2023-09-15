import 'package:camera/camera.dart';
import 'package:camera_practice/view_image.dart';
import 'package:flutter/material.dart';

class CameraView extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraView({super.key, required this.cameras});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  late CameraController? controller;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCameraController(widget.cameras[0]);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller!.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraController(cameraController.description);
    }
  }

  void _initializeCameraController(CameraDescription description) {
    controller =
        CameraController(description, ResolutionPreset.max, enableAudio: false);

    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  Widget cameraWidget(context) {
    if (!controller!.value.isInitialized) {
      return Container();
    }
    var camera = controller!.value;
    // fetch screen size
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * camera.aspectRatio;
    if (scale < 1) scale = 1 / scale;
    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(controller!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!controller!.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: cameraWidget(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(onPressed: () async {
        await controller!.setFocusMode(FocusMode.locked);
        await controller!.setExposureMode(ExposureMode.locked);

        controller!.takePicture().then((value) {
          value.readAsBytes().then((bytes) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => ViewImage(imgBytes: bytes)));
          });
        });
      }),
    );
  }
}
