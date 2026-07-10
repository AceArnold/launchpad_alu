class Opportunity {
  final String opportunityId;
  final String startupId;
  final String startupName;
  final String title;
  final String description;
  final String category;
  final String location;
  final DateTime createdAt;
  final bool isOpen;

  Opportunity({
    required this.opportunityId,
    required this.startupId,
    required this.startupName,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.createdAt,
    required this.isOpen,
  });

  Map<String, dynamic> toMap() {
    return {
      'startupId': startupId,
      'startupName': startupName,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'createdAt': createdAt,
      'isOpen': isOpen,
    };
  }

  factory Opportunity.fromMap(String id, Map<String, dynamic> map) {
    return Opportunity(
      opportunityId: id,
      startupId: map['startupId'] ?? '',
      startupName: map['startupName'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      location: map['location'] ?? '',
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      isOpen: map['isOpen'] ?? true,
    );
  }
}