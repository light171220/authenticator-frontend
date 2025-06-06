import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workmanager/workmanager.dart';

import 'app/app.dart';
import 'core/di/injection.dart';
import 'core/services/background_service.dart';
import 'core/utils/logger/app_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  await configureDependencies();
  
  await Workmanager().initialize(
    BackgroundOTPService.callbackDispatcher,
    isInDebugMode: false,
  );
  
  AppLogger.initialize();
  
  runApp(const PQCAuthenticatorApp());
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    return BackgroundOTPService.handleBackgroundTask(task, inputData);
  });
}