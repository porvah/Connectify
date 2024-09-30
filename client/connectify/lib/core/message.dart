final String tableMessage = 'message';
final String columnId = 'id';
final String columnSender = 'sender';
final String columnReceiver = 'receiver';
final String columnReplied = 'replied_id';
final String columnTime = 'time';
final String columnString = 'string_content';
final String columnAttachment = 'attachment_id';

class Message{
  int? id;
  String? sender;
  String? receiver;
  int? replied;
  String? time;
  String? stringContent;
  int? attachment_id;


  Message(this.id, this.sender, this.receiver, this.time,
   this.stringContent);


  Map<String, Object?> toMap(){
    Map<String, Object?> map = <String, Object?>{
      columnId: id,
      columnSender: sender,
      columnReceiver: receiver,
      columnTime: time,
      columnString: stringContent,
      
    };
    if(replied != null){
      map[columnReplied] = replied;
    }
    if(attachment_id != null){
      map[columnAttachment] = attachment_id;
    }
    return map;
  }

  
  Message.fromMap(Map<String, Object?> map){
    id = map[columnId] as int;
    sender = map[columnSender] as String;
    receiver = map[columnReceiver] as String;
    replied = map[columnReplied] as int?;
    time = map[columnTime] as String;
    stringContent = map[columnString] as String;
    attachment_id = map[columnAttachment] as int?;
  }
}