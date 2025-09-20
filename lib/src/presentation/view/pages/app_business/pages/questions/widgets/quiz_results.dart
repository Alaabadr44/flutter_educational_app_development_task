import 'package:flutter/material.dart';
import 'package:flutter_application_bloc/src/core/config/app_colors.dart';

import '../../../../../common/text_widget.dart';
import '../controller/questions_controller.dart' as controller;

class QuizResultsWidget extends StatelessWidget {
  final controller.QuizResults results;
  final String lessonName;
  final Function() onRetryQuiz;
  final Function() onContinue;

  const QuizResultsWidget({
    super.key,
    required this.results,
    required this.lessonName,
    required this.onRetryQuiz,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              _buildHeader(),

              const SizedBox(height: 24),

              // Results Card
              _buildResultsCard(),

              const SizedBox(height: 24),

              // Performance Analysis
              _buildPerformanceCard(),

              const SizedBox(height: 24),

              // Action Buttons
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              results.isPassed
                  ? [
                    AppColors.successColor.withOpacity(0.1),
                    AppColors.successColor.withOpacity(0.05),
                  ]
                  : [
                    AppColors.errorColor.withOpacity(0.1),
                    AppColors.errorColor.withOpacity(0.05),
                  ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              results.isPassed
                  ? AppColors.successColor.withOpacity(0.3)
                  : AppColors.errorColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Status Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color:
                  results.isPassed
                      ? AppColors.successColor
                      : AppColors.errorColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (results.isPassed
                          ? AppColors.successColor
                          : AppColors.errorColor)
                      .withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              results.isPassed ? Icons.check : Icons.close,
              size: 40,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          // Status Text
          TextWidget(
            text: results.isPassed ? 'تهانينا! لقد نجحت' : 'لم تنجح هذه المرة',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color:
                  results.isPassed
                      ? AppColors.successColor
                      : AppColors.errorColor,
            ),
          ),

          const SizedBox(height: 8),

          TextWidget(
            text: lessonName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          TextWidget(
            text: 'درجتك: ${results.grade}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _getGradeColor(results.grade),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
            text: 'نتائج الاختبار',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 20),

          // Score Circle
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: results.percentage / 100,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getScoreColor(results.percentage),
                    ),
                  ),
                ),
                Column(
                  children: [
                    TextWidget(
                      text: '${results.percentage}%',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: _getScoreColor(results.percentage),
                      ),
                    ),
                    TextWidget(
                      text: 'النتيجة',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Statistics
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'الأسئلة الصحيحة',
                  '${results.correctAnswers}',
                  AppColors.successColor,
                  Icons.check_circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'الأسئلة الخاطئة',
                  '${results.totalQuestions - results.correctAnswers}',
                  AppColors.errorColor,
                  Icons.cancel,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'إجمالي النقاط',
                  '${results.totalPoints}',
                  AppColors.primaryColor,
                  Icons.star,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'الوقت المستغرق',
                  _formatTime(results.timeSpent),
                  Colors.orange,
                  Icons.timer,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextWidget(
            text: 'تحليل الأداء',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 16),

          _buildPerformanceItem(
            'معدل الإجابة الصحيحة',
            '${results.percentage}%',
            results.percentage / 100,
            _getScoreColor(results.percentage),
          ),

          const SizedBox(height: 12),

          _buildPerformanceItem(
            'كفاءة الوقت',
            _getTimeEfficiency(),
            _getTimeEfficiencyValue(),
            _getTimeEfficiencyColor(),
          ),

          const SizedBox(height: 16),

          // Feedback
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getFeedbackColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getFeedbackColor().withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getFeedbackIcon(),
                      color: _getFeedbackColor(),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    TextWidget(
                      text: 'ملاحظات الأداء',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _getFeedbackColor(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextWidget(
                  text: _getFeedbackMessage(),
                  style: TextStyle(
                    fontSize: 14,
                    color: _getFeedbackColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        if (!results.isPassed) ...[
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: onRetryQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh),
              label: const TextWidget(
                text: 'إعادة المحاولة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  results.isPassed ? AppColors.successColor : Colors.grey[400],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Icon(results.isPassed ? Icons.arrow_forward : Icons.home),
            label: TextWidget(
              text:
                  results.isPassed
                      ? 'متابعة إلى الدرس التالي'
                      : 'العودة للرئيسية',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          TextWidget(
            text: value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          TextWidget(
            text: label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceItem(
    String label,
    String value,
    double progress,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              text: label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            TextWidget(
              text: value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getScoreColor(int percentage) {
    if (percentage >= 90) return AppColors.successColor;
    if (percentage >= 70) return AppColors.primaryColor;
    if (percentage >= 60) return Colors.orange;
    return AppColors.errorColor;
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
      case 'A':
        return AppColors.successColor;
      case 'B':
        return AppColors.primaryColor;
      case 'C':
        return Colors.orange;
      default:
        return AppColors.errorColor;
    }
  }

  String _getTimeEfficiency() {
    final efficiency = _getTimeEfficiencyValue();
    if (efficiency >= 0.8) return 'ممتاز';
    if (efficiency >= 0.6) return 'جيد';
    if (efficiency >= 0.4) return 'متوسط';
    return 'يحتاج تحسين';
  }

  double _getTimeEfficiencyValue() {
    final totalTime = 30 * 60; // 30 minutes in seconds
    final efficiency = 1 - (results.timeSpent / totalTime);
    return efficiency.clamp(0.0, 1.0);
  }

  Color _getTimeEfficiencyColor() {
    final efficiency = _getTimeEfficiencyValue();
    if (efficiency >= 0.8) return AppColors.successColor;
    if (efficiency >= 0.6) return AppColors.primaryColor;
    if (efficiency >= 0.4) return Colors.orange;
    return AppColors.errorColor;
  }

  Color _getFeedbackColor() {
    if (results.percentage >= 90) return AppColors.successColor;
    if (results.percentage >= 70) return AppColors.primaryColor;
    if (results.percentage >= 60) return Colors.orange;
    return AppColors.errorColor;
  }

  IconData _getFeedbackIcon() {
    if (results.percentage >= 90) return Icons.celebration;
    if (results.percentage >= 70) return Icons.thumb_up;
    if (results.percentage >= 60) return Icons.info;
    return Icons.warning;
  }

  String _getFeedbackMessage() {
    if (results.percentage >= 90) {
      return 'أداء ممتاز! لقد أتقنت هذا الدرس بشكل رائع. استمر في هذا المستوى المتميز.';
    } else if (results.percentage >= 70) {
      return 'أداء جيد جداً! لديك فهم قوي للمادة. راجع النقاط التي أخطأت فيها لتحسين أدائك أكثر.';
    } else if (results.percentage >= 60) {
      return 'أداء مقبول. لقد نجحت ولكن هناك مجال للتحسين. راجع المادة مرة أخرى وحاول حل المزيد من التمارين.';
    } else {
      return 'يحتاج الأداء إلى تحسين. ننصحك بمراجعة المادة بعناية والاستعانة بالمعلم أو المصادر الإضافية.';
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
