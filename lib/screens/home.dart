import 'package:construction_quality_report_2/models/issue.dart';
import 'package:construction_quality_report_2/models/report.dart';
import 'package:construction_quality_report_2/screens/create_report.dart';
import 'package:construction_quality_report_2/screens/profile.dart';
import 'package:construction_quality_report_2/screens/report.dart';
import 'package:construction_quality_report_2/services/db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Report> reports = [];

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
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateReport(),
                  ),
                );
              },
              child: const Icon(
                Icons.addchart_rounded,
                color: Colors.black,
                size: 25,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Profile(),
                  ),
                );
              },
              child: const Icon(
                Icons.person,
                color: Colors.black,
                size: 25,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () async {
                await dbProvider.deleteDB().then(
                      (value) => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Database deleted"),
                        ),
                      ),
                    );
              },
              child: const Icon(
                Icons.more_vert,
                color: Colors.black,
                size: 25,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
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
          child: FutureBuilder(
            future: dbProvider.getReports(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data!.isEmpty) {
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
                                left: 2, right: 5, bottom: 2),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CreateReport(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.addchart_outlined,
                              size: 28,
                            ),
                          ),
                          const Text(
                            " to add a report",
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          )
                        ],
                      )
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Flexible(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            reports = snapshot.data!.map((report) {
                              return Report(
                                id: report['id'],
                                title: report['title'],
                                location: report['location'],
                                issues: <Issue>[],
                              );
                            }).toList();
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReportScreen(
                                      report: reports[index],
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                child: ListTile(
                                  trailing: IconButton(
                                    onPressed: () {
                                      dbProvider
                                          .deleteReport(reports[index].id);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  title: Text(reports[index].location),
                                  subtitle: Text(reports[index].title),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
