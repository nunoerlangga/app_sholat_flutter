class MessageModel {
  int? id;
  String? messagePray;
  String? date;     
  int? hour;          
  int? minute;        
  String? createdAt;  
  MessageModel({
    this.id,
    this.messagePray,
    this.date,
    this.hour,
    this.minute,
    this.createdAt,
  });
  factory MessageModel.fromJson(Map<String,dynamic> json){
    return MessageModel(
      id: json['id'],
      messagePray: json['messagePray'],
      date: json['date'],
      hour: json['hour'],
      minute: json['minute'],
      createdAt: json['created_at'],
    );
  }
}