import 'package:flutter/material.dart';
import 'package:example/data_bloc.dart';
import 'package:stream_watcher/stream_watcher.dart';

class BuilderWidgetPage extends StatelessWidget {
  const BuilderWidgetPage({
    Key? key,
    required this.dataBloc,
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
          value: dataBloc.streams[index].watch(context) ?? 0,
        ),
      ),
    );
  }
}
