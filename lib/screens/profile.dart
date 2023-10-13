import 'dart:io';
import 'package:construction_quality_report_2/screens/home.dart';
import 'package:construction_quality_report_2/services/db.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _footerTextController = TextEditingController();
  XFile? headerLogo;
  XFile? footerLogo;

  Future<void> pickImageFromGallery(XFile? currentImage) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (currentImage == headerLogo) {
        headerLogo = image;
      } else if (currentImage == footerLogo) {
        footerLogo = image;
      }
    });
  }

  @override
  void initState() {
    // update previous info
    getDetails();
    super.initState();
  }

  void getDetails() async {
    List<Map<String, dynamic>> detailsList = await DB.instance.getDetails();
    if (detailsList.isNotEmpty) {
      Map<String, dynamic> detailsMap = detailsList.first;
      setState(() {
        _fullNameController.text = detailsMap["fullName"];
        _emailController.text = detailsMap["email"];
        _companyController.text = detailsMap["company"];
        _phoneController.text = detailsMap["phone"];
        headerLogo = XFile(detailsMap["headerLogo"]);
        _footerTextController.text = detailsMap["footerText"];
        footerLogo = XFile(detailsMap["footerLogo"]);
      });
    }
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
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your full name";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a valid e-mail address";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: "Phone",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a valid phone number";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _companyController,
                    decoration: const InputDecoration(
                      labelText: "Company",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a company name";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _footerTextController,
                    decoration: const InputDecoration(
                      labelText: "Footer text (Optional)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await pickImageFromGallery(headerLogo);
                    },
                    child: const Text("Browse a header logo (Optional)"),
                  ),
                ),
                headerLogo != null
                    ? Container(
                        width: 300,
                        height: 300,
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            style: BorderStyle.solid,
                            color: Colors.grey,
                          ),
                        ),
                        child: Image.file(
                          File(headerLogo!.path),
                        ),
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await pickImageFromGallery(footerLogo);
                    },
                    child: const Text("Browse a footer logo (Optional)"),
                  ),
                ),
                footerLogo != null
                    ? Container(
                        width: 300,
                        height: 300,
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            style: BorderStyle.solid,
                            color: Colors.grey,
                          ),
                        ),
                        child: Image.file(
                          File(footerLogo!.path),
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      Map<String, dynamic> detailsMap = {
                        "fullName": _fullNameController.text,
                        "email": _emailController.text,
                        "phone": _phoneController.text,
                        "company": _companyController.text,
                        "headerLogo": headerLogo!.path,
                        "footerText": _footerTextController.text,
                        "footerLogo": footerLogo!.path,
                      };
                      dbProvider.updateDetails(detailsMap).then(
                            (value) =>
                                ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Profile details updated successfully"),
                              ),
                            ),
                          );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Home(),
                        ),
                      );
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
