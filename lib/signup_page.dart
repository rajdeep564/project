import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Future<void> _handleProfilePhotoUpload() async {
    XFile? selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      setState(() {
        _profilePhotoFile = File(selectedImage.path);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile photo uploaded successfully')),
      );
    }
  }

  Future<void> _handleResumeUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _resumeFile = File(result.files.single.path!);
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Resume uploaded successfully')),
    );
  }

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  File? _profilePhotoFile;
  File? _resumeFile;

  @override
  void initState() {
    super.initState();
    _loadStoredValues();
  }

  Future<void> _loadStoredValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String storedFullName = prefs.getString('fullName') ?? '';
    String storedEmail = prefs.getString('email') ?? '';

    fullNameController.text = storedFullName;
    emailController.text = storedEmail;
  }

  Future<void> _handleSignUp() async {
    String fullName = fullNameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('fullName', fullName);
    await prefs.setString('email', email);
    await prefs.setString('password', password);

    String userIdentifier = email;
    if (_profilePhotoFile != null) {
      String profilePhotoPath = _profilePhotoFile!.path;
      await prefs.setString('profilePhoto_$userIdentifier', profilePhotoPath);
    }
    if (_resumeFile != null) {
      String resumePath = _resumeFile!.path;
      await prefs.setString('resume_$userIdentifier', resumePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create an Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _handleProfilePhotoUpload();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: Icon(Icons.camera),
                  label: Text('Upload Profile Photo'),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _handleResumeUpload();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: Icon(Icons.file_upload),
                  label: Text('Upload Resume'),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final currentContext = context;
                    await _handleSignUp();
                    Navigator.pushReplacement(
                      currentContext,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          fullName: fullNameController.text,
                          email: emailController.text,
                          profilePhotoUrl: _profilePhotoFile != null ? _profilePhotoFile!.path : '',
                          resumeUrl: _resumeFile != null ? _resumeFile!.path : '',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text('Sign Up'),
                ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {},
                child: Text('Already have an account? Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
