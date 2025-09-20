import 'package:flutter/material.dart';
import 'package:flutter_application_bloc/src/core/config/app_colors.dart';

import '../../../../../common/text_widget.dart';

class QuizHeader extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final int timeRemaining;
  final String lessonName;
  final Function() onExitQuiz;

  const QuizHeader({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.timeRemaining,
    required this.lessonName,
    required this.onExitQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.grey100, width: 1)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            children: [
              // Exit button
              IconButton(
                onPressed: () => _showExitDialog(context),
                icon: const Icon(Icons.close),
                style: IconButton.styleFrom(backgroundColor: Colors.grey[100]),
              ),

              const SizedBox(width: 16),

              // Lesson info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: lessonName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                      maxLine: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    TextWidget(
                      text: 'السؤال ${currentQuestion + 1} من $totalQuestions',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Timer
              _buildTimer(),
            ],
          ),

          const SizedBox(height: 16),

          // Progress Bar
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildTimer() {
    final minutes = timeRemaining ~/ 60;
    final seconds = timeRemaining % 60;
    final timeString =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    final isLowTime = timeRemaining <= 300; // 5 minutes
    final isCriticalTime = timeRemaining <= 60; // 1 minute

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color:
            isCriticalTime
                ? AppColors.errorColor.withOpacity(0.1)
                : isLowTime
                ? Colors.orange.withOpacity(0.1)
                : AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              isCriticalTime
                  ? AppColors.errorColor
                  : isLowTime
                  ? Colors.orange
                  : AppColors.primaryColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            size: 16,
            color:
                isCriticalTime
                    ? AppColors.errorColor
                    : isLowTime
                    ? Colors.orange
                    : AppColors.primaryColor,
          ),
          const SizedBox(width: 6),
          Text(
            timeString,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color:
                  isCriticalTime
                      ? AppColors.errorColor
                      : isLowTime
                      ? Colors.orange
                      : AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress =
        totalQuestions > 0 ? (currentQuestion + 1) / totalQuestions : 0.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'التقدم',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${((progress * 100).round())}%',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Question dots indicator
        _buildQuestionDots(),
      ],
    );
  }

  Widget _buildQuestionDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalQuestions > 10 ? 10 : totalQuestions, (
        index,
      ) {
        if (totalQuestions > 10) {
          // Show first 5, current, and last 4
          if (index < 5) {
            return _buildDot(index, index);
          } else if (index == 5) {
            if (currentQuestion > 5 && currentQuestion < totalQuestions - 4) {
              return _buildDot(currentQuestion, 5);
            } else {
              return _buildDot(totalQuestions - 5 + (index - 5), index);
            }
          } else {
            return _buildDot(totalQuestions - 10 + index, index);
          }
        } else {
          return _buildDot(index, index);
        }
      }),
    );
  }

  Widget _buildDot(int questionIndex, int displayIndex) {
    final isCurrent = questionIndex == currentQuestion;
    final isPassed = questionIndex < currentQuestion;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color:
            isCurrent
                ? AppColors.primaryColor
                : isPassed
                ? AppColors.successColor
                : AppColors.grey400,
        shape: BoxShape.circle,
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const TextWidget(text: 'إنهاء الاختبار'),
            content: const TextWidget(
              text:
                  'هل أنت متأكد من رغبتك في إنهاء الاختبار؟ سيتم فقدان التقدم الحالي.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const TextWidget(text: 'إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onExitQuiz();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.errorColor,
                  foregroundColor: Colors.white,
                ),
                child: const TextWidget(text: 'إنهاء'),
              ),
            ],
          ),
    );
  }
}
