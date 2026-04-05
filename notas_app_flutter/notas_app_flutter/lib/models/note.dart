class Note {
  final int? id;
  final int? userId;
  final String title;
  final String content;
  final String? updatedAt;
  final int synced;

  Note({
    this.id,
    this.userId,
    required this.title,
    required this.content,
    this.updatedAt,
    this.synced = 1,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      content: json['content'] ?? '',
      updatedAt: json['updated_at']?.toString(),
      synced: json['synced'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'updated_at': updatedAt ?? DateTime.now().toIso8601String(),
      'synced': synced,
    };
  }
}