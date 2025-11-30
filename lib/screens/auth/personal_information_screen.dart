import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PersonalInformationScreen extends StatefulWidget {
  final String?  email;
  final String? password;

  const PersonalInformationScreen({
    super.key,
    this.email,
    this.password,
  });

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Debug: Check if data is received
    debugPrint('PersonalInfo received - Email: ${widget.email}, Password: ${widget.password != null ? "***" : "null"}');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _handleNext() {
    final name = _nameController.text.trim();
    final ageText = _ageController.text. trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name')),
      );
      return;
    }

    if (ageText.isEmpty) {
      ScaffoldMessenger. of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your age')),
      );
      return;
    }

    final age = int.tryParse(ageText);
    if (age == null || age < 1 || age > 120) {
      ScaffoldMessenger. of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid age')),
      );
      return;
    }

    // Debug: Log data being passed
    debugPrint('Passing to SelectGender - Email: ${widget.email}, Password: ${widget.password != null ? "***" : "null"}, Name: $name, Age: $age');

    // Navigate to gender selection with all data
    context.push(
      '/select-gender',
      extra: {
        'email': widget.email,
        'password': widget.password,
        'name': name,
        'age': age,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Enter information - your full name and your age',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Full Name Field
              const Text(
                'Full name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Enter your full name',
                  filled: true,
                  fillColor: Colors. grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius. circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Age Field
              const Text(
                'Age',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight. w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter your age',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide. none,
                  ),
                ),
              ),

              const Spacer(),

              // Next Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C5CFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}