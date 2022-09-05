class InitSetupDB {
  final String attr_type;
  final String attr_value;

  InitSetupDB({
    required this.attr_type,
    required this.attr_value,
  });

  InitSetupDB.fromMap(Map<String, dynamic> res)
      : attr_type = res["attr_type"],
        attr_value = res["attr_value"];

  Map<String, Object?> toMap() {
    return {
      'attr_type': attr_type,
      'attr_value': attr_value,
    };
  }

  factory InitSetupDB.fromJson(Map<String, dynamic> json) {
    return InitSetupDB(
        attr_value: json["attr_value"], attr_type: json["attr_type"]);
  }
}

class InitSetup {
  final String data_version;
  final String review_status;
  final String story_language;
  final double font_size;
  final String app_version_android;
  final String app_version_ios;

  InitSetup({
    required this.data_version,
    required this.review_status,
    required this.story_language,
    required this.font_size,
    required this.app_version_android,
    required this.app_version_ios,
  });

  Map<String, dynamic> toMap() {
    return {
      'data_version': data_version,
      'review_status': review_status,
      'story_language': story_language,
      'font_size': font_size,
      'app_version_android': app_version_android,
      'app_version_ios': app_version_ios,
    };
  }
}
