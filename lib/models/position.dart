class Position {
  final int? id;
  final String name;

  Position({this.id, required this.name});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
