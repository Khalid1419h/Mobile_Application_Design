import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'login_page.dart';

// ✅ API USE: Cloud Firestore API
// User profile data Firestore-এ save/load হচ্ছে
// Collection: 'users' → Document: user's UID

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final picker = ImagePicker();
  bool _isLoading = true;

  // User data from Firebase
  String name = 'Loading...';
  String email = '';
  String university = 'DIU';
  String className = 'CSE';
  String topics = 'AI, ML, Flutter';
  String gender = 'Not set';
  String dob = 'Not set';
  int participated = 0;
  int going = 0;
  int interested = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ✅ API: Firestore থেকে user data load
  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // ✅ Firebase Auth API - current user info
        setState(() => email = user.email ?? '');

        // ✅ Firestore API - user document read
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          final data = doc.data()!;
          setState(() {
            name = data['name'] ?? user.displayName ?? 'Student';
            university = data['university'] ?? 'DIU';
            className = data['className'] ?? 'CSE';
            topics = data['topics'] ?? 'AI, ML, Flutter';
            gender = data['gender'] ?? 'Not set';
            dob = data['dob'] ?? 'Not set';
            participated = data['participated'] ?? 0;
            going = data['going'] ?? 0;
            interested = data['interested'] ?? 0;
          });
        } else {
          setState(() => name = user.displayName ?? user.email?.split('@')[0] ?? 'Student');
        }
      }
    } catch (e) {
      // Firestore error হলে local defaults দেখাবে
      setState(() => name = 'Student');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ✅ API: Firestore-এ user data save
  Future<void> _saveUserData(Map<String, dynamic> updates) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(updates, SetOptions(merge: true));
      }
    } catch (e) {
      // ignore
    }
  }

  Future<void> _pickImage() async {
    if (kIsWeb) return;
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  void _editProfile() {
    String tempName = name;
    String tempUniversity = university;
    String tempClass = className;
    String tempTopics = topics;
    String tempGender = gender;
    String tempDob = dob;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildField('Name', tempName, (v) => tempName = v),
                const SizedBox(height: 12),
                _buildField('University', tempUniversity, (v) => tempUniversity = v),
                const SizedBox(height: 12),
                _buildField('Class', tempClass, (v) => tempClass = v),
                const SizedBox(height: 12),
                _buildField('Interested Topics', tempTopics, (v) => tempTopics = v),
                const SizedBox(height: 12),
                _buildField('Gender', tempGender, (v) => tempGender = v),
                const SizedBox(height: 12),
                _buildField('Date of Birth', tempDob, (v) => tempDob = v),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5C35CC),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final updates = {
                          'name': tempName,
                          'university': tempUniversity,
                          'className': tempClass,
                          'topics': tempTopics,
                          'gender': tempGender,
                          'dob': tempDob,
                        };
                        setState(() {
                          name = tempName;
                          university = tempUniversity;
                          className = tempClass;
                          topics = tempTopics;
                          gender = tempGender;
                          dob = tempDob;
                        });
                        // ✅ Firestore-এ save
                        await _saveUserData(updates);
                        if (mounted) Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✅ Profile saved to Firebase!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Save to Firebase',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String initial, Function(String) onChanged) {
    return TextFormField(
      initialValue: initial,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: onChanged,
      validator: (v) => v!.isEmpty ? 'Required' : null,
    );
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (_) => false,
                );
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  backgroundColor: const Color(0xFF5C35CC),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF5C35CC), Color(0xFF1565C0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          GestureDetector(
                            onTap: _pickImage,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 46,
                                  backgroundColor: Colors.white24,
                                  backgroundImage: _image != null
                                      ? FileImage(_image!)
                                      : const AssetImage('assets/images/d_profile.png') as ImageProvider,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.camera_alt, size: 14, color: Color(0xFF5C35CC)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            email,
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: _logout,
                    ),
                  ],
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Stats
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Expanded(child: _statCol(participated, 'Participated', Colors.purple)),
                                  const VerticalDivider(thickness: 1),
                                  Expanded(child: _statCol(going, 'Going', Colors.green)),
                                  const VerticalDivider(thickness: 1),
                                  Expanded(child: _statCol(interested, 'Interested', Colors.amber)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Firebase indicator
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.cloud_done, color: Colors.orange, size: 20),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '✅ API: Cloud Firestore',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.orange),
                                    ),
                                    Text(
                                      'Profile data Firebase-এ save হয়',
                                      style: TextStyle(fontSize: 11, color: Colors.orange),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Info tiles
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            children: [
                              _infoTile(Icons.person, 'Gender', gender, Colors.blue),
                              const Divider(height: 1, indent: 60),
                              _infoTile(Icons.cake, 'Date of Birth', dob, Colors.pink),
                              const Divider(height: 1, indent: 60),
                              _infoTile(Icons.school, 'University', university, Colors.green),
                              const Divider(height: 1, indent: 60),
                              _infoTile(Icons.class_, 'Class', className, Colors.orange),
                              const Divider(height: 1, indent: 60),
                              _infoTile(Icons.lightbulb, 'Interested Topics', topics, Colors.purple),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5C35CC),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            icon: const Icon(Icons.edit, color: Colors.white),
                            label: const Text(
                              'Edit Profile',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            onPressed: _editProfile,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _statCol(int num, String label, Color color) {
    return Column(
      children: [
        Text('$num', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _infoTile(IconData icon, String title, String value, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
    );
  }
}
