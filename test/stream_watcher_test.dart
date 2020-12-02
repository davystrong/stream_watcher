import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stream_watcher/stream_watcher.dart';

void main() {
  group('Individual widgets', () {
    testWidgets('StatelessWidget updates correctly',
        (WidgetTester tester) async {
      final controller = StreamController<String>();

      await tester.pumpWidget(TestStatelessWidget(stream: controller.stream));
      controller.add('test');
      await tester.pump();
      final testFinder = find.text('test');
      expect(testFinder, findsOneWidget);

      await controller.close();
    });

    testWidgets('StatefullWidget updates correctly',
        (WidgetTester tester) async {
      final controller = StreamController<String>();

      await tester.pumpWidget(TestStatelessWidget(stream: controller.stream));
      controller.add('test');
      await tester.pump();
      final testFinder = find.text('test');
      expect(testFinder, findsOneWidget);

      await controller.close();
    });
  });

  //Because of the way watch() navigates the children of the parent to refresh,
  //this could break
  group('Column widgets', () {
    testWidgets('Column children with watch update correctly',
        (WidgetTester tester) async {
      final controller = StreamController<String>();
      final length = 10;

      await tester.pumpWidget(
          TestColumnWidget1(stream: controller.stream, length: length));
      controller.add('test');
      await tester.pump();
      final testFinder = find.text('test');
      expect(testFinder, findsNWidgets(length + 2));

      await controller.close();
    });

    testWidgets('Column children update correctly',
        (WidgetTester tester) async {
      final controller = StreamController<List<Widget>>();
      final length = 10;

      await tester.pumpWidget(
          TestColumnWidget2(stream: controller.stream, length: length));
      controller.add(List.generate(length, (index) => Text('test')));
      await tester.pump();
      final testFinder = find.text('test');
      expect(testFinder, findsNWidgets(length));

      await controller.close();
    });

    testWidgets('Column children with watch in one widget update correctly',
        (WidgetTester tester) async {
      final controller = StreamController<String>();
      final length = 10;

      await tester.pumpWidget(
          TestColumnWidget3(stream: controller.stream, length: length));
      controller.add('test');
      await tester.pump();
      final testFinder = find.text('test');
      expect(testFinder, findsNWidgets(length));

      await controller.close();
    });
  });
}

class TestStatelessWidget extends StatelessWidget {
  const TestStatelessWidget({
    Key? key,
    required this.stream,
  }) : super(key: key);

  final Stream<String> stream;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Text(stream.watch(context) ?? ''),
      ),
    );
  }
}

class TestStatefulWidget extends StatefulWidget {
  const TestStatefulWidget({
    Key? key,
    required this.stream,
  }) : super(key: key);

  final Stream<String> stream;

  @override
  _TestStatefulWidgetState createState() => _TestStatefulWidgetState();
}

class _TestStatefulWidgetState extends State<TestStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Text(widget.stream.watch(context) ?? ''),
      ),
    );
  }
}

class TestColumnWidget1 extends StatelessWidget {
  const TestColumnWidget1({
    Key? key,
    required this.stream,
    required this.length,
  }) : super(key: key);

  final Stream<String> stream;
  final int length;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            length,
            (index) => TestColumnElement(stream: stream),
          ),
        ),
      ),
    );
  }
}

class TestColumnElement extends StatelessWidget {
  const TestColumnElement({
    Key? key,
    required this.stream,
  }) : super(key: key);

  final Stream<String> stream;

  @override
  Widget build(BuildContext context) {
    return Text(stream.watch(context) ?? '');
  }
}

class TestColumnWidget2 extends StatelessWidget {
  const TestColumnWidget2({
    Key? key,
    required this.stream,
    required this.length,
  }) : super(key: key);

  final Stream<List<Widget>> stream;
  final int length;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: stream.watch(context) ?? [],
        ),
      ),
    );
  }
}

class TestColumnWidget3 extends StatelessWidget {
  const TestColumnWidget3({
    Key? key,
    required this.stream,
    required this.length,
  }) : super(key: key);

  final Stream<String> stream;
  final int length;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            length,
            (index) => Text(stream.watch(context) ?? ''),
          ),
        ),
      ),
    );
  }
}
