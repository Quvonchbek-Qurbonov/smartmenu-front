import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/profile/confirmation_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // Selected gender (0 = male, 1 = female)
  int _selectedGender = 0;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  // Load user data from database/storage
  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      // TODO: Replace with your actual database call
      // Example: final userData = await DatabaseService.getUserProfile();

      // For now, using dummy data
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _nameController.text = 'John Anderson';
        _ageController.text = '23';
        _selectedGender = 0; // 0 = male, 1 = female
      });
    } catch (e) {
      _showError('Failed to load profile data');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Show confirmation dialog before saving
  Future<void> _saveChanges() async {
    // Validate inputs
    if (_nameController.text.trim().isEmpty) {
      _showError('Please enter your name');
      return;
    }

    if (_ageController.text.trim().isEmpty) {
      _showError('Please enter your age');
      return;
    }

    final age = int.tryParse(_ageController.text);
    if (age == null || age < 1 || age > 120) {
      _showError('Please enter a valid age');
      return;
    }

    // Show confirmation dialog (using reusable widget)
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Save changes?',
      message: 'Your profile information will be changed',
      confirmText: 'Save',
      cancelText: 'Cancel',
      icon: Icons.check,
      iconColor: const Color(0xFF4CAF50),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Replace with your actual database save call
      // Example:
      // await DatabaseService.updateUserProfile(
      //   name: _nameController.text.trim(),
      //   age: age,
      //   gender: _selectedGender == 0 ? 'male' : 'female',
      // );

      await Future.delayed(const Duration(seconds: 1)); // Simulating API call

      if (mounted) {
        _showSuccess('Profile updated successfully!');
        // Go back to profile screen after 1 second
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) context.pop();
      }
    } catch (e) {
      _showError('Failed to save changes: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Show confirmation dialog
  Future<bool?> _showSaveConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Check icon
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              // Title
              const Text(
                'Save changes?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              // Description
              Text(
                'Your profile information will be changed',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Buttons
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Save button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C4DFF),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
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
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Avatar Selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAvatarOption(
                        index: 0,
                        icon: Icons.person,
                        label: 'Male',
                        color: const Color(0xFF7C4DFF),
                      ),
                      const SizedBox(width: 40),
                      _buildAvatarOption(
                        index: 1,
                        icon: Icons.person,
                        label: 'Female',
                        color: const Color(0xFFE91E63),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Full Name Field
                  const Text(
                    'Full name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _nameController,
                    hintText: 'Enter your name',
                  ),

                  const SizedBox(height: 24),

                  // Age Field
                  const Text(
                    'Age',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _ageController,
                    hintText: 'Enter your age',
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C4DFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Save changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarOption({
    required int index,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final isSelected = _selectedGender == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedGender = index),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? color.withOpacity(0.15) : Colors.grey[200],
              border: Border.all(
                color: isSelected ? color : Colors.transparent,
                width: 3,
              ),
            ),
            child: Icon(
              icon,
              size: 40,
              color: isSelected ? color : Colors.grey[400],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? color : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon: Icon(
            Icons.edit_outlined,
            color: Colors.grey[600],
            size: 20,
          ),
        ),
      ),
    );
  }
}
