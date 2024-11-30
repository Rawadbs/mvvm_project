import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConected;
}

class NetworkInfoImp implements NetworkInfo {
  final InternetConnectionChecker _internetConnectionChecker;

  NetworkInfoImp(this._internetConnectionChecker);
  @override
  Future<bool> get isConected => _internetConnectionChecker.hasConnection;
}
