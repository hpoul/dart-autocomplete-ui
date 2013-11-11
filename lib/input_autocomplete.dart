library input_autocomplete;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

@MirrorsUsed(symbols: 'key', override: '*')
import 'dart:mirrors';

part 'src/input_autocomplete_component.dart';
part 'src/autocomplete_choice.dart';
part 'src/autocomplete_choice_renderer.dart';
part 'src/autocomplete_datasource.dart';

Logger _logger = new Logger("tapo.autocomplete");


