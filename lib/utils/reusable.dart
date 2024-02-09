import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'dart:math';
import 'dart:convert';
import 'package:image/image.dart' as img;
import 'dart:ui';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';


Future<Uint8List> generateAvatarAsync(String hash, {int size = 40, int pixelSize = 5}) async {
  final random = Random(hash.hashCode);
  final image = img.Image(size, size);
  
  final colorPalette = List.generate(5, (_) => img.getColor(random.nextInt(256), random.nextInt(256), random.nextInt(256)));
  
  for (var x = 0; x < size ~/ 2; x += pixelSize) {
    for (var y = 0; y < size; y += pixelSize) {
      final color = colorPalette[random.nextInt(colorPalette.length)];
      img.fillRect(image, x, y, x + pixelSize, y + pixelSize, color);
      img.fillRect(image, size - x - pixelSize, y, size - x, y + pixelSize, color);
    }
  }
  
    final pngBytes = img.encodePng(image);
  return Future.value(pngBytes as FutureOr<Uint8List>?);
}



String hashString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}



String shortenString(String input) {
  if (input.length <= 8) {
    return input;
  } else {
    return input.substring(0, 5) + "..." + input.substring(input.length - 5);
  }
}


String generateWalletAddress() {
  final random = Random();
  final characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final prefix = 'tz1';
  final length = 36 - prefix.length;
  final randomString = String.fromCharCodes(Iterable.generate(
      length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  return prefix + randomString;
}


String generateContractAddress(){
  final random = Random();
  final characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final prefix = 'KT1';
  final length = 36 - prefix.length;
  final randomString = String.fromCharCodes(Iterable.generate(
      length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  return prefix + randomString;
}



// Future<Uint8List> generateAvatarAsync(String hash, {int size = 40, int pixelSize = 5}) async {
//   final random = Random(hash.hashCode);
//   final image = img.Image(size, size);
  
//   final colorPalette = List.generate(5, (_) => img.getColor(random.nextInt(256), random.nextInt(256), random.nextInt(256)));
  
//   for (var x = 0; x < size ~/ 2; x += pixelSize) {
//     for (var y = 0; y < size; y += pixelSize) {
//       final color = colorPalette[random.nextInt(colorPalette.length)];
//       img.fillRect(image, x, y, x + pixelSize, y + pixelSize, color);
//       img.fillRect(image, size - x - pixelSize, y, size - x, y + pixelSize, color);
//     }
//   }
  
//     final pngBytes = img.encodePng(image);
//   return Future.value(pngBytes as FutureOr<Uint8List>?);
// }





String intToTimeLeft(int value) {
  int h, m, s;
  h = value ~/ 3600;
  m = ((value - h * 3600)) ~/ 60;
  s = value - (h * 3600) - (m * 60);
  String result = "${h}h:${m}m:${s}s";
  return result;
}

MaterialColor createMaterialColor(Color color) {  
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final r = color.red, g = color.green, b = color.blue;
  for (var i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  // ignore: avoid_function_literals_in_foreach_calls
  strengths.forEach((strength) {
    final ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch as Map<int, Color>);
}


const _chars = 'AaBbCcDdEeFfGgHh1234567890';
Random _rnd=Random();
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
String getShortAddress(String address) =>
    '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
