import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Advanced Widget Tests', () {
    testWidgets('should display app bar widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Test App'),
            ),
            body: const Text('Body Content'),
          ),
        ),
      );

      expect(find.text('Test App'), findsOneWidget);
      expect(find.text('Body Content'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display bottom navigation bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Text('Body'),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Business'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Business'), findsOneWidget);
    });

    testWidgets('should display drawer widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Text('Body'),
            drawer: Drawer(
              child: ListView(
                children: const [
                  DrawerHeader(child: Text('Header')),
                  ListTile(title: Text('Item 1')),
                  ListTile(title: Text('Item 2')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Drawer), findsOneWidget);
      expect(find.text('Header'), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('should display floating action button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Body'),
            floatingActionButton: FloatingActionButton(
              onPressed: null,
              child: Icon(Icons.add),
            ),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should display snackbar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Test Snackbar')),
                  );
                },
                child: const Text('Show Snackbar'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Snackbar'));
      await tester.pump();

      expect(find.text('Test Snackbar'), findsOneWidget);
    });

    testWidgets('should display dialog', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Test Dialog'),
                      content: const Text('Dialog Content'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Dialog'));
      await tester.pump();

      expect(find.text('Test Dialog'), findsOneWidget);
      expect(find.text('Dialog Content'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('should display form with text fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should display grid view', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GridView.count(
              crossAxisCount: 2,
              children: const [
                Card(child: Text('Item 1')),
                Card(child: Text('Item 2')),
                Card(child: Text('Item 3')),
                Card(child: Text('Item 4')),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(4));
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
      expect(find.text('Item 4'), findsOneWidget);
    });

    testWidgets('should display tab bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  tabs: const [
                    Tab(text: 'Tab 1'),
                    Tab(text: 'Tab 2'),
                  ],
                ),
              ),
              body: TabBarView(
                children: const [
                  Text('Content 1'),
                  Text('Content 2'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TabBar), findsOneWidget);
      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
      expect(find.text('Content 1'), findsOneWidget);
      expect(find.text('Content 2'), findsOneWidget);
    });

    testWidgets('should display stepper widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stepper(
              steps: const [
                Step(title: Text('Step 1'), content: Text('Content 1')),
                Step(title: Text('Step 2'), content: Text('Content 2')),
                Step(title: Text('Step 3'), content: Text('Content 3')),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(Stepper), findsOneWidget);
      expect(find.text('Step 1'), findsOneWidget);
      expect(find.text('Step 2'), findsOneWidget);
      expect(find.text('Step 3'), findsOneWidget);
      expect(find.text('Content 1'), findsOneWidget);
      expect(find.text('Content 2'), findsOneWidget);
      expect(find.text('Content 3'), findsOneWidget);
    });
  });
}  