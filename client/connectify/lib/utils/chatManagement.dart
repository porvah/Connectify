import 'dart:convert';

class ChatManagement {
  static void socketHandler(String message){
    print(message);
    Map packet = jsonDecode(message);
    
  }

}