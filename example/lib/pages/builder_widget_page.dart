import 'package:flutter/material.dart';
import 'package:example/data_bloc.dart';
import 'package:stream_watcher/stream_watcher.dart';

class BuilderWidgetPage extends StatelessWidget {
  const BuilderWidgetPage({
    Key key,
    this.dataBloc,
  }) : super(key: key);
  final DataBloc dataBloc;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemCount: dataBloc.streamCount,
      itemBuilder: (context, index) => GridTile(
        child: CircularProgressIndicator(
          value: dataBloc.streams[index].watch(context, 0),
        ),
      ),
    );
  }
}

class Example extends StatefulWidget {
  const Example({Key key}) : super(key: key);

  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  Stream<double> progressStream;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        value: progressStream.watch(context, 0),
      ),
    );
  }
}
