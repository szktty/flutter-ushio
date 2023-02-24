import 'package:flutter_test/flutter_test.dart';
import 'package:ushio/src/combine/subscribers.dart';
import 'package:ushio/ushio.dart';

void main() {
  test('basic', () {
    Completion? result;
    String? receive;
    final subject = PassthroughSubject<String, Never>();
    subject.send('a');
    subject.sink(
      onReceive: (value) {
        print('receive $value');
      },
      onCompletion: (completion) {
        print('finish: $completion');
        result = completion;
      },
    );
    subject.send('b');
    subject.finish();
    subject.send('c');
  });
}
