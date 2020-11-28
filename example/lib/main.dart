import 'package:flutter/material.dart';
import 'data_bloc.dart';
import 'pages/stream_builder_page.dart';
import 'pages/single_widget_page.dart';
import 'pages/builder_widget_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Watcher Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dataBloc = DataBloc(30, Duration(milliseconds: 10));
  final titles = [
    'StreamBuilder',
    'Watch with individual widgets',
    'Watch with single widgets',
  ];
  int titleIndex = 0;

  @override
  void dispose() {
    dataBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[titleIndex]),
      ),
      body: PageView(
        onPageChanged: (value) => setState(() {
          titleIndex = value;
        }),
        children: [
          StreamBuilderPage(dataBloc: dataBloc),
          BuilderWidgetPage(dataBloc: dataBloc),
          SingleWidgetPage(dataBloc: dataBloc),
        ],
      ),
    );
  }
}
