import 'dart:convert';
import 'package:noteapp/utils/enums.dart';

class MessageModal {
  final String? pageID;
  final String? actualMessage;
  final ChatMessageType? messageType;
  final String? messageDate;
  final String? messageTime;
  MessageModal({
    this.pageID,
    this.actualMessage,
    this.messageType,
    this.messageDate,
    this.messageTime,
  });

  static ChatMessageType? _getMessageType(String messageType) {
    if (messageType == "ChatMessageType.text") {
      return ChatMessageType.text;
    } else if (messageType == "ChatMessageType.video") {
      return ChatMessageType.video;
    } else if (messageType == "ChatMessageType.image") {
      return ChatMessageType.image;
    } else if (messageType == "ChatMessageType.document") {
      return ChatMessageType.document;
    } else if (messageType == "ChatMessageType.audio") {
      return ChatMessageType.audio;
    }
    return ChatMessageType.none;
  }

  MessageModal copyWith({
    String? pageID,
    String? actualMessage,
    ChatMessageType? messageType,
    String? messageDate,
    String? messageTime,
  }) {
    return MessageModal(
      pageID: pageID ?? this.pageID,
      actualMessage: actualMessage ?? this.actualMessage,
      messageType: messageType ?? this.messageType,
      messageDate: messageDate ?? this.messageDate,
      messageTime: messageTime ?? this.messageTime,
    );
  }

  Map<String, String> toMap() {
    return <String, String>{
      'pageID': pageID!,
      'actualMessage': actualMessage!,
      'messageType': messageType.toString(),
      'messageDate': messageDate!,
      'messageTime': messageTime!,
    };
  }

  factory MessageModal.fromMap(Map<String, dynamic> map) {
    return MessageModal(
      pageID: map['pageID'] != null ? map['pageID'] as String : null,
      actualMessage:
          map['actualMessage'] != null ? map['actualMessage'] as String : null,
      messageType: map['messageType'] != null
          ? _getMessageType(map['messageType'])
          : null,
      messageDate:
          map['messageDate'] != null ? map['messageDate'] as String : null,
      messageTime:
          map['messageTime'] != null ? map['messageTime'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModal.fromJson(String source) =>
      MessageModal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MessageModal(pageID: $pageID, actualMessage: $actualMessage, messageType: ${messageType.toString()}, messageDate: $messageDate, messageTime: $messageTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageModal &&
        other.pageID == pageID &&
        other.actualMessage == actualMessage &&
        other.messageType == messageType &&
        other.messageDate == messageDate &&
        other.messageTime == messageTime;
  }

  @override
  int get hashCode {
    return pageID.hashCode ^
        actualMessage.hashCode ^
        messageType.hashCode ^
        messageDate.hashCode ^
        messageTime.hashCode;
  }
}
