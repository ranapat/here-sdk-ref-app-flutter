/*
 * Copyright (C) 2020-2023 HERE Europe B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SPDX-License-Identifier: Apache-2.0
 * License-Filename: LICENSE
 */

import 'package:here_sdk/core.dart';

extension GeoBoxExtensionsNullable on GeoBox {
  bool get hasDiagonalLength => southWestCorner.distanceTo(northEastCorner) > 0;

  GeoBox expandedByPercentage(double percentage) {
    final double diagonalLength = southWestCorner.distanceTo(northEastCorner);
    final double padding = hasDiagonalLength ? diagonalLength * percentage : percentage;
    return expandedBy(padding, padding, padding, padding);
  }
}
