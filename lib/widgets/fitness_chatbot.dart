import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/theme/app_colors.dart';
import 'draggable_fab.dart';

class FitnessChatbot extends StatefulWidget {
  final String geminiApiKey;

  const FitnessChatbot({
    super.key,
    required this.geminiApiKey,
  });

  @override
  State<FitnessChatbot> createState() => _FitnessChatbotState();
}

class _FitnessChatbotState extends State<FitnessChatbot> {
  bool _isExpanded = false;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  late GenerativeModel _model;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: widget.geminiApiKey,
    );

    _messages.add({
      'role': 'bot',
      'text':
          'Hi! I\'m your Fitness Assistant. Ask me anything about workouts, nutrition, or fitness tips!',
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text.trim()});
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final response = await _model.generateContent([
        Content.text(
          'You are a professional fitness assistant and personal trainer. '
          'Answer this fitness-related question concisely and clearly. '
          'Question: $text',
        ),
      ]);

      final reply = response.text ?? 'No response received from the API.';
      setState(() {
        _messages.add({'role': 'bot', 'text': reply});
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      debugPrint('Chatbot Error: $e');
      setState(() {
        _messages.add({
          'role': 'bot',
          'text':
              'Error: ${e.toString()}. Please check your API key or try again later.',
        });
        _isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 420;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (_isExpanded) _buildChatSheet(isSmall, size),
        // FAB is rendered last so it's always on top and can receive gestures
        _buildFab(),
      ],
    );
  }

  Widget _buildChatSheet(bool isSmall, Size size) {
    return Positioned(
      bottom: 80,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: isSmall ? size.width - 40 : 360,
          height: 480,
          child: Material(
            color: AppColors.isDarkMode
                ? const Color(0xFF1E1E1E)
                : Colors.white,
            borderRadius: BorderRadius.circular(24),
            elevation: 18,
            shadowColor: AppColors.primary.withOpacity(0.3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(child: _buildMessages()),
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  _buildInput(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Fitness Assistant',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => setState(() => _isExpanded = false),
            icon: const Icon(Icons.close, size: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    if (_messages.isEmpty) {
      return Center(
        child: Text(
          'No messages yet',
          style: TextStyle(
            color: AppColors.isDarkMode ? Colors.white30 : Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        final isUser = msg['role'] == 'user';
        return Align(
          alignment:
              isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(10),
            constraints: const BoxConstraints(maxWidth: 260),
            decoration: BoxDecoration(
              color: isUser
                  ? AppColors.primary
                  : (AppColors.isDarkMode
                      ? const Color(0xFF2A2A2A)
                      : const Color(0xFFE8E8E8)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              msg['text'] ?? '',
              style: TextStyle(
                color: isUser
                    ? Colors.white
                    : (AppColors.isDarkMode
                        ? Colors.white70
                        : Colors.black87),
                fontSize: 13,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: !_isLoading,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Ask a fitness question...',
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.withOpacity(0.7),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                isDense: true,
              ),
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 36,
            height: 36,
            child: FloatingActionButton(
              heroTag: 'fitness_chatbot_send',
              elevation: 0,
              backgroundColor: AppColors.primary,
              onPressed: _isLoading
                  ? null
                  : () => _sendMessage(_controller.text),
              child: const Icon(Icons.send, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFab() {
    final screenSize = MediaQuery.of(context).size;
    final bottomNavHeight = 68.0; // Bottom navigation bar height
    
    // Position on the right side, above the bottom nav bar to avoid overlap
    // Position it higher than the camera button and away from bottom nav/profile
    final initialX = screenSize.width - 110; // More padding from profile icon
    final initialY =
        screenSize.height - bottomNavHeight - 220; // Higher to avoid overlap
    
    // Ensure FAB is always draggable by wrapping in a widget that preserves gestures
    return DraggableFAB(
      heroTag: 'fitness_chatbot',
      backgroundColor: AppColors.primary,
      initialPosition: Offset(initialX, initialY),
      onPressed: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Icon(
        _isExpanded ? Icons.close : Icons.chat_bubble_outline,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
