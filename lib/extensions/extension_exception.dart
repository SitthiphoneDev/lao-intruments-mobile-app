import 'dart:io';
import 'package:dio/dio.dart';

extension XException on Exception {
  String? toMessage() {
    if (this is DioException) {
      return (this as DioException).response?.data["error"];
    } else if (this is SocketException) {
      return "No internet connection";
    } else {
      return "Something went wrong";
    }
  }
}
