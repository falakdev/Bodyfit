import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Fitness Card Sticker Widget - Similar to "Cardio" card from images
class FitnessCardSticker extends StatelessWidget {
  final String category;
  final String title;
  final String description;
  final String imageUrl;
  final VoidCallback? onTap;
  final int? participantCount;

  const FitnessCardSticker({
    super.key,
    required this.category,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.onTap,
    this.participantCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8D5FF), // Light lavender
              Color(0xFF9B59B6), // Deep purple
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.purple.withOpacity(0.2),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.purple.withOpacity(0.4),
                          Colors.purple.withOpacity(0.6),
                        ],
                      ),
                    ),
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
            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.purple.withOpacity(0.7),
                      Colors.purple.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      color: Color(0xFF87CEEB),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (participantCount != null)
                        Row(
                          children: [
                            _buildAvatar('https://i.pravatar.cc/150?img=12'),
                            const SizedBox(width: 8),
                            _buildAvatar('https://i.pravatar.cc/150?img=33'),
                            const SizedBox(width: 8),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.purple.shade700,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '+$participantCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Start',
                          style: TextStyle(
                            color: Color(0xFF9B59B6),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String url) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey.shade300,
            child: const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey.shade300,
            child: const Icon(Icons.person, size: 20, color: Colors.grey),
          ),
          httpHeaders: const {
            'User-Agent': 'Mozilla/5.0',
          },
        ),
      ),
    );
  }
}

/// Health Article Card Sticker - Similar to "How to Be a Better Runner"
class HealthArticleCardSticker extends StatelessWidget {
  final String category;
  final String title;
  final int articleCount;
  final String imageUrl;
  final VoidCallback? onTap;

  const HealthArticleCardSticker({
    super.key,
    required this.category,
    required this.title,
    required this.articleCount,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFFFE5E5), // Peachy pink background
        ),
        child: Stack(
          children: [
            // Background image on right
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 150,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.pink.withOpacity(0.2),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.pink,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.pink.withOpacity(0.3),
                          Colors.pink.withOpacity(0.5),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.run_circle,
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
            // Content on left
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      '$articleCount articles',
                      style: const TextStyle(
                        color: Color(0xFF9B59B6),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Average Steps Card Sticker - Purple themed with stats
class AverageStepsCardSticker extends StatelessWidget {
  final int averageSteps;
  final double calories;
  final int minutes;
  final String? imageUrl;

  const AverageStepsCardSticker({
    super.key,
    required this.averageSteps,
    required this.calories,
    required this.minutes,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF9B59B6), // Purple
            Color(0xFF8E44AD), // Darker purple
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background image if provided
          if (imageUrl != null)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  color: Colors.purple.withOpacity(0.3),
                  colorBlendMode: BlendMode.overlay,
                  placeholder: (context, url) => Container(
                    color: Colors.purple.withOpacity(0.2),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.purple.withOpacity(0.4),
                          Colors.purple.withOpacity(0.6),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.directions_walk,
                      size: 60,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
            ),
          // Content overlay
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.directions_walk,
                      color: Colors.white,
                      size: 28,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'AVERAGE STEPS',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatNumber(averageSteps),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem(
                      icon: Icons.local_fire_department,
                      value: '${calories.toInt()}',
                      unit: 'kcal',
                    ),
                    _buildStatItem(
                      icon: Icons.access_time,
                      value: '$minutes',
                      unit: 'mins',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String unit,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          unit,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }
}

