import 'package:construction_quality_report_2/models/report.dart';
import 'package:construction_quality_report_2/services/db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateReport extends StatefulWidget {
  const CreateReport({super.key});

  @override
  State<CreateReport> createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // set as current datetime format as: yyyy-MM-dd HH:mm:ss Title
    _titleController.text =
        "${DateTime.now().toString().substring(0, 19)} Title";
    _locationController.text = "Location";
  }

  // create a join function, similar to python's
  join(List<Object> list, String separator) {
    String result = "";
    for (int i = 0; i < list.length; i++) {
      result += list[i].toString();
      if (i != list.length - 1) {
        result += separator;
      }
    }
    return result;
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
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a title";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: "Location",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a description";
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Report report = Report(
                      title: _titleController.text,
                      location: _locationController.text,
                      issues: [],
                    );
                    Map<String, dynamic> map = {
                      "id": report.id,
                      "title": report.title,
                      "location": report.location,
                      "issues": "",
                    };
                    await dbProvider.insertReport(map).then(
                          (value) => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Report created"),
                            ),
                          ),
                        );
                  }
                },
                child: const Text("Create"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
