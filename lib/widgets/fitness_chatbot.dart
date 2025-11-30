import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/theme/app_colors.dart';

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
  final List<Map<String, String>> _messages = [];
  late GenerativeModel _model;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: widget.geminiApiKey,
    );

    // Add initial greeting
    _messages.add({
      'role': 'bot',
      'text':
          'Hi! I\'m your Fitness Assistant. Ask me anything about workouts, nutrition, or fitness tips!'
    });
  }

  Future<void> _sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final response = await _model.generateContent([
        Content.text(
            'You are a professional fitness assistant and personal trainer. Answer this fitness-related question concisely and helpfully. Question: $text'),
      ]);

      if (response.text != null && response.text!.isNotEmpty) {
        setState(() {
          _messages.add({'role': 'bot', 'text': response.text!});
          _isLoading = false;
        });
      } else {
        setState(() {
          _messages.add(
              {'role': 'bot', 'text': 'No response received from the API.'});
          _isLoading = false;
        });
      }
      _scrollToBottom();
    } catch (e) {
      debugPrint('Chatbot Error: $e');
      setState(() {
        _messages.add({
          'role': 'bot',
          'text':
              'Error: ${e.toString()}. Please check your API key or try again later.'
        });
        _isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;

    return Positioned(
      bottom: 20,
      right: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isExpanded)
            SizedBox(
              width: isSmallScreen ? screenSize.width - 40 : 320,
              height: 450,
              child: Material(
                color: AppColors.isDarkMode
                    ? const Color(0xFF1E1E1E)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                elevation: 8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'Fitness Assistant',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: 32,
                              height: 32,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    setState(() => _isExpanded = false),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Messages area
                      Expanded(
                        child: _messages.isEmpty
                            ? Center(
                                child: Text(
                                  'No messages yet',
                                  style: TextStyle(
                                    color: AppColors.isDarkMode
                                        ? Colors.white30
                                        : Colors.grey,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.all(12),
                                itemCount: _messages.length,
                                itemBuilder: (context, index) {
                                  final msg = _messages[index];
                                  final isUser = msg['role'] == 'user';
                                  return Align(
                                    alignment: isUser
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      constraints:
                                          const BoxConstraints(maxWidth: 240),
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
                                        softWrap: true,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      // Loading indicator
                      if (_isLoading)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      // Input area
                      Container(
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
                                  hintText: 'Ask...',
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.withOpacity(0.6),
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
                                textCapitalization:
                                    TextCapitalization.sentences,
                                onSubmitted: _sendMessage,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                onPressed: _isLoading
                                    ? null
                                    : () => _sendMessage(_controller.text),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 12),
          // Main chat button
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: FloatingActionButton(
              mini: true,
              backgroundColor: AppColors.primary,
              elevation: 4,
              onPressed: () => setState(() => _isExpanded = !_isExpanded),
              child: Icon(
                _isExpanded ? Icons.close : Icons.chat_bubble_outline,
                size: 20,
              ),
            ),
          ),
        ],
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
