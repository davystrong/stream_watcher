# Stream watcher

[![Pub](https://img.shields.io/pub/v/stream_watcher?include_prereleases&logo=flutter)](https://pub.dev/packages/stream_watcher) [![basic-tests](https://img.shields.io/github/workflow/status/davystrong/stream_watcher/basic-tests?label=Basic%20tests&logo=github)](https://github.com/davystrong/stream_watcher/actions) [![Donate](https://img.shields.io/badge/Buy%20me%20a%20coffee-PayPal-green.svg)](https://paypal.me/davystrong)

Inspired by [Provider's](https://pub.dev/packages/provider) brilliant `watch` extension to `BuildContext`, this is an extension to `Stream` that allows watching the value of stream and automatically updates the parent widget when it changes.

## Usage

Import the package, then call `.watch(context)` on a `Stream`.

```
import 'package:stream_watcher/stream_watcher.dart';

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
        value: progressStream.watch(context) ?? 0,
      ),
    );
  }
}
```

## Performance

Obviously, the big question about this is performance. While not quite as good as a normal `StreamBuilder`, the performance hit isn't too bad. This means that, while you probably shouldn't use this when you're struggling with performance, it's perfectly acceptable for most situations. The gain in ease and simplicity of coding is also a plus, using `.watch(...)` is a very nice way of accessing a stream's value.

The included example app contains three configurations for accessing streams:
1) `StreamBuiler`
2) `.watch(...)` in its own context (using a builder)
3) `.watch(...)` in a context with 30 builders.

*The last configuration was included because I thought the size of the widget my affect the performance. Certainly in this test case, the difference is insignificant.*

Measuring the compute time on my Samsung Galaxy S8 with the performance overlay (UI thread), we get (aproximately - max values especially vary a lot):

| Method | Average |   Max |
| ------ | :-----: | ----: |
| 1      | 4.8 ms  | 15 ms |
| 2      | 6.0 ms  | 15 ms |
| 3      | 6.2 ms  | 16 ms |

## Limitations

When using the `.watch(...)` method, you must take care that the `Stream` you are watching doesn't get recreated when the rebuild is triggered. For example, if your stream getter implicitly calls `someStream.map(...)`, a new stream will be created, initially with a value of null, leaving you in an endless loop.
While I think this is also the case for the normal `StreamBuilder`, it isn't as obvious because `StreamBuilder` rebuilds itself, rather than the parent widget, so this issue would happen less frequently.

## Notes

The implementation of the `.watch(...)` function at one point catches a `FlutterError`. This isn't specifically an error but it probably is considered bad practice as errors should be fixed rather than caught. In this case, it was the only way I could find to discover if an element was still mounted.

Much like `StreamBuilder`, `.watch(...)` initially returns a value of `null`. I had initially included an optional `initialValue` parameter, which set the value at the start, however this would only work if the stream were only watched once in a `BuildContext`, therefore it was removed. The best way to deal with this null value is the null aware operator `someStream.watch(context) ?? backupValue`.
