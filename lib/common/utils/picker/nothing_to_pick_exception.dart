import 'package:here_sdk/core.dart';

class NothingToPickException implements Exception {
  late final Point2D point2d;
  String get message => 'Nothing to pick at $point2d';

  NothingToPickException(this.point2d);
}