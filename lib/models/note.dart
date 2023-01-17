import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Note {
  final String id;
  final String title;
  final List<String> labels;
  final String? reference;
  Note(
      {required this.title,
      required this.labels,
      required this.id,
      required this.reference});

  Note copyWith({
    String? id,
    String? title,
    String? body,
    Color? color,
    List<String>? labels,
    String? reference,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      labels: labels ?? this.labels,
      reference: reference ?? this.reference,
    );
  }

  Map<String, String> toMap() {
    return {
      'id': id,
      'title': title,
      'labels': labels.join(', '),
      'reference': reference!,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    List<String> allLabels = map['labels'].toString().split(', ');
    List<String> labels = allLabels[0] == "empty" ? [] : allLabels;
    return Note(
        id: map['id'],
        title: map['title'],
        labels: labels,
        reference: map['reference']);
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Note(id: $id, title: $title, labels: $labels, reference: $reference)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note &&
        other.id == id &&
        other.title == title &&
        listEquals(other.labels, labels);
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ labels.hashCode;
  }
}
