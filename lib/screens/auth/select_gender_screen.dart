import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/services/auth_service.dart';

class SelectGenderScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const SelectGenderScreen({super.key, this.userData});

  @override
  State<SelectGenderScreen> createState() => _SelectGenderScreenState();
}

class _SelectGenderScreenState extends State<SelectGenderScreen> {
  String? selectedGender;
  bool _isLoading = false;

  @override
  void initState() {
    super. initState();
    // Debug: Check received data
    debugPrint('SelectGender received data: ${widget. userData}');
  }

  Future<void> _handleConfirm() async {
    if (selectedGender == null) {
      ScaffoldMessenger. of(context).showSnackBar(
        const SnackBar(content: Text('Please select your gender')),
      );
      return;
    }

    // Get data from userData
    final email = widget.userData?['email']?.toString() ?? '';
    final password = widget.userData?['password']?.toString() ?? '';
    final name = widget.userData?['name']?. toString() ?? '';
    final ageValue = widget.userData?['age'];

    int age = 0;
    if (ageValue is int) {
      age = ageValue;
    } else if (ageValue is String) {
      age = int.tryParse(ageValue) ??  0;
    }

    // Debug: Log all data
    debugPrint('Registration data:');
    debugPrint('  Email: $email');
    debugPrint('  Password: ${password. isNotEmpty ? "***${password.length} chars" : "EMPTY"}');
    debugPrint('  Name: $name');
    debugPrint('  Age: $age');
    debugPrint('  Gender: $selectedGender');

    // Validate all required fields
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email is missing.  Please start over.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context). showSnackBar(
        const SnackBar(
          content: Text('Password is missing. Please start over.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name is missing. Please go back and enter your name.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (age <= 0) {
      ScaffoldMessenger.of(context). showSnackBar(
        const SnackBar(
          content: Text('Age is missing or invalid. Please go back and enter your age.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthService.register(
        email: email,
        password: password,
        fullName: name,
        gender: selectedGender! ,
        age: age,
      );

      if (result['success']) {
        final userId = result['user_id'] ??  result['data']?['id'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );

        if (mounted) {
          context.push(
            '/otp',
            extra: {
              'user_id': userId,
              'email': email,
            },
          );
        }
      } else {
        ScaffoldMessenger.of(context). showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Registration error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors. red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors. white,
      appBar: AppBar(
        backgroundColor: Colors. white,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Select Gender',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Select your gender, we will not share your data to third party apps',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 60),

              // Gender Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGenderOption('male', 'Male', Icons.man),
                  const SizedBox(width: 60),
                  _buildGenderOption('female', 'Female', Icons.woman),
                ],
              ),

              const Spacer(),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (selectedGender != null && ! _isLoading)
                      ? _handleConfirm
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C5CFF),
                    disabledBackgroundColor: Colors. grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'Confirm',
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

  Widget _buildGenderOption(String value, String label, IconData icon) {
    final isSelected = selectedGender == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = value;
        });
      },
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ?  const Color(0xFFF5F3FF) : Colors.grey[100],
              border: Border.all(
                color: isSelected ? const Color(0xFF7C5CFF) : Colors.grey[300]!,
                width: 3,
              ),
            ),
            child: Icon(
              icon,
              size: 50,
              color: isSelected ? const Color(0xFF7C5CFF) : Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isSelected ?  const Color(0xFF7C5CFF) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}