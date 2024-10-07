final String tableMessage = 'message';
final String columnId = 'id';
final String columnSender = 'sender';
final String columnReceiver = 'receiver';
final String columnReplied = 'replied_id';
final String columnTime = 'time';
final String columnString = 'string_content';
final String columnAttachment = 'attachment';
final String columnStarred = 'starred';
final String columnIsSeenLevel = 'is_seen_level';

class Message {
  String? id;
  String? sender;
  String? receiver;
  String? replied;
  String? time;
  String? stringContent;
  int? starred;
  String? attachment;
  int? isSeenLevel;

  Message(this.id, this.sender, this.receiver, this.time, this.stringContent,
      this.isSeenLevel);

  Map<String, Object?> toMap() {
    Map<String, Object?> map = <String, Object?>{
      columnId: id,
      columnSender: sender,
      columnReceiver: receiver,
      columnTime: time,
      columnString: stringContent,
      columnStarred: starred,
      columnIsSeenLevel: isSeenLevel
    };
    if (replied != null) {
      map[columnReplied] = replied;
    }
    if (attachment != null) {
      map[columnAttachment] = attachment;
    }
    return map;
  }

  Message.fromMap(Map<String, Object?> map) {
    id = map[columnId] as String;
    sender = map[columnSender] as String;
    receiver = map[columnReceiver] as String;
    replied = map[columnReplied] as String?;
    time = map[columnTime] as String;
    stringContent = map[columnString] as String;
    attachment = map[columnAttachment] as String?;
    starred = map[columnStarred] as int?;
    isSeenLevel = map[columnIsSeenLevel] as int?;
  }
}
