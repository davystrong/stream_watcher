import 'dart:async';

import 'dart:math';

class DataBloc {
  final List<StreamController<double>> _streamControllers;
  final List<Stream<double>> streams = [];
  Timer updateTimer;
  int ticks = 0;
  final int streamCount;

  DataBloc(this.streamCount, Duration updatePeriod)
      : _streamControllers = List.generate(
            streamCount, (index) => StreamController.broadcast()) {
    updateTimer = Timer.periodic(updatePeriod, updateStreams);
    streams.addAll(_streamControllers.map<Stream<double>>((e) => e.stream));
  }

  void updateStreams(Timer _) {
    for (var i = 0; i < _streamControllers.length; i++) {
      _streamControllers[i].add(0.5 * (sin(ticks * (i + 1) / 400) + 1));
    }
    ticks++;
  }

  void dispose() {
    updateTimer.cancel();
    for (var controller in _streamControllers) {
      controller.close();
    }
  }
}
