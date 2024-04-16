import 'package:here_sdk/animation.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';

abstract mixin class CameraAnimation {
  static const double minZoomLevelOnTwoFingerTap = 5;
  static const double maxZoomLevelOnDoubleTap = 18;
  static const double zoomLevelZoomInOnDoubleTap = 1.15;
  static const double zoomLevelZoomOutOnTwoFingerTap = 1.15;

  HereMapController get animationMapController;

  MapCameraAnimation? _cameraAnimation;

  double get doubleTapZoomLevel {
    double currentLevel = animationMapController.camera.state.zoomLevel;
    double result = currentLevel + zoomLevelZoomInOnDoubleTap;
    return result > maxZoomLevelOnDoubleTap ? maxZoomLevelOnDoubleTap : result;
  }

  double get twoFingerTapZoomLevel {
    double currentLevel = animationMapController.camera.state.zoomLevel;
    double result = currentLevel - zoomLevelZoomOutOnTwoFingerTap;
    return result < minZoomLevelOnTwoFingerTap ? minZoomLevelOnTwoFingerTap : result;
  }

  void doubleTapAt(GeoCoordinates geoCoordinates) {
    flyTo(geoCoordinates, doubleTapZoomLevel, bowFactor: 0);
  }

  void twoFingerTapAt(GeoCoordinates geoCoordinates) {
    flyTo(geoCoordinates, twoFingerTapZoomLevel);
  }

  void tapAt(GeoCoordinates geoCoordinates) {
    flyTo(geoCoordinates, animationMapController.camera.state.zoomLevel,
        bowFactor: 0, duration: Duration(milliseconds: 500)
    );
  }

  void flyTo(GeoCoordinates geoCoordinates, double zoomLevel, {
    double bowFactor = 0.5,
    Duration duration = const Duration(seconds: 1)
  }) {
    final GeoCoordinatesUpdate geoCoordinatesUpdate = GeoCoordinatesUpdate.fromGeoCoordinates(geoCoordinates);
    final MapMeasure zoom = MapMeasure(MapMeasureKind.zoomLevel, zoomLevel);

    _cancelOngoingAnimation();
    _cameraAnimation = MapCameraAnimationFactory.flyToWithZoom(
        geoCoordinatesUpdate,
        zoom, bowFactor, duration
    );
    animationMapController.camera.startAnimationWithListener(
        _cameraAnimation!,
        AnimationListener((AnimationState state) {
          if (state == AnimationState.completed || state == AnimationState.cancelled) {
            _cameraAnimation = null;
          }
        })
    );
  }

  void _cancelOngoingAnimation() {
    if (_cameraAnimation != null) {
      animationMapController.camera.cancelAnimation(_cameraAnimation!);
    }
  }
}