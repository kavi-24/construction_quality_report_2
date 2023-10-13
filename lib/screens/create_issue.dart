import 'dart:io';

import 'package:construction_quality_report_2/models/issue.dart';
import 'package:construction_quality_report_2/models/report.dart';
import 'package:construction_quality_report_2/services/db.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateIssue extends StatefulWidget {
  final Report report;
  const CreateIssue({super.key, required this.report});

  @override
  State<CreateIssue> createState() => _CreateIssueState();
}

class _CreateIssueState extends State<CreateIssue> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  XFile? selectedImage;

  takePicture() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        selectedImage = image;
      });
    } catch (_) {}
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Consumer<DB>(
          builder: (context, dbProvider, child) => Form(
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
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: "Description",
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
                selectedImage != null
                    ? Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            style: BorderStyle.solid,
                            color: Colors.grey,
                          ),
                        ),
                        child: Image.file(
                          File(selectedImage!.path),
                        ),
                      )
                    : const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: IconButton(
                            onPressed: takePicture,
                            icon: const Icon(Icons.add_a_photo_sharp),
                          ),
                        ),
                        const Text("Take a photo"),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: IconButton(
                            onPressed: pickImageFromGallery,
                            icon: const Icon(Icons.file_open),
                          ),
                        ),
                        const Text("Browse from device"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (selectedImage == null) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('No Image Selected'),
                              content: const Text('Please select an image'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Processing Data"),
                            ),
                          );
                          Issue issue = Issue(
                            id: widget.report.id,
                            title: _titleController.text,
                            description: _descriptionController.text,
                            image: selectedImage!.path,
                          );
                          Map<String, dynamic> map = {
                            "id": issue.id,
                            "title": issue.title,
                            "description": issue.description,
                            "time": issue.time,
                            "image": issue.image,
                          };
                          await dbProvider.insertIssue(map).then(
                                (value) =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Issue created"),
                                  ),
                                ),
                              );
                          /* await dbProvider.insertIssue(map).then((value) async {
                            await dbProvider
                                .addIssueToReport(widget.report.id, issue.id)
                                .then(
                                  (value) => ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text("Issue created"),
                                    ),
                                  ),
                                );
                          }); */
                        }
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
