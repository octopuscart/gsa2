class StoryLine {
  final String? language_id;

  StoryLine({
    this.language_id,
  });

  StoryLine.fromMap(Map<String, dynamic> res)
      : language_id = res["language_id"];

  Map<String, Object?> toMap() {
    return {
      'language_id': language_id,
    };
  }

  factory StoryLine.fromJson(Map<String, dynamic> json) {
    return StoryLine(
      language_id: json["language_id"],
    );
  }
}
