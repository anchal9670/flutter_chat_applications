import 'dart:convert';

ListOfMessage listOfMessageFromJson(String str) =>
    ListOfMessage.fromJson(json.decode(str));

String listOfMessageToJson(ListOfMessage data) => json.encode(data.toJson());

class ListOfMessage {
  final String? lastMessage;
  final DateTime? lastSentAt;
  final bool? isSeen;
  final String? secondPersonId;
  final String? secondPersonName;
  final String? secondPersonAvatar;

  ListOfMessage({
    this.lastMessage,
    this.lastSentAt,
    this.isSeen,
    this.secondPersonId,
    this.secondPersonName,
    this.secondPersonAvatar,
  });

  ListOfMessage copyWith({
    String? lastMessage,
    DateTime? lastSentAt,
    bool? isSeen,
    String? secondPersonId,
    String? secondPersonName,
    String? secondPersonAvatar,
  }) =>
      ListOfMessage(
        lastMessage: lastMessage ?? this.lastMessage,
        lastSentAt: lastSentAt ?? this.lastSentAt,
        isSeen: isSeen ?? this.isSeen,
        secondPersonId: secondPersonId ?? this.secondPersonId,
        secondPersonName: secondPersonName ?? this.secondPersonName,
        secondPersonAvatar: secondPersonAvatar ?? this.secondPersonAvatar,
      );

  factory ListOfMessage.fromJson(Map<String, dynamic> json) => ListOfMessage(
        lastMessage: json["lastMessage"],
        lastSentAt: json["lastSentAt"] == null
            ? null
            : DateTime.parse(json["lastSentAt"]),
        isSeen: json["isSeen"],
        secondPersonId: json["secondPersonId"],
        secondPersonName: json["secondPersonName"],
        secondPersonAvatar: json["secondPersonAvatar"],
      );

  Map<String, dynamic> toJson() => {
        "lastMessage": lastMessage,
        "lastSentAt": lastSentAt?.toIso8601String(),
        "isSeen": isSeen,
        "secondPersonId": secondPersonId,
        "secondPersonName": secondPersonName,
        "secondPersonAvatar": secondPersonAvatar,
      };
}
