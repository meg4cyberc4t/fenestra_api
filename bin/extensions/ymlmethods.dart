import 'dart:io';

import 'package:yaml/yaml.dart';

Future<Map> loadYamlFile(String path) async =>
    loadYaml(await File(path).readAsString());
