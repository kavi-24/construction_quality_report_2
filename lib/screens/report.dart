import 'package:construction_quality_report_2/models/report.dart';
import 'package:construction_quality_report_2/screens/create_issue.dart';
import 'package:construction_quality_report_2/screens/issue.dart';
import 'package:construction_quality_report_2/services/db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget {
  final Report report;
  const ReportScreen({super.key, required this.report});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  void initState() {
    super.initState();
  }

  void getIssues() async {
    // get the issues list from reports table
    // format is uuid1,uuid2,uuid3
    // seperate the strings by comma
    // get the issues from issues table by id
    // add the issues to the list
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
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateIssue(report: widget.report),
                  ),
                );
              },
              child: const Icon(
                Icons.add_a_photo_outlined,
                color: Colors.black,
                size: 25,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            const Icon(
              Icons.picture_as_pdf,
              color: Colors.black,
              size: 25,
            ),
            const SizedBox(
              width: 10,
            ),
            // Icon(
            //   Icons.more_vert,
            //   color: Colors.black,
            //   size: 25,
            // ),
            // SizedBox(
            //   width: 10,
            // ),
          ],
          // leading: const Row(
          //   children: [
          // Icon(Icons.addchart_rounded),
          // Icon(Icons.person),
          // Icon(Icons.more_vert),
          //   ],
          // ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                child: FutureBuilder(
                  future: dbProvider.getIssuesByReportID(widget.report.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data!.isNotEmpty) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => IssueScreen(
                                      issue: snapshot.data![index],
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text(snapshot.data![index].title),
                                  subtitle:
                                      Text(snapshot.data![index].description),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      dbProvider
                                          .deleteIssue(snapshot.data![index]);
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Press ",
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.only(
                                      left: 2, right: 6, bottom: 3.5),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CreateIssue(
                                          report: widget.report,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 28,
                                  ),
                                ),
                                const Text(
                                  " to add an issue",
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                )
                              ],
                            )
                          ],
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
