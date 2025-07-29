import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetChecker {
  static final Connectivity _connectivity = Connectivity();

  static bool _isConnectedType(dynamic r) {
    if (r is List) {
      return r.contains(ConnectivityResult.mobile) || r.contains(ConnectivityResult.wifi);
    }
    return r == ConnectivityResult.mobile || r == ConnectivityResult.wifi;
  }

  /// Returns true if the device is connected to the internet (WiFi or mobile) AND can reach a real server via HTTP
  static Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    print('[InternetChecker] Connectivity result: $result');
    if (_isConnectedType(result)) {
      try {
        print('[InternetChecker] Attempting HTTP GET to google.com/generate_204');
        final httpClient = HttpClient();
        httpClient.connectionTimeout = const Duration(seconds: 2);
        final request = await httpClient.getUrl(Uri.parse('https://www.google.com/generate_204'));
        final response = await request.close();
        httpClient.close();
        print('[InternetChecker] HTTP status: ${response.statusCode}');
        return response.statusCode == 204;
      } catch (e) {
        print('[InternetChecker] HTTP request failed: $e');
        return false;
      }
    }
    print('[InternetChecker] Not connected to WiFi or mobile');
    return false;
  }

  static Stream<bool> get onStatusChange async* {
    await for (final result in _connectivity.onConnectivityChanged) {
      print('[InternetChecker] onStatusChange: Connectivity result: $result');
      if (_isConnectedType(result)) {
        try {
          print('[InternetChecker] onStatusChange: Attempting HTTP GET to google.com/generate_204');
          final httpClient = HttpClient();
          httpClient.connectionTimeout = const Duration(seconds: 2);
          final request = await httpClient.getUrl(Uri.parse('https://www.google.com/generate_204'));
          final response = await request.close();
          httpClient.close();
          print('[InternetChecker] onStatusChange: HTTP status: ${response.statusCode}');
          yield response.statusCode == 204;
        } catch (e) {
          print('[InternetChecker] onStatusChange: HTTP request failed: $e');
          yield false;
        }
      } else {
        print('[InternetChecker] onStatusChange: Not connected to WiFi or mobile');
        yield false;
      }
    }
  }
} 