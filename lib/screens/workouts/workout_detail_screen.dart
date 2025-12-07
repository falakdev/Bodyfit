import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/models/exercise.dart';
import '../../widgets/session_timer.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final dynamic workout; // Legacy Workout object
  final Exercise? exercise;

  const WorkoutDetailScreen({super.key, this.workout, this.exercise});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  bool isWorkoutStarted = false;
  int _activeImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;
    if (exercise == null) {
      return const Scaffold(body: Center(child: Text('No exercise selected')));
    }

    final gallery = exercise.galleryImages.isNotEmpty
        ? exercise.galleryImages
        : [exercise.imageUrl];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Subtle blurred background from hero image
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: exercise.imageUrl,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.75),
              colorBlendMode: BlendMode.darken,
              placeholder: (context, url) => Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.black.withOpacity(0.7),
                child: const Icon(
                  Icons.fitness_center,
                  size: 60,
                  color: Colors.white24,
                ),
              ),
              httpHeaders: const {
                'User-Agent': 'Mozilla/5.0',
              },
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(color: Colors.black.withOpacity(0.65)),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  pinned: true,
                  expandedHeight: 320,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.bookmark_border_rounded),
                      onPressed: () {},
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: _buildHeroGallery(exercise, gallery),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.name,
                          style: AppTextStyles.heading.copyWith(fontSize: 30),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _pillChip(Icons.local_fire_department, '${exercise.caloriesBurned} kcal'),
                            const SizedBox(width: 8),
                            _pillChip(Icons.access_time, '${exercise.durationMinutes} min'),
                            const SizedBox(width: 8),
                            _pillChip(Icons.category, exercise.category.toUpperCase()),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          exercise.description,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildInfoRow(exercise),
                        const SizedBox(height: 28),
                        Text('Target Muscles', style: AppTextStyles.subheading),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: exercise.targetMuscles.map((muscle) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.white12),
                                color: Colors.white.withOpacity(0.03),
                              ),
                              child: Text(
                                muscle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 28),
                        Text('How to Perform', style: AppTextStyles.subheading),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.02),
                                AppColors.primary.withOpacity(0.10),
                              ],
                            ),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Text(
                            exercise.instructions,
                            style: const TextStyle(
                              color: Colors.white70,
                              height: 1.7,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (isWorkoutStarted) ...[
                          Text('Session Timer', style: AppTextStyles.subheading),
                          const SizedBox(height: 12),
                          Center(
                            child: SessionTimer(minutes: exercise.durationMinutes),
                          ),
                          const SizedBox(height: 24),
                        ],
                        _buildActions(context),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroGallery(Exercise exercise, List<String> gallery) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            onPageChanged: (index) => setState(() => _activeImageIndex = index),
            itemCount: gallery.length,
            itemBuilder: (context, index) {
              final url = gallery[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Hero(
                  tag: exercise.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, _) => Container(
                          color: AppColors.primary.withOpacity(0.2),
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.primary.withOpacity(0.3),
                          child: const Icon(
                            Icons.fitness_center,
                            size: 60,
                            color: Colors.white54,
                          ),
                        ),
                        httpHeaders: const {
                          'User-Agent': 'Mozilla/5.0',
                        },
                      ),
                    ),
                ),
              );
            },
          ),
        ),
        if (gallery.length > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                gallery.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: index == _activeImageIndex ? 26 : 10,
                  height: 4,
                  decoration: BoxDecoration(
                    color: index == _activeImageIndex ? AppColors.primary : Colors.white30,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        if (gallery.length > 1)
          SizedBox(
            height: 70,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              scrollDirection: Axis.horizontal,
              itemCount: gallery.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final url = gallery[index];
                final isActive = index == _activeImageIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() => _activeImageIndex = index);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isActive ? AppColors.primary : Colors.white24,
                        width: isActive ? 1.8 : 1.0,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.primary.withOpacity(0.2),
                          child: const Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.primary.withOpacity(0.2),
                          child: const Icon(
                            Icons.image,
                            size: 24,
                            color: Colors.white54,
                          ),
                        ),
                        httpHeaders: const {
                          'User-Agent': 'Mozilla/5.0',
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _pillChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.06),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(Exercise exercise) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            Icons.favorite_border_rounded,
            '${exercise.caloriesBurned}',
            'Calories',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            Icons.show_chart_rounded,
            exercise.difficulty.toUpperCase(),
            'Intensity',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            Icons.directions_run_rounded,
            '${exercise.durationMinutes}',
            'Minutes',
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() => isWorkoutStarted = true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Workout started! Keep it up!'),
                  backgroundColor: AppColors.primary,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Start Guided Session'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.bookmark_add_outlined),
            label: const Text('Save to My Programs'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              foregroundColor: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.15),
            AppColors.accent.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.4),
          width: 1.3,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 26),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
