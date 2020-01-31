/*
 * Copyright (c) 2019 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
import 'geometry.dart';
import 'photo.dart';

class Result {
  final Geometry geometry;
  final String icon;
  final String id;
  final String name;
  final List<Photo> photos;
  final String placeId;
  final double rating;
  final String reference;
  final String scope;
  final List<String> types;
  final int userRatingsTotal;
  final String vicinity;

  Result({this.geometry, this.icon, this.id, this.name, this.placeId, this.reference,
      this.scope, this.vicinity, this.types, this.photos,
      this.userRatingsTotal, this.rating});

      factory Result.fromJson(Map<String, dynamic> json){
        return Result(
          geometry: Geometry.fromJson(json['geometry']),
          icon: json['icon'],
          id: json['id'],
          name: json['name'],
          photos: json['photos'] != null ? json['photos'].map<Photo>((i) => Photo.fromJson(i)).toList(): [],
          placeId: json['place_id'],
          rating: json['rating'] != null ? json['rating'].toDouble(): 0.0,
          reference: json['reference'],
          scope: json['scope'],
          types: List<String>.from(json['types']),
          userRatingsTotal: json['user_ratings_total'],
          vicinity: json['vicinity'],
        );
      }
}