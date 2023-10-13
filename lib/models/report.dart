// title
// list of issues

import 'dart:convert';
import 'package:construction_quality_report_2/services/db.dart';
import 'package:flutter/foundation.dart';
import 'package:construction_quality_report_2/models/issue.dart';
import 'package:uuid/uuid.dart';

class Report {
  late String id;
  String title;
  String location;
  List<Issue> issues;

  Report({
    required this.title,
    required this.location,
    required this.issues,
    String? id,
  }) {
    this.id = id ?? const Uuid().v4();
  }

  setID() async {
    bool isSet = true;
    await DB.instance.getReportsID().then((value) {
      if (value.isEmpty) {
        id = "report1";
        isSet = false;
      } else {
        value.sort();
        int lastIdInt = int.parse(value.last.substring(6));
        id = "report${lastIdInt + 1}";
        isSet = false;
      }
    });
    if (!isSet) id = "report1";
  }

  Report copyWith({
    String? id,
    String? title,
    String? location,
    List<Issue>? issues,
  }) {
    return Report(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      issues: issues ?? this.issues,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'location': location,
      'issues': issues.map((x) => x.toMap()).toList(),
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'] as String,
      title: map['title'] as String,
      location: map['location'] as String,
      issues: List<Issue>.from(
        (map['issues'] as List<int>).map<Issue>(
          (x) => Issue.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source) =>
      Report.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Report(id: $id, title: $title, location: $location, issues: $issues)';
  }

  @override
  bool operator ==(covariant Report other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.location == location &&
        listEquals(other.issues, issues);
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ location.hashCode ^ issues.hashCode;
  }
}
