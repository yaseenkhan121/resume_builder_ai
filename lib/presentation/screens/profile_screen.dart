// lib/presentation/screens/profile_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _skillsController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      if (_nameController.text.isNotEmpty && user != null) {
        await user!.updateDisplayName(_nameController.text);
      }

      String? photoURL;
      if (_imageFile != null) {
        // TODO: Upload to Firebase Storage for production
        photoURL = _imageFile!.path;
      }

      await FirebaseFirestore.instance.collection("users").doc(user!.uid).set({
        "name": _nameController.text,
        "email": user!.email,
        "phone": _phoneController.text,
        "skills": _skillsController.text,
        "photoURL": photoURL ?? user!.photoURL ?? "",
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          _nameController.text = data['name'] ?? user!.displayName ?? '';
          _phoneController.text = data['phone'] ?? '';
          _skillsController.text = data['skills'] ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Picture
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : (data['photoURL'] != null &&
                          data['photoURL'].toString().isNotEmpty)
                          ? NetworkImage(data['photoURL'])
                          : const AssetImage('assets/images/avator.png')
                      as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: InkWell(
                        onTap: _pickImage,
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.deepPurple,
                          child: Icon(Icons.camera_alt,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // Name
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                // Email (read-only)
                TextField(
                  enabled: true,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email),
                    hintText: user?.email ?? "",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                // Phone
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Phone",
                    prefixIcon: const Icon(Icons.phone),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                // Skills
                TextField(
                  controller: _skillsController,
                  decoration: InputDecoration(
                    labelText: "Skills",
                    prefixIcon: const Icon(Icons.star),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 30),

                // Save Button
                ElevatedButton.icon(
                  onPressed: _saveProfile,
                  icon: const Icon(Icons.save),
                  label: const Text("Save Changes"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                // Logout Button
                ElevatedButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (!mounted) return;
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
