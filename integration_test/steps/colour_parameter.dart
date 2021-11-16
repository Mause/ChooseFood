import 'package:gherkin/gherkin.dart';

class ColourParameter extends CustomParameter<dynamic> {
  ColourParameter()
      : super('ColourParameter', RegExp("#\\d{6}"),
            (String string) => string.substring(1));
}
