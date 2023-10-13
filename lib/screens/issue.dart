import 'dart:io';

import 'package:construction_quality_report_2/models/issue.dart';
import 'package:construction_quality_report_2/services/db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class IssueScreen extends StatefulWidget {
  final Issue issue;
  const IssueScreen({super.key, required this.issue});

  @override
  State<IssueScreen> createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DB>(
      builder: (context, dbProvider, child) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.yellow.shade100,
          title: const Text(
            "Construction Quality Report",
            style: TextStyle(
              fontSize: 17,
              color: Colors.black,
            ),
          ),
          actions: const [
            Icon(
              Icons.add_a_photo_outlined,
              color: Colors.black,
              size: 25,
            ),
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.picture_as_pdf,
              color: Colors.black,
              size: 25,
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        widget.issue.time,
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.issue.title,
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.issue.description,
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(
                      style: BorderStyle.solid,
                      color: Colors.grey,
                    )),
                    child: Image.file(
                      File(widget.issue.image),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
