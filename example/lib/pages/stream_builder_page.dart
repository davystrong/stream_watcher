import 'package:flutter/material.dart';
import 'package:example/data_bloc.dart';

class StreamBuilderPage extends StatelessWidget {
  const StreamBuilderPage({
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
        child: StreamBuilder<double>(
          stream: dataBloc.streams[index],
          initialData: 0,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return CircularProgressIndicator(value: snapshot.data);
          },
        ),
      ),
    );
  }
}
