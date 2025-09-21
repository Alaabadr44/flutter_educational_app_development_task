import 'package:flutter/material.dart';
import 'package:flutter_application_bloc/src/core/config/app_colors.dart';

import '../../../../../../../domain/entities/quizc_data.dart';
import '../../../../../common/text_widget.dart';

class QuestionCard extends StatelessWidget {
  final QuizcData question;
  final String? selectedOption;
  final int attempts;
  final int maxAttempts;
  final bool showHint;
  final Function(String) onOptionSelected;

  const QuestionCard({
    super.key,
    required this.question,
    this.selectedOption,
    required this.attempts,
    required this.maxAttempts,
    required this.showHint,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Section
          _buildQuestionSection(),

          const SizedBox(height: 24),

          // Options Section
          _buildOptionsSection(),

          if (showHint) ...[const SizedBox(height: 24), _buildHintSection()],

          const SizedBox(height: 16),

          // Attempts Information
          _buildAttemptsInfo(),
        ],
      ),
    );
  }

  Widget _buildQuestionSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor.withOpacity(0.1),
            AppColors.primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skill/Category tag
          if (question.skill != null && question.skill!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                question.skill!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Question Text
          if (question.quesText != null && question.quesText!.isNotEmpty) ...[
            TextWidget(
              text: question.quesText!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Question Image
          if (question.quesFileApi != null &&
              question.quesFileApi.toString().isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _getCompleteImageUrl(question.quesFileApi.toString()),
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Description - hidden because it reveals the hint
          // if (question.descriptionText != null &&
          //     question.descriptionText!.isNotEmpty) ...[
          //   Container(
          //     padding: const EdgeInsets.all(16),
          //     decoration: BoxDecoration(
          //       color: Colors.blue[50],
          //       borderRadius: BorderRadius.circular(12),
          //       border: Border.all(color: Colors.blue[200]!, width: 1),
          //     ),
          //     child: Row(
          //       children: [
          //         Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
          //         const SizedBox(width: 8),
          //         Expanded(
          //           child: TextWidget(
          //             text: question.descriptionText!,
          //             style: TextStyle(
          //               fontSize: 14,
          //               color: Colors.blue[700],
          //               fontWeight: FontWeight.w500,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ],

          // Points indicator
          if (question.point != null && question.point! > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber[600], size: 16),
                const SizedBox(width: 4),
                Text(
                  '${question.point} points',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.amber[700],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionsSection() {
    final options = _getOptions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextWidget(
          text: 'Choose the correct answer:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),

        ...options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          return _buildOptionCard(option, index);
        }).toList(),
      ],
    );
  }

  Widget _buildOptionCard(QuestionOption option, int index) {
    final isSelected = selectedOption == option.key;
    final isCorrect = option.key == question.correctSelect;
    final showResult = selectedOption != null;

    Color backgroundColor;
    Color borderColor;
    Color textColor = Colors.black87;

    if (showResult) {
      if (isSelected && isCorrect) {
        backgroundColor = AppColors.successColor.withOpacity(0.1);
        borderColor = AppColors.successColor;
      } else if (isSelected && !isCorrect) {
        backgroundColor = AppColors.errorColor.withOpacity(0.1);
        borderColor = AppColors.errorColor;
      } else if (isCorrect && showHint) {
        backgroundColor = AppColors.successColor.withOpacity(0.05);
        borderColor = AppColors.successColor.withOpacity(0.3);
      } else {
        backgroundColor = Colors.grey[50]!;
        borderColor = Colors.grey[300]!;
      }
    } else {
      backgroundColor = Colors.white;
      borderColor = AppColors.primaryColor.withOpacity(0.3);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: _canSelectOption() ? () => onOptionSelected(option.key) : null,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 2),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: borderColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                    : [],
          ),
          child: Row(
            children: [
              // Option indicator
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected ? borderColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 2),
                ),
                child: Center(
                  child:
                      showResult && isSelected
                          ? Icon(
                            isCorrect ? Icons.check : Icons.close,
                            color: Colors.white,
                            size: 16,
                          )
                          : Text(
                            String.fromCharCode(65 + index), // A, B, C, D
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : borderColor,
                            ),
                          ),
                ),
              ),

              const SizedBox(width: 16),

              // Option content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (option.text.isNotEmpty) ...[
                      TextWidget(
                        text: option.text,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],

                    if (option.imageUrl != null) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          option.imageUrl!,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Correct answer indicator
              if (showResult && isCorrect && showHint) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Correct Answer',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHintSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[300]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.orange[700],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Hint',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            attempts >= maxAttempts
                ? 'You have exhausted your attempts. The correct answer is: ${_getCorrectAnswerText()}'
                : 'Hint: Review the question carefully. The correct answer is: ${_getCorrectAnswerText()}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.orange[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttemptsInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.repeat, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            'Attempt $attempts of $maxAttempts',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (attempts >= maxAttempts) ...[
            Icon(Icons.info_outline, size: 16, color: Colors.orange[600]),
            const SizedBox(width: 4),
            Text(
              'Hint shown',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<QuestionOption> _getOptions() {
    final options = <QuestionOption>[];

    if (question.select1Text != null && question.select1Text!.isNotEmpty) {
      options.add(
        QuestionOption(
          key: 'select_1',
          text: question.select1Text!,
          imageUrl:
              question.select1FileApi != null
                  ? _getCompleteImageUrl(question.select1FileApi.toString())
                  : null,
        ),
      );
    }

    if (question.select2Text != null && question.select2Text!.isNotEmpty) {
      options.add(
        QuestionOption(
          key: 'select_2',
          text: question.select2Text!,
          imageUrl:
              question.select2FileApi != null
                  ? _getCompleteImageUrl(question.select2FileApi.toString())
                  : null,
        ),
      );
    }

    if (question.select3Text != null && question.select3Text!.isNotEmpty) {
      options.add(
        QuestionOption(
          key: 'select_3',
          text: question.select3Text!,
          imageUrl:
              question.select3FileApi != null
                  ? _getCompleteImageUrl(question.select3FileApi.toString())
                  : null,
        ),
      );
    }

    if (question.select4Text != null && question.select4Text!.isNotEmpty) {
      options.add(
        QuestionOption(
          key: 'select_4',
          text: question.select4Text!,
          imageUrl:
              question.select4FileApi != null
                  ? _getCompleteImageUrl(question.select4FileApi.toString())
                  : null,
        ),
      );
    }

    return options;
  }

  String _getCompleteImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    return 'https://taseese.org$imagePath';
  }

  bool _canSelectOption() {
    // Any option can be freely selected before submit
    // This is only for selection, not for submission
    return true;
  }

  String _getCorrectAnswerText() {
    final options = _getOptions();
    final correctOption = options.firstWhere(
      (option) => option.key == question.correctSelect,
      orElse: () => QuestionOption(key: '', text: 'Not specified'),
    );

    // Determine the letter (A, B, C, D)
    final optionIndex = options.indexOf(correctOption);
    final optionLetter =
        optionIndex >= 0 ? String.fromCharCode(65 + optionIndex) : '?';

    return '$optionLetter - ${correctOption.text}';
  }
}

class QuestionOption {
  final String key;
  final String text;
  final String? imageUrl;

  QuestionOption({required this.key, required this.text, this.imageUrl});
}
