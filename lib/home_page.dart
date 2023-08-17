import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class HomePage extends StatefulWidget {
  final String fullName;
  final String email;
  final String profilePhotoUrl;
  final String resumeUrl;

  HomePage({
    required this.fullName,
    required this.email,
    required this.profilePhotoUrl,
    required this.resumeUrl,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _profilePhotoFile;

  @override
  void initState() {
    super.initState();
    _loadProfilePhotoData();
  }

  Future<void> _loadProfilePhotoData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String profilePhotoPath = widget.profilePhotoUrl;
    if (profilePhotoPath.isNotEmpty) {
      _profilePhotoFile = File(profilePhotoPath);
      setState(() {});
    }
  }

  Future<void> _handleResumeDownload() async {
    if (widget.resumeUrl.isNotEmpty) {
      final pdfPath = widget.resumeUrl;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text('Resume')),
            body: PDFView(
              filePath: pdfPath,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: _profilePhotoFile != null
                    ? FileImage(_profilePhotoFile!)
                    : const AssetImage('assets/Images/profile.jpeg') as ImageProvider<Object>,
              ),
              SizedBox(height: 20),
              Text(
                widget.fullName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                widget.email,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _handleResumeDownload,
                icon: Icon(Icons.download),
                label: Text('Download Resume'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
