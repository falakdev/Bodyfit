import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/step_provider.dart';
import '../../logic/theme_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late int newGoal;

  @override
  void initState() {
    super.initState();
    final stepProvider = Provider.of<StepProvider>(context, listen: false);
    newGoal = stepProvider.dailyGoal;
  }

  @override
  Widget build(BuildContext context) {
    final stepProvider = Provider.of<StepProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Settings", style: AppTextStyles.heading),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Section
              if (stepProvider.userProfile != null) ...[
                _buildSectionTitle('Profile Information'),
                _buildProfileCard(stepProvider),
                const SizedBox(height: 24),
              ],

              // Daily Goal Section
              _buildSectionTitle('Daily Goals'),
              const SizedBox(height: 12),
              Text('Daily Step Goal: $newGoal steps', style: AppTextStyles.subheading),
              const SizedBox(height: 12),
              Slider(
                value: newGoal.toDouble(),
                min: 1000,
                max: 20000,
                divisions: 19,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.border,
                onChanged: (value) {
                  setState(() => newGoal = value.toInt());
                },
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('1,000', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  Text('20,000', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 20),

              // Save Goal Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    stepProvider.updateDailyGoal(newGoal);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Daily goal updated!"),
                        backgroundColor: AppColors.primary,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text("Save Goal"),
                ),
              ),
              const SizedBox(height: 24),

              // Appearance Settings
              _buildSectionTitle('Appearance'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Dark Mode', style: AppTextStyles.body),
                    Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.setDarkMode(value);
                      },
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // About Section
              _buildSectionTitle('About'),
              const SizedBox(height: 12),
              _buildSettingsOption('App Version', '1.0.0', () {}),
              _buildSettingsOption('Privacy Policy', 'View', () {}),
              _buildSettingsOption('Terms of Service', 'View', () {}),
              const SizedBox(height: 24),

              // Logout Button
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle logout
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Logged out successfully')),
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5252),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTextStyles.subheading);
  }

  Widget _buildProfileCard(StepProvider provider) {
    final profile = provider.userProfile;
    if (profile == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          _buildProfileRow('Name', profile.name),
          _buildProfileRow('Age', '${profile.age} years'),
          _buildProfileRow('Weight', '${profile.weight} kg'),
          _buildProfileRow('Height', '${profile.height} cm'),
          _buildProfileRow('Gender', profile.gender),
          _buildProfileRow('Fitness Level', profile.fitnessLevel.toUpperCase()),
          _buildProfileRow('BMI', '${profile.bmi.toStringAsFixed(1)}'),
        ],
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body),
          Text(value, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(String title, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.body),
            Text(value, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
