final String tableChat = 'chat';
final String columnId = 'id';
final String columnContact = 'contact';
final String columnLastMessage = 'last';
final String columnAlert = 'alert';

class Chat{
  int? id;
  String? contact;
  String? last;
  int? alert;
  Chat(this.contact, this.last, this.alert);

  Map<String, Object?> toMap(){
    Map<String, Object?> map = <String, Object?>{
      columnId: id,
      columnContact: contact,
      columnLastMessage: last,
      columnAlert: alert      
    };
    return map;
  }

  
  Chat.fromMap(Map<String, Object?> map){
    id = map[columnId] as int;
    contact = map[columnContact] as String;
    last = map[columnLastMessage] as String;
    alert = map[columnAlert] as int;
  }
}