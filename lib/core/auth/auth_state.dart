import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kSignedInKey = 'signed_in';

/// Simple persisted sign-in flag used by the router to guard protected routes.
class AuthState extends ValueNotifier<bool> {
  AuthState._() : super(false);

  static final AuthState instance = AuthState._();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    value = prefs.getBool(kSignedInKey) ?? false;
  }

  Future<void> setSignedIn(bool signedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kSignedInKey, signedIn);
    value = signedIn;
  }
}
