// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

/* import 'package:uuid/uuid.dart';
import 'package:construction_quality_report_2/services/db.dart'; */

// title
// description
// time
// image

class Issue {
  final String id;
  final String title;
  final String description;
  late String time;
  final String image;

  Issue({
    String? time,
    required this.id,
    required this.title,
    required this.description,
    required this.image,
  }) {
    this.time = time ?? DateTime.now().toString().substring(0, 19);
  }

  Issue copyWith({
    String? id,
    String? title,
    String? description,
    String? time,
    String? image,
  }) {
    return Issue(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'time': time,
      'image': image,
    };
  }

  factory Issue.fromMap(Map<String, dynamic> map) {
    return Issue(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      time: map['time'] as String,
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Issue.fromJson(String source) =>
      Issue.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Issue(id: $id, title: $title, description: $description, time: $time, image: $image)';
  }

  @override
  bool operator ==(covariant Issue other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.time == time &&
        other.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        time.hashCode ^
        image.hashCode;
  }
}
