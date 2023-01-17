import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:noteapp/utils/constants.dart';

class Section {
  final String id;
  final String reference;
  final String title;
  final String body;
  Color? color;
  final String? notes;
  Section({
    required this.id,
    required this.title,
    required this.body,
    required this.reference,
    this.notes,
  }) {
    color = getRandomColor();
  }

  Section.withColor(
      {required this.id,
      required this.title,
      required this.body,
      required this.reference,
      this.color,
      required this.notes});
  Section copyWith({
    String? id,
    String? title,
    String? body,
    Color? color,
    String? notes,
    String? reference,
  }) {
    return Section(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        notes: notes ?? this.notes,
        reference: reference ?? this.reference);
  }

  Map<String, String> toMap() {
    return <String, String>{
      'id': id,
      'title': title,
      'body': body,
      'notes': notes!,
      'reference': reference
    };
  }

  factory Section.fromMap(Map<String, dynamic> map) {
    return Section.withColor(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      color: getRandomColor(),
      reference: map['reference'] as String,
      notes: map['notes'] != null ? map['notes'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Section.fromJson(String source) =>
      Section.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Section(id: $id, title: $title, body: $body, color: $color, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Section &&
        other.id == id &&
        other.title == title &&
        other.body == body &&
        other.color == color &&
        other.notes == notes;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        body.hashCode ^
        color.hashCode ^
        notes.hashCode;
  }
}
