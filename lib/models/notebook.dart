import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class Notebook {
  final String id;
  final String title;
  final String body;
  Color? color;
  final List<String> sections;
  Notebook({
    required this.id,
    required this.title,
    required this.body,
    required this.sections,
  }) {
    color = getRandomColor();
  }
  Notebook.withColor(
      {required this.id,
      required this.title,
      required this.body,
      this.color,
      required this.sections});

  Notebook copyWith({
    String? id,
    String? title,
    String? body,
    Color? color,
    List<String>? sections,
  }) {
    return Notebook(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      sections: sections ?? this.sections,
    );
  }

  Map<String, String> toMap() {
    return <String, String>{
      'id': id,
      'title': title,
      'body': body,
      'sections': sections.join(', ')
    };
  }

  factory Notebook.fromMap(Map<String, dynamic> map) {
    List<String> allSections = map['sections'].toString().split(', ');
    List<String> sec = allSections[0] == "empty" ? [] : allSections;

    return Notebook.withColor(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      color: getRandomColor(),
      sections: sec,
    );
  }

  String toJson() => json.encode(toMap());

  factory Notebook.fromJson(String source) =>
      Notebook.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Notebook(id: $id, title: $title, body: $body, color: $color, sections: $sections)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Notebook &&
        other.id == id &&
        other.title == title &&
        other.body == body &&
        other.color == color &&
        listEquals(other.sections, sections);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        body.hashCode ^
        color.hashCode ^
        sections.hashCode;
  }
}
