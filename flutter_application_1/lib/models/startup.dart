class Startup {
  final String startupId;
  final String ownerUid;
  final String name;
  final String description;
  final String category;
  final bool isVerified;
  final DateTime createdAt;

  Startup({
    required this.startupId,
    required this.ownerUid,
    required this.name,
    required this.description,
    required this.category,
    required this.isVerified,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'ownerUid': ownerUid,
      'name': name,
      'description': description,
      'category': category,
      'isVerified': isVerified,
      'createdAt': createdAt,
    };
  }

  factory Startup.fromMap(String id, Map<String, dynamic> map) {
    return Startup(
      startupId: id,
      ownerUid: map['ownerUid'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      isVerified: map['isVerified'] ?? false,
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
    );
  }
}