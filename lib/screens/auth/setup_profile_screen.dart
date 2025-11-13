import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/models/user_profile.dart';
import '../../logic/step_provider.dart';
import '../../services/firebase_service.dart';
import '../main_navigation.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  final TextEditingController nameC = TextEditingController();
  final TextEditingController ageC = TextEditingController();
  final TextEditingController weightC = TextEditingController();
  final TextEditingController heightC = TextEditingController();
  final TextEditingController stepGoalC = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  String selectedGender = "Male"; // Default option
  String selectedFitnessLevel = "beginner"; // Default option
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  Future<void> _loadExistingProfile() async {
    final stepProvider = Provider.of<StepProvider>(context, listen: false);
    if (stepProvider.userProfile != null) {
      final profile = stepProvider.userProfile!;
      setState(() {
        nameC.text = profile.name;
        ageC.text = profile.age.toString();
        weightC.text = profile.weight.toString();
        heightC.text = profile.height.toString();
        stepGoalC.text = profile.dailyStepGoal.toString();
        selectedGender = profile.gender;
        selectedFitnessLevel = profile.fitnessLevel;
        _isInitialized = true;
      });
    } else {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  Future<void> saveProfile() async {
    // Validate inputs
    if (nameC.text.trim().isEmpty ||
        ageC.text.trim().isEmpty ||
        weightC.text.trim().isEmpty ||
        heightC.text.trim().isEmpty ||
        stepGoalC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final profile = UserProfile(
        name: nameC.text.trim(),
        age: int.parse(ageC.text.trim()),
        weight: double.parse(weightC.text.trim()),
        height: double.parse(heightC.text.trim()),
        gender: selectedGender,
        fitnessLevel: selectedFitnessLevel,
        dailyStepGoal: int.parse(stepGoalC.text.trim()),
      );

      // Save to Firebase
      await _firebaseService.saveUserProfile(profile);

      // Also save to local provider for immediate use
      if (!mounted) return;
      final stepProvider = Provider.of<StepProvider>(context, listen: false);
      await stepProvider.saveUserProfile(profile);
      stepProvider.updateDailyGoal(profile.dailyStepGoal);

      // Save to SharedPreferences for backward compatibility
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("name", nameC.text.trim());
      await prefs.setString("gender", selectedGender);
      await prefs.setInt("age", int.parse(ageC.text.trim()));
      await prefs.setDouble("weight", double.parse(weightC.text.trim()));
      await prefs.setDouble("height", double.parse(heightC.text.trim()));
      await prefs.setInt("stepGoal", int.parse(stepGoalC.text.trim()));

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile saved successfully!'),
          backgroundColor: AppColors.primary,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving profile: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          _isInitialized && Provider.of<StepProvider>(context, listen: false).userProfile != null
              ? "Edit Profile"
              : "Create Profile",
          style: AppTextStyles.subheading,
        ),
        centerTitle: true,
      ),
      body: _isInitialized
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  _buildInputField("Name", nameC, TextInputType.name),
                  _buildGenderSelector(),
                  _buildFitnessLevelSelector(),
                  _buildInputField("Age", ageC, TextInputType.number),
                  _buildInputField("Weight (kg)", weightC, TextInputType.number),
                  _buildInputField("Height (cm)", heightC, TextInputType.number),
                  _buildInputField("Daily Step Goal", stepGoalC, TextInputType.number),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: _isLoading ? null : saveProfile,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: _isLoading ? null : AppGradients.mainGradient,
                        color: _isLoading ? AppColors.primary.withOpacity(0.6) : null,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: _isLoading ? null : [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 1,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.textPrimary),
                                ),
                              )
                            : Builder(
                                builder: (context) {
                                  final stepProvider = Provider.of<StepProvider>(context, listen: false);
                                  return Text(
                                    stepProvider.userProfile != null
                                        ? "Update Profile"
                                        : "Save & Continue",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        keyboardType: type,
        style: AppTextStyles.body,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.body,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary.withOpacity(0.4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _genderOption("Male"),
          _genderOption("Female"),
          _genderOption("Other"),
        ],
      ),
    );
  }

  Widget _genderOption(String value) {
    return GestureDetector(
      onTap: () => setState(() => selectedGender = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        decoration: BoxDecoration(
          gradient: selectedGender == value ? AppGradients.mainGradient : null,
          color: selectedGender == value ? null : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.5)),
        ),
        child: Text(
          value,
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: selectedGender == value ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildFitnessLevelSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Fitness Level",
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _fitnessOption("Beginner"),
              _fitnessOption("Intermediate"),
              _fitnessOption("Advanced"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fitnessOption(String value) {
    final level = value.toLowerCase();
    final isSelected = selectedFitnessLevel == level;
    return GestureDetector(
      onTap: () => setState(() => selectedFitnessLevel = level),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? AppGradients.mainGradient : null,
          color: isSelected ? null : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.5)),
        ),
        child: Text(
          value,
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
