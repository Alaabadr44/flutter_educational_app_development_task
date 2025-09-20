import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_bloc/src/presentation/view/pages/app_business/pages/units/controller/units_controller.dart';
import 'package:flutter_application_bloc/src/domain/entities/subjects_data.dart';
import 'package:flutter_application_bloc/src/core/utils/page_controller.dart';
import 'package:flutter_application_bloc/src/presentation/view/mixins/list_type_view.dart';

void main() {
  group('UnitsController Tests', () {
    late UnitsController controller;
    late Subject testSubject;

    setUp(() {
      // Set up test data
      testSubject = Subject(
        id: 1,
        name: 'Mathematics',
        color: '#FF5722',
        price: 100,
        systemId: 1,
        stageId: 7,
        classroomId: 12,
        termId: 1,
        pathId: 1,
        isSubscribe: true,
        lessonsCount: 25,
        finishesLessonsCount: 10,
      );

      // Create controller
      controller = UnitsController();
    });

    tearDown(() {
      try {
        controller.disposeDependencies();
      } catch (e) {
        // Ignore disposal errors in tests
      }
    });

    group('Basic Properties', () {
      test('should initialize with null subject', () {
        // Assert
        expect(controller.subject, isNull);
      });

      test('should implement AppPageController interface', () {
        // Assert
        expect(controller, isA<AppPageController>());
      });

      test('should include ListTypeView mixin', () {
        // Assert
        expect(controller, isA<ListTypeView>());
      });

      test('should throw UnimplementedError for route getter', () {
        // Act & Assert
        expect(() => controller.route, throwsUnimplementedError);
      });
    });

    group('Subject Management', () {
      test('should store subject when provided during initialization', () {
        // Act
        controller.subject = testSubject;

        // Assert
        expect(controller.subject, equals(testSubject));
        expect(controller.subject?.id, equals(1));
        expect(controller.subject?.name, equals('Mathematics'));
      });

      test('should handle null subject', () {
        // Act
        controller.subject = null;

        // Assert
        expect(controller.subject, isNull);
      });

      test('should work with different subject properties', () {
        // Arrange
        final customSubject = Subject(
          id: 5,
          name: 'Physics',
          color: '#2196F3',
          price: 150,
          systemId: 2,
          stageId: 8,
          classroomId: 11,
          termId: 2,
          pathId: 2,
          isSubscribe: false,
          lessonsCount: 30,
          finishesLessonsCount: 0,
        );

        // Act
        controller.subject = customSubject;

        // Assert
        expect(controller.subject?.id, equals(5));
        expect(controller.subject?.name, equals('Physics'));
        expect(controller.subject?.color, equals('#2196F3'));
        expect(controller.subject?.price, equals(150));
        expect(controller.subject?.isSubscribe, equals(false));
        expect(controller.subject?.lessonsCount, equals(30));
      });

      test('should handle subject with minimal properties', () {
        // Arrange
        final minimalSubject = Subject(id: 99, name: 'Chemistry');

        // Act
        controller.subject = minimalSubject;

        // Assert
        expect(controller.subject?.id, equals(99));
        expect(controller.subject?.name, equals('Chemistry'));
        expect(controller.subject?.color, isNull);
        expect(controller.subject?.price, isNull);
        expect(controller.subject?.isSubscribe, isNull);
      });
    });

    group('Controller State Management', () {
      test('should allow updating subject multiple times', () {
        // Arrange
        controller.subject = testSubject;
        expect(controller.subject?.id, equals(1));

        // Act - Change subject
        final newSubject = Subject(id: 3, name: 'Biology', color: '#4CAF50');
        controller.subject = newSubject;

        // Assert
        expect(controller.subject?.id, equals(3));
        expect(controller.subject?.name, equals('Biology'));
        expect(controller.subject?.color, equals('#4CAF50'));
      });

      test('should handle clearing subject', () {
        // Arrange
        controller.subject = testSubject;
        expect(controller.subject, isNotNull);

        // Act
        controller.subject = null;

        // Assert
        expect(controller.subject, isNull);
      });
    });

    group('Subject Properties Validation', () {
      test('should work with subscription status', () {
        // Arrange - Subscribed subject
        final subscribedSubject = Subject(
          id: 1,
          name: 'Math Advanced',
          isSubscribe: true,
        );

        // Act
        controller.subject = subscribedSubject;

        // Assert
        expect(controller.subject?.isSubscribe, isTrue);
      });

      test('should work with unsubscribed subject', () {
        // Arrange - Unsubscribed subject
        final unsubscribedSubject = Subject(
          id: 2,
          name: 'Premium Physics',
          isSubscribe: false,
          price: 200,
        );

        // Act
        controller.subject = unsubscribedSubject;

        // Assert
        expect(controller.subject?.isSubscribe, isFalse);
        expect(controller.subject?.price, equals(200));
      });

      test('should handle lesson counts correctly', () {
        // Arrange
        final subjectWithLessons = Subject(
          id: 3,
          name: 'Science',
          lessonsCount: 15,
          finishesLessonsCount: 8,
        );

        // Act
        controller.subject = subjectWithLessons;

        // Assert
        expect(controller.subject?.lessonsCount, equals(15));
        expect(controller.subject?.finishesLessonsCount, equals(8));
      });

      test('should handle educational metadata', () {
        // Arrange
        final educationalSubject = Subject(
          id: 4,
          name: 'Advanced Mathematics',
          systemId: 1,
          stageId: 12,
          classroomId: 3,
          termId: 2,
          pathId: 1,
        );

        // Act
        controller.subject = educationalSubject;

        // Assert
        expect(controller.subject?.systemId, equals(1));
        expect(controller.subject?.stageId, equals(12));
        expect(controller.subject?.classroomId, equals(3));
        expect(controller.subject?.termId, equals(2));
        expect(controller.subject?.pathId, equals(1));
      });
    });

    group('Edge Cases', () {
      test('should handle subject with zero lesson counts', () {
        // Arrange
        final emptySubject = Subject(
          id: 10,
          name: 'Empty Subject',
          lessonsCount: 0,
          finishesLessonsCount: 0,
        );

        // Act
        controller.subject = emptySubject;

        // Assert
        expect(controller.subject?.lessonsCount, equals(0));
        expect(controller.subject?.finishesLessonsCount, equals(0));
      });

      test('should handle subject with null educational IDs', () {
        // Arrange
        final partialSubject = Subject(
          id: 11,
          name: 'Partial Subject',
          systemId: null,
          stageId: null,
          classroomId: null,
          termId: null,
          pathId: null,
        );

        // Act
        controller.subject = partialSubject;

        // Assert
        expect(controller.subject?.id, equals(11));
        expect(controller.subject?.systemId, isNull);
        expect(controller.subject?.stageId, isNull);
        expect(controller.subject?.classroomId, isNull);
        expect(controller.subject?.termId, isNull);
        expect(controller.subject?.pathId, isNull);
      });

      test('should handle subject equality', () {
        // Arrange
        final subject1 = Subject(id: 1, name: 'Math', color: '#FF5722');
        final subject2 = Subject(id: 1, name: 'Math', color: '#FF5722');

        // Act
        controller.subject = subject1;

        // Assert
        expect(controller.subject, equals(subject1));
        expect(
          controller.subject,
          equals(subject2),
        ); // Should be equal due to implementation
      });
    });

    group('Subject Type Scenarios', () {
      test('should handle free subjects', () {
        // Arrange
        final freeSubject = Subject(
          id: 20,
          name: 'Free Mathematics',
          price: 0,
          isSubscribe: true,
        );

        // Act
        controller.subject = freeSubject;

        // Assert
        expect(controller.subject?.price, equals(0));
        expect(controller.subject?.isSubscribe, isTrue);
      });

      test('should handle premium subjects', () {
        // Arrange
        final premiumSubject = Subject(
          id: 21,
          name: 'Premium Physics',
          price: 500,
          isSubscribe: false,
        );

        // Act
        controller.subject = premiumSubject;

        // Assert
        expect(controller.subject?.price, equals(500));
        expect(controller.subject?.isSubscribe, isFalse);
      });

      test('should handle subjects with progress', () {
        // Arrange
        final progressSubject = Subject(
          id: 22,
          name: 'In Progress Chemistry',
          lessonsCount: 20,
          finishesLessonsCount: 12,
          isSubscribe: true,
        );

        // Act
        controller.subject = progressSubject;

        // Assert
        expect(controller.subject?.lessonsCount, equals(20));
        expect(controller.subject?.finishesLessonsCount, equals(12));
        expect(controller.subject?.isSubscribe, isTrue);

        // Calculate progress percentage (should be 60%)
        final progress =
            (controller.subject!.finishesLessonsCount! /
                controller.subject!.lessonsCount!) *
            100;
        expect(progress, equals(60.0));
      });
    });
  });
}
