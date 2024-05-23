class Actor {
  final String name;
  final int id;
  final String profilePath;
  final String? character;

  Actor({
    required this.name,
    required this.id,
    required this.profilePath,
    this.character,
  });
}
