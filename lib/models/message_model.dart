import 'dart:convert';

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
  final String? id;
  final String? senderDocId;
  final String? receiverDocId;
  final String? message;
  final DateTime? sentAt;
  final dynamic seenAt;
  final bool? isSeen;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Message({
    this.id,
    this.senderDocId,
    this.receiverDocId,
    this.message,
    this.sentAt,
    this.seenAt,
    this.isSeen,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Message copyWith({
    String? id,
    String? senderDocId,
    String? receiverDocId,
    String? message,
    DateTime? sentAt,
    dynamic seenAt,
    bool? isSeen,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      Message(
        id: id ?? this.id,
        senderDocId: senderDocId ?? this.senderDocId,
        receiverDocId: receiverDocId ?? this.receiverDocId,
        message: message ?? this.message,
        sentAt: sentAt ?? this.sentAt,
        seenAt: seenAt ?? this.seenAt,
        isSeen: isSeen ?? this.isSeen,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["_id"],
        senderDocId: json["senderDocId"],
        receiverDocId: json["receiverDocId"],
        message: json["message"],
        sentAt: json["sentAt"] == null ? null : DateTime.parse(json["sentAt"]),
        seenAt: json["seenAt"],
        isSeen: json["isSeen"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "senderDocId": senderDocId,
        "receiverDocId": receiverDocId,
        "message": message,
        "sentAt": sentAt?.toIso8601String(),
        "seenAt": seenAt,
        "isSeen": isSeen,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}
