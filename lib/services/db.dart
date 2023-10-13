import 'package:construction_quality_report_2/models/issue.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class DB with ChangeNotifier {
  DB._();

  static final DB instance = DB._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // If the database doesn't exist, create one and return it
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      "$path/db.db",
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE details(
          companyName TEXT,
          department TEXT,
          dateOfAudit DATE,
          auditor TEXT)
          ''',
        );
        await db.execute(
          '''CREATE TABLE reports(
          id TEXT,
          title TEXT,
          location TEXT,
          issues TEXT)
          ''',
        );
        await db.execute(
          '''CREATE TABLE issue(
            id TEXT,
            title TEXT,
            description TEXT,
            time TEXT,
            image TEXT)
            ''',
        );
      },
      version: 1,
    );
  }

  Future<List<String>> getReportsID() async {
    final db = await DB.instance.database;
    List<Map<String, dynamic>> reports = await db.query('reports');
    List<String> reportsID = [];
    for (var report in reports) {
      reportsID.add(report['id']);
    }
    return reportsID;
  }

  Future<List<String>> getIssuesID() async {
    final db = await DB.instance.database;
    List<Map<String, dynamic>> issues = await db.query('issue');
    List<String> issuesID = [];
    for (var issue in issues) {
      issuesID.add(issue['id']);
    }

    return issuesID;
  }

  /* Future<List<String>> getIssueByID(String issueID) async {
    final db = await DB.instance.database;
    List<Map<String, dynamic>> issues =
        await db.query('issue', where: 'id = ?', whereArgs: [issueID]);
    List<String> issuesID = [];
    for (var issue in issues) {
      issuesID.add(issue['id']);
    }

    return issuesID;
  } */

  Future<List<Map<String, dynamic>>> getDetails() async {
    final db = await DB.instance.database;
    List<Map<String, dynamic>> details = await db.query('details');

    return details;
  }

  Future<List<Map<String, dynamic>>> getReports() async {
    final db = await DB.instance.database;
    List<Map<String, dynamic>> reports = await db.query('reports');

    print(reports);
    return reports;
  }

  Future<List<Map<String, dynamic>>> getIssues() async {
    final db = await DB.instance.database;
    List<Map<String, dynamic>> issues = await db.query('issue');

    return issues;
  }

  Future<void> insertDetails(Map<String, dynamic> details) async {
    print(details);
    final db = await DB.instance.database;
    await db.insert('details', details);
    notifyListeners();
  }

  Future<void> updateDetails(Map<String, dynamic> details) async {
    print(details);
    final db = await DB.instance.database;
    await db.delete('details');
    await db.insert('details', details);
    notifyListeners();
  }

  Future<void> insertReport(Map<String, dynamic> report) async {
    print(report);
    final db = await DB.instance.database;
    await db.insert('reports', report);
    notifyListeners();
  }
/* 
  Future<void> addIssueToReport(String reportID, String issueID) async {
    // add the issueID to issues column in report of reportID
    // the format of issueID must be
    // issueID1,issueID2,issueID3
    // if no issues are present, update the column with issueID

    final db = await DB.instance.database;
    List<Map<String, dynamic>> reports =
        await db.query('reports', where: 'id = ?', whereArgs: [reportID]);
    String issues = reports[0]['issues'];
    if (issues.isEmpty) {
      issues = issueID;
    } else {
      issues = "$issues,$issueID";
    }
    await db.update(
      'reports',
      {'issues': issues},
      where: 'id = ?',
      whereArgs: [reportID],
    );
    notifyListeners();
  } */

  // causing database_closed error ??
  Future<List<Issue>> getIssuesByReportID(String reportID) async {
    // the issue table has a column reportID
    // get all the issues with the reportID
    final db = await DB.instance.database;
    List<Map<String, dynamic>> issues = await db
        .query('issue', where: 'id = ?', whereArgs: [reportID]);
    List<Issue> issuesList = [];
    for (var issue in issues) {
      issuesList.add(Issue.fromMap(issue));
    }
    return issuesList;
  }

  Future<void> insertIssue(Map<String, dynamic> issue) async {
    print(issue);
    final db = await DB.instance.database;
    await db.insert('issue', issue);
    notifyListeners();
  }

  // delete report with report ID and all the issues with the report ID
  Future<void> deleteReport(String reportID) async {
    final db = await DB.instance.database;
    await db.delete('reports', where: 'id = ?', whereArgs: [reportID]);
    await db.delete('issue', where: 'id = ?', whereArgs: [reportID]);
    notifyListeners();
  }

  // delete db.db
  Future<void> deleteDB() async {
    String path = await getDatabasesPath();
    await deleteDatabase("$path/db.db");
    notifyListeners();
  }

  Future<void> close() async {
    final db = await database;
    db.close();
    _database =
        null; // Set _database to null to allow reopening it later if needed

    // await DatabaseHelper.instance.close(); <- use this to close the singleton instance
  }
}
