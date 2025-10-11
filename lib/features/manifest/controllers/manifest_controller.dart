import 'dart:convert';

import 'package:flutter/services.dart';
import '../models/manifest_details.dart';

class ManifestController {
  ManifestController._internal();

  static final ManifestController instance = ManifestController._internal();

  ManifestDetails? selectedManifest;

  Future<List<ManifestDetails>> loadManifestsFromAssets({String path = 'assets/data/dummy_manifest_data.json'}) async {
    final raw = await rootBundle.loadString(path);
    final List<dynamic> jsonList = json.decode(raw) as List<dynamic>;
    return jsonList.map((e) => ManifestDetails.fromJson(e as Map<String, dynamic>)).toList();
  }

  void setSelectedManifest(ManifestDetails manifest) => selectedManifest = manifest;
}
