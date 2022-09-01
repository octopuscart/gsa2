class InitSetup {
  final String attr_type;
  final String attr_value;

  InitSetup({
    required this.attr_type,
    required this.attr_value,
  });

  InitSetup.fromMap(Map<String, dynamic> res)
      : attr_type = res["attr_type"],
        attr_value = res["attr_value"];

  Map<String, Object?> toMap() {
    return {
      'attr_type': attr_type,
      'attr_value': attr_value,
    };
  }

  factory InitSetup.fromJson(Map<String, dynamic> json) {
    return InitSetup(
        attr_value: json["attr_value"], attr_type: json["attr_type"]);
  }
}
