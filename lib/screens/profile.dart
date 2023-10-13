import 'package:construction_quality_report_2/services/db.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List reports = [];
  List issues = [];

  @override
  void initState() {
    getDataFromDB();
    super.initState();
  }

  getDataFromDB() async {
    reports = await DB.instance.getReports();
    issues = await DB.instance.getIssues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text("${reports.toString()}\n\n\n\n${issues.toString()}"),
        ),
      ),
    );
  }
}