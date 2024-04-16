import 'dart:async';

import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';

import 'nothing_to_pick_exception.dart';

abstract mixin class ContentPicker {
  static const double pickRectangleSize = 25;

  HereMapController get contentPickerMapController;

  Future<List<PickedPlace>> pickPlaces(Point2D centerPoint, {
    double radius = 5
  }) async {
    Completer<List<PickedPlace>> completer = Completer();

    contentPickerMapController.pickMapContent(
        Rectangle2D(centerPoint, Size2D(pickRectangleSize, pickRectangleSize)),
        (PickMapContentResult? result) {
          if (result == null || result.pickedPlaces.length == 0) {
            completer.completeError(NothingToPickException(centerPoint));
            return;
          }

          completer.complete(result!.pickedPlaces);
        }
    );

    return completer.future;
  }
}