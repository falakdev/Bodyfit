import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';
import '../../core/theme/app_text_styles.dart';
import '../home/home_screen.dart';

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

  String selectedGender = "Male"; // Default option

  Future<void> saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("name", nameC.text.trim());
    await prefs.setString("gender", selectedGender);
    await prefs.setInt("age", int.parse(ageC.text.trim()));
    await prefs.setDouble("weight", double.parse(weightC.text.trim()));
    await prefs.setDouble("height", double.parse(heightC.text.trim()));
    await prefs.setInt("stepGoal", int.parse(stepGoalC.text.trim()));

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text("Create Profile", style: AppTextStyles.subheading),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _buildInputField("Name", nameC, TextInputType.name),
            _buildGenderSelector(),
            _buildInputField("Age", ageC, TextInputType.number),
            _buildInputField("Weight (kg)", weightC, TextInputType.number),
            _buildInputField("Height (cm)", heightC, TextInputType.number),
            _buildInputField("Daily Step Goal", stepGoalC, TextInputType.number),

            const SizedBox(height: 30),

            GestureDetector(
              onTap: saveProfile,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: AppGradients.mainGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Save & Continue",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
}
