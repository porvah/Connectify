
import 'package:Connectify/requests/authentication_api.dart';

class UserAuthentication {
  static Future<void> sign_up(String email, String phone) async {
    AuthAPI api = AuthAPI();
    await api.signup(email, phone);
    
  }
}