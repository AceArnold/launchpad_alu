class Application {
  final String applicationId;
  final String opportunityId;
  final String opportunityTitle;
  final String studentUid;
  final String studentName;
  final String startupId;
  final String status; // "pending" | "accepted" | "rejected"
  final DateTime appliedAt;

  Application({
    required this.applicationId,
    required this.opportunityId,
    required this.opportunityTitle,
    required this.studentUid,
    required this.studentName,
    required this.startupId,
    required this.status,
    required this.appliedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'opportunityId': opportunityId,
      'opportunityTitle': opportunityTitle,
      'studentUid': studentUid,
      'studentName': studentName,
      'startupId': startupId,
      'status': status,
      'appliedAt': appliedAt,
    };
  }

  factory Application.fromMap(String id, Map<String, dynamic> map) {
    return Application(
      applicationId: id,
      opportunityId: map['opportunityId'] ?? '',
      opportunityTitle: map['opportunityTitle'] ?? '',
      studentUid: map['studentUid'] ?? '',
      studentName: map['studentName'] ?? '',
      startupId: map['startupId'] ?? '',
      status: map['status'] ?? 'pending',
      appliedAt: map['appliedAt']?.toDate() ?? DateTime.now(),
    );
  }
}