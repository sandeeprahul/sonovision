import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';

class PremiumEditProfileScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        actions: [
          TextButton(
            child: Text('SAVE', style: TextStyle(color: Colors.blue)),
            onPressed: (){},
            // onPressed: _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Picture
              Stack(
                children: [
                  Obx(() {
                    final user = AuthController.to.user;
                    return CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: user['photoUrl'] != null
                          ? NetworkImage(user['photoUrl'])
                          : null,
                      child: user['photoUrl'] == null
                          ? Icon(Icons.person, size: 50, color: Colors.grey[600])
                          : null,
                    );
                  }),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(Icons.edit, size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),

              // Name Field
              _PremiumTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person_outline,
                validator: (value) => value!.isEmpty ? 'Enter your name' : null,
              ),
              SizedBox(height: 20),

              // Non-Editable Email
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.email_outlined, color: Colors.grey[600]),
                    SizedBox(width: 16),
                    Expanded(
                      child: Obx(() {
                        final email = AuthController.to.user['email'] ?? '';
                        _emailController.text = email;
                        return Text(email,
                            style: TextStyle(fontSize: 16, color: Colors.grey[800]));
                      }),
                    ),
                    Tooltip(
                      message: 'Contact support to change email',
                      child: Icon(Icons.info_outline, color: Colors.grey[500], size: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Change Password Section
              ExpansionTile(
                title: Text('Change Password',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                children: [
                  SizedBox(height: 12),
                  _PremiumTextField(
                    label: 'Current Password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(height: 16),
                  _PremiumTextField(
                    label: 'New Password',
                    icon: Icons.lock_reset,
                    obscureText: true,
                    validator: (value) => value!.length < 6 ? 'Min 6 characters' : null,
                  ),
                  SizedBox(height: 16),
                  _PremiumTextField(
                      label: 'Confirm New Password',
                      icon: Icons.lock_reset,
                      obscureText: true,
                      validator: (value) => value != _newPasswordController.text
                          ? 'Passwords didnt match' : null,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: (){

                    },
                    // onPressed: _changePassword,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('UPDATE PASSWORD'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?)? validator;

  const _PremiumTextField({
    this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }
}