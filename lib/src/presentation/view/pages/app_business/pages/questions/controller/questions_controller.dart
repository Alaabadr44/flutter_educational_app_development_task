import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../../../../core/utils/api_info.dart';
import '../../../../../../../core/utils/enums.dart';
import '../../../../../../../core/utils/page_controller.dart';
import '../../../../../../../domain/entities/quizc_data.dart';
import '../../../../../../../domain/entities/unit_data.dart';
import '../../../../../../view_model/blocs/data_bloc/api_data_bloc.dart';
import '../../../../../../view_model/blocs/data_bloc/api_data_event.dart';

class QuestionsController implements AppPageController {
  Lesson? lesson;
  late ApiDataBloc<QuizcData> questionsBloc;

  // Quiz management
  late ValueNotifier<int> currentQuestionIndexNotifier;
  late ValueNotifier<int> timerNotifier;
  late ValueNotifier<Map<int, QuizAnswer>> answersNotifier;
  late ValueNotifier<Map<int, int>> attemptsNotifier;
  late ValueNotifier<bool> isQuizActiveNotifier;
  late ValueNotifier<QuizResults?> resultsNotifier;
  late ValueNotifier<Map<int, String?>>
  selectedOptionsNotifier; // الاختيارات المؤقتة

  Timer? _timer;
  List<QuizcData> questions = [];
  static const int maxAttempts = 3;
  static const int hintAfterAttempts = 3;
  static const int quizDurationMinutes = 30;

  @override
  void disposeDependencies({BuildContext? context}) {
    questionsBloc.close();
    _timer?.cancel();
    currentQuestionIndexNotifier.dispose();
    timerNotifier.dispose();
    answersNotifier.dispose();
    attemptsNotifier.dispose();
    isQuizActiveNotifier.dispose();
    resultsNotifier.dispose();
    selectedOptionsNotifier.dispose();
  }

  @override
  void initDependencies({BuildContext? context, Lesson? lesson}) {
    this.lesson = lesson;
    questionsBloc = ApiDataBloc<QuizcData>();

    // Initialize notifiers
    currentQuestionIndexNotifier = ValueNotifier<int>(0);
    timerNotifier = ValueNotifier<int>(quizDurationMinutes * 60);
    answersNotifier = ValueNotifier<Map<int, QuizAnswer>>({});
    attemptsNotifier = ValueNotifier<Map<int, int>>({});
    isQuizActiveNotifier = ValueNotifier<bool>(false);
    resultsNotifier = ValueNotifier<QuizResults?>(null);
    selectedOptionsNotifier = ValueNotifier<Map<int, String?>>({});

    getQuestions();
  }

  void getQuestions() {
    questionsBloc.add(
      ApiDataEvent.index(
        apiMethod: ApiRequestType.post,
        listWithoutPagination: true,
        queryParams: ApiInfo(
          endpoint: ApiRoute.questions.route,
          queries: {'lesson_id': lesson?.id},
        ),
      ),
    );
  }

  void onQuestionsLoaded(List<QuizcData> loadedQuestions) {
    questions = loadedQuestions;
    // Initialize attempts for each question
    final Map<int, int> initialAttempts = {};
    for (int i = 0; i < questions.length; i++) {
      initialAttempts[i] = 0;
    }
    attemptsNotifier.value = initialAttempts;
  }

  void startQuiz() {
    if (questions.isEmpty) return;

    isQuizActiveNotifier.value = true;
    currentQuestionIndexNotifier.value = 0;
    timerNotifier.value = quizDurationMinutes * 60;
    answersNotifier.value = {};

    // Reset attempts
    final Map<int, int> resetAttempts = {};
    for (int i = 0; i < questions.length; i++) {
      resetAttempts[i] = 0;
    }
    attemptsNotifier.value = resetAttempts;

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerNotifier.value > 0) {
        timerNotifier.value = timerNotifier.value - 1;
      } else {
        finishQuiz();
      }
    });
  }

  // دالة لاختيار الخيار مؤقتاً (بدون submission)
  void selectOption(String option) {
    final currentIndex = currentQuestionIndexNotifier.value;
    selectedOptionsNotifier.value = {
      ...selectedOptionsNotifier.value,
      currentIndex: option,
    };
  }

  // دالة لـ submit الإجابة النهائية
  void submitAnswer() {
    final currentIndex = currentQuestionIndexNotifier.value;
    final selectedOption = selectedOptionsNotifier.value[currentIndex];

    if (selectedOption == null) return; // لا يوجد اختيار

    answerQuestion(selectedOption);
  }

  void answerQuestion(String selectedOption) {
    final currentIndex = currentQuestionIndexNotifier.value;
    if (currentIndex >= questions.length) return;

    final question = questions[currentIndex];
    final isCorrect = selectedOption == question.correctSelect;

    // Record answer
    answersNotifier.value = {
      ...answersNotifier.value,
      currentIndex: QuizAnswer(
        questionId: question.id!,
        selectedOption: selectedOption,
        isCorrect: isCorrect,
        attempts: attemptsNotifier.value[currentIndex]! + 1,
      ),
    };

    // Update attempts
    attemptsNotifier.value = {
      ...attemptsNotifier.value,
      currentIndex: attemptsNotifier.value[currentIndex]! + 1,
    };

    if (isCorrect) {
      // Correct answer - move to next question after delay
      Future.delayed(const Duration(seconds: 2), () {
        goToNextQuestion();
      });
    } else {
      // Wrong answer - check attempts
      if (attemptsNotifier.value[currentIndex]! >= maxAttempts) {
        // Show hint and give more time to read it
        Future.delayed(const Duration(seconds: 5), () {
          goToNextQuestion();
        });
      }
      // If not max attempts yet, user can continue trying
    }
  }

  void goToNextQuestion() {
    if (currentQuestionIndexNotifier.value < questions.length - 1) {
      final nextIndex = currentQuestionIndexNotifier.value + 1;
      currentQuestionIndexNotifier.value = nextIndex;

      // امسح الاختيار المؤقت للسؤال الجديد إذا لم يتم submit بعد
      if (!answersNotifier.value.containsKey(nextIndex)) {
        selectedOptionsNotifier.value = {...selectedOptionsNotifier.value}
          ..remove(nextIndex);
      }
    } else {
      finishQuiz();
    }
  }

  void goToPreviousQuestion() {
    if (currentQuestionIndexNotifier.value > 0) {
      currentQuestionIndexNotifier.value =
          currentQuestionIndexNotifier.value - 1;
    }
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < questions.length) {
      currentQuestionIndexNotifier.value = index;
    }
  }

  void finishQuiz() {
    isQuizActiveNotifier.value = false;
    _timer?.cancel();

    // Calculate results
    final answers = answersNotifier.value;
    int correctAnswers = 0;
    int totalPoints = 0;

    for (int i = 0; i < questions.length; i++) {
      final answer = answers[i];
      if (answer != null && answer.isCorrect) {
        correctAnswers++;
        totalPoints += questions[i].point ?? 0;
      }
    }

    final percentage =
        questions.isNotEmpty
            ? (correctAnswers / questions.length * 100).round()
            : 0;

    resultsNotifier.value = QuizResults(
      totalQuestions: questions.length,
      correctAnswers: correctAnswers,
      totalPoints: totalPoints,
      percentage: percentage,
      timeSpent: (quizDurationMinutes * 60) - timerNotifier.value,
      answers: answers,
    );
  }

  bool canShowHint(int questionIndex) {
    final attempts = attemptsNotifier.value[questionIndex] ?? 0;
    final answer = answersNotifier.value[questionIndex];

    // إظهار التلميح إذا:
    // 1. المحاولات >= hintAfterAttempts (بعد المحاولة الثانية)
    // 2. الإجابة خاطئة أو لا توجد إجابة صحيحة
    // 3. ولكن ليس بعد انتهاء جميع المحاولات المسموحة
    if (attempts >= hintAfterAttempts &&
        (answer == null || !answer.isCorrect)) {
      return true;
    }

    return false;
  }

  bool hasAnsweredQuestion(int questionIndex) {
    return answersNotifier.value.containsKey(questionIndex);
  }

  bool isQuestionCorrect(int questionIndex) {
    final answer = answersNotifier.value[questionIndex];
    return answer?.isCorrect ?? false;
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  String? get route => throw UnimplementedError();
}

// Data classes
class QuizAnswer {
  final int questionId;
  final String selectedOption;
  final bool isCorrect;
  final int attempts;

  QuizAnswer({
    required this.questionId,
    required this.selectedOption,
    required this.isCorrect,
    required this.attempts,
  });
}

class QuizResults {
  final int totalQuestions;
  final int correctAnswers;
  final int totalPoints;
  final int percentage;
  final int timeSpent;
  final Map<int, QuizAnswer> answers;

  QuizResults({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.totalPoints,
    required this.percentage,
    required this.timeSpent,
    required this.answers,
  });

  String get grade {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B';
    if (percentage >= 60) return 'C';
    return 'F';
  }

  bool get isPassed => percentage >= 60;
}
