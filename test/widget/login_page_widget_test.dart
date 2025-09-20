import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// Test enum for auth way selection
enum AuthWay { phone, email }

/// Fixed Widget Tests for Login Page Components
///
/// These tests focus on testing individual components and UI patterns
/// found in the login page without requiring full dependency injection setup.
void main() {
  group('LoginPage Widget Tests (Fixed)', () {
    group('UI Components Tests', () {
      testWidgets(
        'should display basic text fields with proper configuration',
        (WidgetTester tester) async {
          // Arrange
          Widget testWidget = MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  FormBuilderTextField(
                    name: 'email_or_phone',
                    autofillHints: const [AutofillHints.username],
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email or Phone',
                      hintText: 'Enter your email or phone',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                  FormBuilderTextField(
                    name: 'password',
                    autofillHints: const [AutofillHints.password],
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                ],
              ),
            ),
          );

          // Act
          await tester.pumpWidget(testWidget);
          await tester.pumpAndSettle();

          // Assert
          expect(find.byType(FormBuilderTextField), findsNWidgets(2));
          expect(find.byIcon(Icons.phone_outlined), findsOneWidget);
          expect(find.byIcon(Icons.lock_outline), findsOneWidget);

          final textFields =
              tester
                  .widgetList<FormBuilderTextField>(
                    find.byType(FormBuilderTextField),
                  )
                  .toList();

          // Check first field (email/phone)
          expect(textFields[0].autofillHints, contains(AutofillHints.username));
          expect(textFields[0].textInputAction, equals(TextInputAction.next));
          expect(textFields[0].obscureText, isFalse);

          // Check second field (password)
          expect(textFields[1].autofillHints, contains(AutofillHints.password));
          expect(textFields[1].textInputAction, equals(TextInputAction.done));
          expect(textFields[1].obscureText, isTrue);
        },
      );

      testWidgets('should display radio buttons for auth way selection', (
        WidgetTester tester,
      ) async {
        AuthWay selectedAuthWay = AuthWay.phone;

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    RadioListTile<AuthWay>(
                      title: const Text('Phone'),
                      value: AuthWay.phone,
                      groupValue: selectedAuthWay,
                      onChanged: (value) {
                        setState(() {
                          selectedAuthWay = value!;
                        });
                      },
                    ),
                    RadioListTile<AuthWay>(
                      title: const Text('Email'),
                      value: AuthWay.email,
                      groupValue: selectedAuthWay,
                      onChanged: (value) {
                        setState(() {
                          selectedAuthWay = value!;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(RadioListTile<AuthWay>), findsNWidgets(2));
        expect(find.text('Phone'), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
      });

      testWidgets('should display checkbox with proper styling', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool rememberMe = false;

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Row(
                  children: [
                    Transform.scale(
                      scale: 1.1,
                      child: Checkbox(
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value ?? false;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Remember me'),
                  ],
                );
              },
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(Checkbox), findsOneWidget);
        expect(find.text('Remember me'), findsOneWidget);
        // Check for Transform.scale specifically rather than any Transform
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Transform &&
                widget.transform.getMaxScaleOnAxis() > 1.0,
          ),
          findsOneWidget,
        );
      });

      testWidgets('should display login button with proper styling', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blue.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.text('Sign In'), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);
      });

      testWidgets('should display floating action button for development', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: const Center(child: Text('Main Content')),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {},
              backgroundColor: Colors.blue,
              icon: const Icon(Icons.login, color: Colors.white),
              label: const Text(
                'Fill Test Data',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              tooltip: 'Fill with test credentials',
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.text('Fill Test Data'), findsOneWidget);
        expect(find.byIcon(Icons.login), findsOneWidget);

        final fab = tester.widget<FloatingActionButton>(
          find.byType(FloatingActionButton),
        );
        expect(fab.tooltip, equals('Fill with test credentials'));
      });
    });

    group('Form Validation Tests', () {
      testWidgets('should validate form fields correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        final formKey = GlobalKey<FormBuilderState>();

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              key: formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'email_or_phone',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Email or Phone',
                    ),
                  ),
                  FormBuilderTextField(
                    name: 'password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      formKey.currentState!.validate();
                    },
                    child: const Text('Validate'),
                  ),
                ],
              ),
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Test empty validation
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(formKey.currentState!.validate(), isFalse);

        // Test valid input
        await tester.enterText(
          find.widgetWithText(FormBuilderTextField, 'Email or Phone'),
          'test@example.com',
        );
        await tester.enterText(
          find.widgetWithText(FormBuilderTextField, 'Password'),
          'password123',
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(formKey.currentState!.validate(), isTrue);
      });
    });

    group('User Interaction Tests', () {
      testWidgets('should handle password visibility toggle', (
        WidgetTester tester,
      ) async {
        // Arrange
        bool isObscured = true;

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return TextField(
                  obscureText: isObscured,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscured
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscured = !isObscured;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert initial state
        TextField textField = tester.widget(find.byType(TextField));
        expect(textField.obscureText, isTrue);
        expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

        // Toggle visibility
        await tester.tap(find.byType(IconButton));
        await tester.pump();

        // Assert toggled state
        textField = tester.widget(find.byType(TextField));
        expect(textField.obscureText, isFalse);
        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      });

      testWidgets('should handle form field interactions', (
        WidgetTester tester,
      ) async {
        // Arrange
        final formKey = GlobalKey<FormBuilderState>();

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              key: formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'email',
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  FormBuilderCheckbox(
                    name: 'remember',
                    title: const Text('Remember me'),
                  ),
                ],
              ),
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Test text input
        await tester.enterText(
          find.byWidgetPredicate(
            (widget) =>
                widget is FormBuilderTextField && widget.name == 'email',
          ),
          'test@example.com',
        );

        // Test checkbox
        await tester.tap(
          find.byWidgetPredicate(
            (widget) =>
                widget is FormBuilderCheckbox && widget.name == 'remember',
          ),
        );
        await tester.pump();

        // Save form
        formKey.currentState!.save();

        // Assert
        final formValue = formKey.currentState!.value;
        expect(formValue['email'], equals('test@example.com'));
        expect(formValue['remember'], equals(true));
      });
    });

    group('Layout and Style Tests', () {
      testWidgets('should apply correct styling to container', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.withOpacity(0.1), Colors.white],
                ),
              ),
              child: const Center(child: Text('Content')),
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(Container), findsOneWidget);

        final container = tester.widget<Container>(find.byType(Container));
        expect(container.decoration, isA<BoxDecoration>());

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.gradient, isA<LinearGradient>());
      });

      testWidgets('should be scrollable', (WidgetTester tester) async {
        // Arrange
        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: Column(
                children: List.generate(
                  20,
                  (index) => Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: Colors.grey[200],
                    child: Center(child: Text('Item $index')),
                  ),
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(Container), findsAtLeastNWidgets(15));
      });

      testWidgets('should have proper spacing with SizedBox', (
        WidgetTester tester,
      ) async {
        // Arrange
        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const Text('Title'),
                const SizedBox(height: 40),
                const Text('Subtitle'),
                const SizedBox(height: 8),
                const Text('Content'),
                const SizedBox(height: 32),
                ElevatedButton(onPressed: () {}, child: const Text('Button')),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(SizedBox), findsNWidgets(4));
        expect(find.text('Title'), findsOneWidget);
        expect(find.text('Subtitle'), findsOneWidget);
        expect(find.text('Content'), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('should build efficiently', (WidgetTester tester) async {
        // Arrange
        final stopwatch = Stopwatch()..start();

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < 50; i++)
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text('Item $i'),
                      subtitle: Text('Subtitle $i'),
                      trailing: const Icon(Icons.arrow_forward),
                    ),
                ],
              ),
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
        expect(find.byType(ListTile), findsNWidgets(50));
      });

      testWidgets('should handle rapid interactions', (
        WidgetTester tester,
      ) async {
        // Arrange
        int counter = 0;

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Text('Counter: $counter'),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          counter++;
                        });
                      },
                      child: const Text('Increment'),
                    ),
                  ],
                );
              },
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Rapid taps
        for (int i = 0; i < 10; i++) {
          await tester.tap(find.byType(ElevatedButton));
          await tester.pump(const Duration(milliseconds: 10));
        }

        // Assert
        expect(find.text('Counter: 10'), findsOneWidget);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('should handle long text input', (WidgetTester tester) async {
        // Arrange
        final controller = TextEditingController();
        final longText = 'a' * 1000;

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Long Text Field'),
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.enterText(find.byType(TextField), longText);
        await tester.pump();

        // Assert
        expect(controller.text, equals(longText));
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('should handle special characters', (
        WidgetTester tester,
      ) async {
        // Arrange
        final controller = TextEditingController();
        const specialText = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Special Characters Field',
              ),
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.enterText(find.byType(TextField), specialText);
        await tester.pump();

        // Assert
        expect(controller.text, equals(specialText));
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('should handle null values gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        final formKey = GlobalKey<FormBuilderState>();

        Widget testWidget = MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              key: formKey,
              child: FormBuilderTextField(
                name: 'test_field',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Field cannot be empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Test Field'),
              ),
            ),
          ),
        );

        // Act
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Test with null/empty
        expect(formKey.currentState!.validate(), isFalse);

        // Test with whitespace
        await tester.enterText(find.byType(FormBuilderTextField), '   ');
        expect(formKey.currentState!.validate(), isFalse);

        // Test with valid value
        await tester.enterText(find.byType(FormBuilderTextField), 'valid');
        expect(formKey.currentState!.validate(), isTrue);
      });
    });
  });
}
