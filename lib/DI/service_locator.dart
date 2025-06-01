import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:lao_instruments/DI/service_locator.config.dart';

final getIt = GetIt.instance;

@injectableInit
Future<void> configureDependencies({String? env}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  getIt.init();
}
