import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stream_watcher/stream_watcher.dart';

void main() {
  testWidgets('StatelessWidget updates correctly', (WidgetTester tester) async {
    final controller = StreamController<String>();

    await tester.pumpWidget(TestStatelessWidget(stream: controller.stream));
    controller.add('test');
    await tester.pump();
    final testFinder = find.text('test');
    expect(testFinder, findsOneWidget);

    await controller.close();
  });

  testWidgets('StatefullWidget updates correctly', (WidgetTester tester) async {
    final controller = StreamController<String>();

    await tester.pumpWidget(TestStatelessWidget(stream: controller.stream));
    controller.add('test');
    await tester.pump();
    final testFinder = find.text('test');
    expect(testFinder, findsOneWidget);

    await controller.close();
  });
}

class TestStatelessWidget extends StatelessWidget {
  const TestStatelessWidget({
    Key key,
    this.stream,
  }) : super(key: key);

  final Stream<String> stream;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Text(stream.watch(context, '')),
      ),
    );
  }
}

class TestStatefulWidget extends StatefulWidget {
  const TestStatefulWidget({
    Key key,
    this.stream,
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
        body: Text(widget.stream.watch(context, '')),
      ),
    );
  }
}
