import 'package:flutter/material.dart';
import 'package:flutter_application_bloc/src/core/config/app_colors.dart';
import '../../../../../../../domain/entities/quizc_data.dart';
import '../../../../../../../domain/entities/unit_data.dart';
import '../../../../../../view_model/blocs/data_bloc/typedefs_bloc.dart';
import '../../../../../common/text_widget.dart';
import '../../../../../general/app_indicator.dart';
import '../controller/questions_controller.dart' as controller;
import '../widgets/question_card.dart';
import '../widgets/quiz_header.dart';
import '../widgets/quiz_results.dart';

class QuestionsPageSfl extends StatefulWidget {
  final Lesson lesson;
  const QuestionsPageSfl({super.key, required this.lesson});

  @override
  State<QuestionsPageSfl> createState() => _QuestionsPageSflState();
}

class _QuestionsPageSflState extends State<QuestionsPageSfl> {
  late controller.QuestionsController _pageController;
  late PageController _questionsPageController;

  @override
  void initState() {
    super.initState();
    _pageController = controller.QuestionsController();
    _questionsPageController = PageController();
    _pageController.initDependencies(context: context, lesson: widget.lesson);
  }

  @override
  void dispose() {
    _pageController.disposeDependencies();
    _questionsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: BlocDataBuilder<QuizcData>(
          bloc: _pageController.questionsBloc,
          builder: (context, state) {
            return state.maybeMap(
              loading: (value) => const Center(child: AppIndicator()),
              orElse: () => _buildErrorState(),
              successList: (data) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _pageController.onQuestionsLoaded(data.data!);
                });
                return _buildQuizInterface(data.data!);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.red[100]!, Colors.red[50]!],
                ),
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.quiz_outlined,
                size: 60,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            const TextWidget(
              text: 'لا توجد أسئلة متاحة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextWidget(
              text: 'لم يتم العثور على أسئلة لهذا الدرس حالياً',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.arrow_back),
              label: const Text(
                'العودة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizInterface(List<QuizcData> questions) {
    if (questions.isEmpty) return _buildErrorState();

    return ValueListenableBuilder<controller.QuizResults?>(
      valueListenable: _pageController.resultsNotifier,
      builder: (context, results, child) {
        if (results != null) {
          return QuizResultsWidget(
            results: results,
            lessonName: widget.lesson.name ?? 'الدرس',
            onRetryQuiz: _restartQuiz,
            onContinue: () => Navigator.of(context).pop(),
          );
        }

        return ValueListenableBuilder<bool>(
          valueListenable: _pageController.isQuizActiveNotifier,
          builder: (context, isActive, child) {
            if (!isActive) {
              return _buildQuizStartScreen(questions);
            }
            return _buildActiveQuiz(questions);
          },
        );
      },
    );
  }

  Widget _buildQuizStartScreen(List<QuizcData> questions) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lesson info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryColor.withOpacity(0.1),
                    AppColors.primaryColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.quiz, size: 64, color: AppColors.primaryColor),
                  const SizedBox(height: 16),
                  TextWidget(
                    text: widget.lesson.name ?? 'اختبار الدرس',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Quiz info
                  _buildQuizInfoItem(
                    Icons.quiz,
                    'عدد الأسئلة',
                    '${questions.length} سؤال',
                  ),
                  const SizedBox(height: 12),
                  _buildQuizInfoItem(
                    Icons.timer,
                    'مدة الاختبار',
                    '${controller.QuestionsController.quizDurationMinutes} دقيقة',
                  ),
                  const SizedBox(height: 12),
                  _buildQuizInfoItem(
                    Icons.repeat,
                    'المحاولات المسموحة',
                    '${controller.QuestionsController.maxAttempts} محاولات لكل سؤال',
                  ),
                  const SizedBox(height: 12),
                  _buildQuizInfoItem(
                    Icons.check_circle,
                    'درجة النجاح',
                    '60% أو أكثر',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Start button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _startQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                icon: const Icon(Icons.play_arrow, size: 28),
                label: const TextWidget(
                  text: 'بدء الاختبار',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Back button
            TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const TextWidget(text: 'العودة للدروس'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: TextWidget(
            text: label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        TextWidget(
          text: value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveQuiz(List<QuizcData> questions) {
    return Column(
      children: [
        // Quiz Header
        ValueListenableBuilder<int>(
          valueListenable: _pageController.currentQuestionIndexNotifier,
          builder: (context, currentIndex, child) {
            return ValueListenableBuilder<int>(
              valueListenable: _pageController.timerNotifier,
              builder: (context, timeRemaining, child) {
                return QuizHeader(
                  currentQuestion: currentIndex,
                  totalQuestions: questions.length,
                  timeRemaining: timeRemaining,
                  lessonName: widget.lesson.name ?? 'الاختبار',
                  onExitQuiz: _exitQuiz,
                );
              },
            );
          },
        ),

        // Questions
        Expanded(
          child: ValueListenableBuilder<int>(
            valueListenable: _pageController.currentQuestionIndexNotifier,
            builder: (context, currentIndex, child) {
              return PageView.builder(
                controller: _questionsPageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: questions.length,
                onPageChanged: (index) {
                  _pageController.currentQuestionIndexNotifier.value = index;
                },
                itemBuilder: (context, index) {
                  final question = questions[index];

                  return ValueListenableBuilder<Map<int, String?>>(
                    valueListenable: _pageController.selectedOptionsNotifier,
                    builder: (context, selectedOptions, child) {
                      return ValueListenableBuilder<
                        Map<int, controller.QuizAnswer>
                      >(
                        valueListenable: _pageController.answersNotifier,
                        builder: (context, answers, child) {
                          return ValueListenableBuilder<Map<int, int>>(
                            valueListenable: _pageController.attemptsNotifier,
                            builder: (context, attempts, child) {
                              final selectedOption = selectedOptions[index];
                              final answer = answers[index];
                              final questionAttempts = attempts[index] ?? 0;
                              final showHint = _pageController.canShowHint(
                                index,
                              );

                              return QuestionCard(
                                question: question,
                                selectedOption:
                                    selectedOption ?? answer?.selectedOption,
                                attempts: questionAttempts,
                                maxAttempts:
                                    controller.QuestionsController.maxAttempts,
                                showHint: showHint,
                                onOptionSelected: (option) {
                                  _pageController.selectOption(option);
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ),

        // Navigation buttons
        _buildNavigationButtons(questions),
      ],
    );
  }

  Widget _buildNavigationButtons(List<QuizcData> questions) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.grey100, width: 1)),
      ),
      child: ValueListenableBuilder<int>(
        valueListenable: _pageController.currentQuestionIndexNotifier,
        builder: (context, currentIndex, child) {
          return Row(
            children: [
              // Previous button
              if (currentIndex > 0) ...[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _pageController.goToPreviousQuestion();
                      _questionsPageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back),
                    label: const TextWidget(text: 'السابق'),
                  ),
                ),
                const SizedBox(width: 12),
              ],

              // Submit/Next buttons
              Expanded(
                flex: 2,
                child: ValueListenableBuilder<Map<int, String?>>(
                  valueListenable: _pageController.selectedOptionsNotifier,
                  builder: (context, selectedOptions, child) {
                    return ValueListenableBuilder<
                      Map<int, controller.QuizAnswer>
                    >(
                      valueListenable: _pageController.answersNotifier,
                      builder: (context, answers, child) {
                        final hasSelectedOption = selectedOptions.containsKey(
                          currentIndex,
                        );
                        final hasAnswered = answers.containsKey(currentIndex);
                        final isLastQuestion =
                            currentIndex >= questions.length - 1;

                        if (!hasAnswered) {
                          // إذا لم يتم إرسال إجابة بعد - اعرض زر Submit
                          return ElevatedButton.icon(
                            onPressed:
                                hasSelectedOption
                                    ? () {
                                      _pageController.submitAnswer();
                                    }
                                    : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  hasSelectedOption
                                      ? AppColors.primaryColor
                                      : Colors.grey[400],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.send),
                            label: const TextWidget(
                              text: 'إرسال الإجابة',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          );
                        } else {
                          // إذا تم إرسال إجابة - اعرض زر التالي/إنهاء
                          return ElevatedButton.icon(
                            onPressed: () {
                              if (isLastQuestion) {
                                _pageController.finishQuiz();
                              } else {
                                _pageController.goToNextQuestion();
                                _questionsPageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: Icon(
                              isLastQuestion
                                  ? Icons.check
                                  : Icons.arrow_forward,
                            ),
                            label: TextWidget(
                              text:
                                  isLastQuestion ? 'إنهاء الاختبار' : 'التالي',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _startQuiz() {
    _pageController.startQuiz();
  }

  void _restartQuiz() {
    _pageController.resultsNotifier.value = null;
    _questionsPageController = PageController();
    _startQuiz();
  }

  void _exitQuiz() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const TextWidget(text: 'إنهاء الاختبار'),
            content: const TextWidget(
              text: 'هل أنت متأكد من رغبتك في إنهاء الاختبار والعودة؟',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const TextWidget(text: 'إلغاء'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
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
