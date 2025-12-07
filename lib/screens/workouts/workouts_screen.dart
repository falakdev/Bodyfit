import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/models/exercise.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'workout_detail_screen.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  String selectedCategory = 'All';
  String searchQuery = '';
  late final PageController _heroController;
  int _heroIndex = 0;

  final List<String> categories = [
    'All',
    'Cardio',
    'Strength',
    'Flexibility',
    'Sports',
    'HIIT',
    'Mobility',
  ];

  final List<Exercise> allExercises = [
    Exercise(
      id: 'e1',
      name: 'Sunrise Run',
      description: 'Rhythmic road run focused on cadence and breath work.',
      caloriesBurned: 420,
      difficulty: 'medium',
      category: 'cardio',
      durationMinutes: 35,
      instructions: '1. Warm up with leg swings\n2. Run tempo intervals\n3. Finish with walking lunges.',
      targetMuscles: ['Legs', 'Core', 'Cardio'],
      imageUrl:
          'https://images.unsplash.com/photo-1605296867724-fa87a8ef53fd?auto=format&fit=crop&w=1400&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1486218119243-13883505764c?auto=format&fit=crop&w=1400&q=80',
        'https://images.unsplash.com/photo-1549570652-97324981a6fd?auto=format&fit=crop&w=1400&q=80',
        'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?auto=format&fit=crop&w=1400&q=80',
      ],
    ),
    Exercise(
      id: 'e2',
      name: 'Engine Room',
      description: 'Slow-controlled push-ups blended with plank switches.',
      caloriesBurned: 250,
      difficulty: 'medium',
      category: 'strength',
      durationMinutes: 18,
      instructions: '1. 12 tempo push-ups\n2. 30s plank hold\n3. Pike push-up finisher.',
      targetMuscles: ['Chest', 'Shoulders', 'Triceps'],
      imageUrl:
          'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=1400&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1508672019048-805c876b67e2?auto=format&fit=crop&w=1400&q=80',
        'https://images.unsplash.com/photo-1579758629936-035e76ab6693?auto=format&fit=crop&w=1400&q=80',
        'https://images.unsplash.com/photo-1526506118085-60ce8714f8c5?auto=format&fit=crop&w=1400&q=80',
      ],
    ),
    Exercise(
      id: 'e3',
      name: 'Lunar Flow',
      description: 'Intentional yoga stringing hip-openers with breath cues.',
      caloriesBurned: 180,
      difficulty: 'easy',
      category: 'flexibility',
      durationMinutes: 45,
      instructions: '1. Grounding breath\n2. Sun salutations\n3. Deep hip series\n4. Guided savasana.',
      targetMuscles: ['Full Body', 'Mind'],
      imageUrl:
          'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=1400&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=1400&q=80',
        'https://images.unsplash.com/photo-1549576490-b0b4831ef60a?auto=format&fit=crop&w=1400&q=80',
        'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=1400&q=80',
      ],
    ),
    Exercise(
      id: 'e4',
      name: 'Aqua Power',
      description: 'Pool-based power sets alternating strokes and kick drills.',
      caloriesBurned: 520,
      difficulty: 'hard',
      category: 'cardio',
      durationMinutes: 40,
      instructions: '1. 200m warm-up\n2. 6x50m sprint laps\n3. Kickboard finisher.',
      targetMuscles: ['Back', 'Shoulders', 'Core'],
      imageUrl:
          'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?auto=format&fit=crop&w=1400&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1504973960431-1c467e159aa5?auto=format&fit=crop&w=1400&q=80',
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1400&q=80',
        'https://images.unsplash.com/photo-1506129984056-1a0ad36b147d?auto=format&fit=crop&w=1400&q=80',
      ],
    ),
    Exercise(
      id: 'e5',
      name: 'Velocity Squads',
      description: 'Tempo squats with isometric holds for max posterior chain.',
      caloriesBurned: 310,
      difficulty: 'medium',
      category: 'strength',
      durationMinutes: 22,
      instructions: '1. 4x10 tempo squats\n2. 60s wall sit\n3. Jump squat burst.',
      targetMuscles: ['Quads', 'Glutes', 'Hamstrings'],
      imageUrl:
          'https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?auto=format&fit=crop&w=1400&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1452626038306-9aae5e071dd3?auto=format&fit=crop&w=1400&q=80',
        'https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?auto=format&fit=crop&w=1400&q=80',
        'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?auto=format&fit=crop&w=1400&q=80',
      ],
    ),
    Exercise(
      id: 'e6',
      name: 'Court Charge',
      description: 'High-tempo basketball drills with skill ladders.',
      caloriesBurned: 560,
      difficulty: 'hard',
      category: 'sports',
      durationMinutes: 55,
      instructions: '1. Dynamic warm-up\n2. Ball-handling ladder\n3. Full-court finisher.',
      targetMuscles: ['Full Body', 'Cardio'],
      imageUrl:
          'https://images.unsplash.com/photo-1481956874874-7acbfc47b4ae?auto=format&fit=crop&w=1400&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1521412644187-c49fa049e84d?auto=format&fit=crop&w=1400&q=80',
        'https://images.unsplash.com/photo-1509223197845-458d87318791?auto=format&fit=crop&w=1400&q=80',
        'https://images.unsplash.com/photo-1517649763962-0c623066013b?auto=format&fit=crop&w=1400&q=80',
      ],
    ),
    Exercise(
      id: 'e7',
      name: 'HIIT Ignite',
      description: 'Explosive EMOM sets pairing burpees with kettlebell swings.',
      caloriesBurned: 480,
      difficulty: 'hard',
      category: 'hiit',
      durationMinutes: 25,
      instructions: '1. 40s burpees\n2. 20s rest\n3. KB swings + mountain climbers repeat.',
      targetMuscles: ['Cardio', 'Core', 'Shoulders'],
      imageUrl:
          'https://images.unsplash.com/photo-1483721310020-03333e577078?auto=format&fit=crop&w=1400&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=1400&q=80',
        'https://images.unsplash.com/photo-1579758629936-035e76ab6693?auto=format&fit=crop&w=1400&q=80',
        'https://images.unsplash.com/photo-1556817411-31ae72fa3ea0?auto=format&fit=crop&w=1400&q=80',
      ],
    ),
    Exercise(
      id: 'e8',
      name: 'Mobility Reset',
      description: 'Band-assisted stretches plus nerve-glide resets.',
      caloriesBurned: 140,
      difficulty: 'easy',
      category: 'mobility',
      durationMinutes: 28,
      instructions: '1. Thoracic opener\n2. 90/90 rotations\n3. Banded ankle work.',
      targetMuscles: ['Hips', 'Spine', 'Ankles'],
      imageUrl:
          'https://images.unsplash.com/photo-1575052814086-f385e2e2ad1c?auto=format&fit=crop&w=1400&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=1400&q=80',
        'https://images.unsplash.com/photo-1517502474097-f9b30659dadb?auto=format&fit=crop&w=1400&q=80',
        'https://images.unsplash.com/photo-1452626038306-9aae5e071dd3?auto=format&fit=crop&w=1400&q=80',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _heroController = PageController(viewportFraction: 0.82);
    _heroController.addListener(_handleHeroScroll);
  }

  void _handleHeroScroll() {
    final nextIndex = _heroController.page?.round() ?? 0;
    if (nextIndex != _heroIndex) {
      setState(() {
        _heroIndex = nextIndex;
      });
    }
  }

  @override
  void dispose() {
    _heroController
      ..removeListener(_handleHeroScroll)
      ..dispose();
    super.dispose();
  }

  List<Exercise> get filteredExercises {
    Iterable<Exercise> exercises = selectedCategory == 'All'
        ? allExercises
        : allExercises.where(
            (e) => e.category.toLowerCase() == selectedCategory.toLowerCase(),
          );

    if (searchQuery.isNotEmpty) {
      exercises = exercises.where(
        (e) =>
            e.name.toLowerCase().contains(searchQuery) ||
            e.description.toLowerCase().contains(searchQuery),
      );
    }

    return exercises.toList()
      ..sort(
        (a, b) => b.caloriesBurned.compareTo(a.caloriesBurned),
      );
  }

  @override
  Widget build(BuildContext context) {
    final exercises = filteredExercises;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              AppColors.background.withOpacity(0.7),
              const Color(0xFF050505),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopBar(),
                      const SizedBox(height: 20),
                      _buildHeroCarousel(),
                      const SizedBox(height: 24),
                      Text(
                        'Elite studio programming',
                        style: AppTextStyles.subheading.copyWith(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildCategoryFilter(),
                      const SizedBox(height: 16),
                      _buildSearchField(),
                      const SizedBox(height: 8),
                      Text(
                        '${exercises.length} curated sessions',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              exercises.isEmpty
                  ? SliverToBoxAdapter(child: _buildEmptyState())
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: _buildExerciseCard(context, exercises[index]),
                              ),
                          childCount: exercises.length,
                        ),
                      ),
                    ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Workouts',
              style: AppTextStyles.heading.copyWith(fontSize: 32),
            ),
            Text(
              'Designed by elite performance coaches',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Icon(Icons.auto_graph, color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildHeroCarousel() {
    final heroExercises = allExercises.take(5).toList();
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _heroController,
            itemCount: heroExercises.length,
            itemBuilder: (context, index) {
              final exercise = heroExercises[index];
              final isFocused = index == _heroIndex;
              return AnimatedPadding(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: isFocused ? 0 : 16),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => WorkoutDetailScreen(exercise: exercise)),
                  ),
                  child: Stack(
                    children: [
                      Hero(
                        tag: exercise.id,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: CachedNetworkImage(
                            imageUrl: exercise.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, url) => Container(
                              color: AppColors.primary.withOpacity(0.15),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppColors.primary.withOpacity(0.2),
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
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exercise.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              exercise.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _buildHeroChip(Icons.local_fire_department, '${exercise.caloriesBurned} kcal'),
                                const SizedBox(width: 8),
                                _buildHeroChip(Icons.access_time, '${exercise.durationMinutes} min'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            heroExercises.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 4,
              width: index == _heroIndex ? 32 : 14,
              decoration: BoxDecoration(
                color: index == _heroIndex ? AppColors.primary : Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => setState(() => selectedCategory = category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.accent,
                          ],
                        )
                      : null,
                  border: Border.all(
                    color: isSelected ? Colors.transparent : Colors.white12,
                  ),
                  color: isSelected ? null : const Color(0xFF111111),
                ),
                child: Row(
                  children: [
                    Icon(Icons.bolt, size: 14, color: isSelected ? Colors.black : Colors.white54),
                    const SizedBox(width: 6),
                    Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: TextField(
        onChanged: (value) => setState(() => searchQuery = value.toLowerCase()),
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.white54),
          hintText: 'Search sculpting, cardio, mobility...',
          hintStyle: TextStyle(color: Colors.white38),
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 54, color: Colors.white24),
          const SizedBox(height: 12),
          Text(
            'No sessions found',
            style: AppTextStyles.subheading,
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different focus area or reset the filters.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, Exercise exercise) {
    final List<Color> difficultyPalette = {
      'easy': [const Color(0xFF4CAF50), const Color(0xFF66BB6A)],
      'medium': [const Color(0xFFFFC107), const Color(0xFFFFD54F)],
      'hard': [const Color(0xFFFF5252), const Color(0xFFFF8A65)],
    }[exercise.difficulty.toLowerCase()] ??
        [AppColors.primary, AppColors.accent];

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => WorkoutDetailScreen(exercise: exercise)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: const Color(0xFF0F0F0F),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      bottomLeft: Radius.circular(28),
                    ),
                    child: Hero(
                      tag: exercise.id,
                      child: CachedNetworkImage(
                        imageUrl: exercise.imageUrl,
                        height: 190,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.primary.withOpacity(0.15),
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.primary.withOpacity(0.2),
                          child: const Icon(
                            Icons.fitness_center,
                            size: 40,
                            color: Colors.white54,
                          ),
                        ),
                        httpHeaders: const {
                          'User-Agent': 'Mozilla/5.0',
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: difficultyPalette),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            exercise.difficulty.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          exercise.name,
                          style: AppTextStyles.subheading.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          exercise.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white60, height: 1.4),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _statTile(Icons.local_fire_department, '${exercise.caloriesBurned} kcal')),
                            const SizedBox(width: 8),
                            Expanded(child: _statTile(Icons.access_time, '${exercise.durationMinutes} min')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    spacing: 6,
                    children: exercise.targetMuscles.take(3).map((muscle) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Text(
                          muscle,
                          style: const TextStyle(color: Colors.white54, fontSize: 11),
                        ),
                      );
                    }).toList(),
                  ),
                  Icon(Icons.arrow_outward, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statTile(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 16),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
