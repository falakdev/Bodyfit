import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/step_provider.dart';
import '../../logic/theme_provider.dart';
import '../../logic/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../services/firebase_service.dart';
import '../auth/login_screen.dart';
import '../auth/setup_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late int newGoal;
  final FirebaseService _firebaseService = FirebaseService();
  String? userEmail;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final stepProvider = Provider.of<StepProvider>(context, listen: false);
    newGoal = stepProvider.dailyGoal;
    _loadUserEmail();
    _loadUserProfile();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload profile when screen becomes visible again
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserEmail();
      _loadUserProfile();
    });
  }
  
  Future<void> _loadUserEmail() async {
    final email = _firebaseService.getUserEmail();
    setState(() {
      userEmail = email;
    });
  }
  
  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);
    try {
      final stepProvider = Provider.of<StepProvider>(context, listen: false);
      await stepProvider.loadProfileFromFirebase();
    } catch (e) {
      debugPrint('Error loading profile: $e');
    } finally {
      setState(() => _isLoading = false);
    }
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadUserEmail();
              _loadUserProfile();
            },
            tooltip: 'Refresh profile',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Section
              _buildSectionTitle('Profile Information'),
              if (_isLoading)
                const Center(child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ))
              else if (stepProvider.userProfile != null) ...[
                _buildProfileCard(stepProvider),
                const SizedBox(height: 16),
                // Edit Profile Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SetupProfileScreen()),
                      );
                      // Reload profile after returning from edit
                      if (mounted) {
                        _loadUserProfile();
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ] else ...[
                _buildNoProfileCard(),
                const SizedBox(height: 16),
                // Create Profile Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SetupProfileScreen()),
                      );
                      // Reload profile after returning from edit
                      if (mounted) {
                        _loadUserProfile();
                      }
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('Create Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),

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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              themeProvider.isDarkMode
                                  ? 'Dark theme is active'
                                  : 'Light theme is active',
                              style: AppTextStyles.body.copyWith(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.setDarkMode(value);
                      },
                      activeThumbColor: AppColors.primary,
                      activeTrackColor: AppColors.primary.withOpacity(0.5),
                      inactiveThumbColor: AppColors.textSecondary,
                      inactiveTrackColor: AppColors.border,
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
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final messenger = ScaffoldMessenger.of(context);
                      try {
                        final authProvider = Provider.of<AuthProvider>(context, listen: false);
                        await authProvider.logout();
                        if (!mounted) return;
                        // Navigate to login screen
                        navigator.pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                        messenger.showSnackBar(
                          SnackBar(
                            content: const Text('Logged out successfully'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      } catch (e) {
                        if (!mounted) return;
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text('Error logging out: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5252),
                      foregroundColor: Colors.white,
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
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (userEmail != null) ...[
            _buildProfileRow('Email', userEmail!),
            Divider(color: AppColors.border),
          ],
          _buildProfileRow('Name', profile.name),
          Divider(color: AppColors.border),
          _buildProfileRow('Age', '${profile.age} years'),
          Divider(color: AppColors.border),
          _buildProfileRow('Weight', '${profile.weight} kg'),
          Divider(color: AppColors.border),
          _buildProfileRow('Height', '${profile.height} cm'),
          Divider(color: AppColors.border),
          _buildProfileRow('Gender', profile.gender),
          Divider(color: AppColors.border),
          _buildProfileRow('Fitness Level', profile.fitnessLevel.toUpperCase()),
          Divider(color: AppColors.border),
          _buildProfileRow('BMI', profile.bmi.toStringAsFixed(1)),
          Divider(color: AppColors.border),
          _buildProfileRow('Daily Step Goal', '${profile.dailyStepGoal} steps'),
        ],
      ),
    );
  }
  
  Widget _buildNoProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(Icons.person_outline, size: 48, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          Text(
            'No profile data found',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your profile to track your fitness journey',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          if (userEmail != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Email: $userEmail',
                style: AppTextStyles.body.copyWith(color: AppColors.primary),
              ),
            ),
          ],
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
