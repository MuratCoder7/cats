


import 'package:logger/logger.dart';

class LogService{
  static final Logger _logger = Logger(
    printer: PrettyPrinter(),
    filter: DevelopmentFilter(),
  );

  // debugging
  static void d(String message){
    _logger.d(message);
  }

  // information
  static void i(String message){
    _logger.i(message);
  }

  // warning
  static void w(String message){
    _logger.w(message);
  }

  // error
  static void e(String message){
    _logger.e(message);
  }
}