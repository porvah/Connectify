final String tableChat = 'chat';
final String columnId = 'id';
final String columnContact = 'contact';
final String columnPhone = 'phone';
final String columnLastMessage = 'last';
final String columnAlert = 'alert';
final String columnTime = 'time';

class Chat {
  int? id;
  String? contact;
  String? phone;
  String? last;
  String? time;
  int? alert;
  Chat(this.contact, this.phone, this.last, this.alert, this.time);

  Map<String, Object?> toMap() {
    Map<String, Object?> map = <String, Object?>{
      columnId: id,
      columnContact: contact,
      columnPhone: phone,
      columnLastMessage: last,
      columnAlert: alert,
      columnTime: time,
    };
    return map;
  }

  Chat.fromMap(Map<String, Object?> map) {
    id = map[columnId] as int;
    contact = map[columnContact] as String;
    phone = map[columnPhone] as String;
    last = map[columnLastMessage] as String;
    alert = map[columnAlert] as int;
    time = map[columnTime] as String;
  }
}
