import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/opportunity.dart';
import '../models/application.dart';
import '../models/startup.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ---------- OPPORTUNITIES ----------

  /// Real-time stream of all open opportunities, newest first.
  /// Used by the Student Discover feed.
  Stream<List<Opportunity>> streamAllOpportunities() {
    return _db
        .collection('opportunities')
        .where('isOpen', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Opportunity.fromMap(doc.id, doc.data())).toList());
  }

  /// Real-time stream of opportunities posted by one specific startup.
  /// Used by the Startup Home dashboard.
  Stream<List<Opportunity>> streamMyOpportunities(String startupId) {
    return _db
        .collection('opportunities')
        .where('startupId', isEqualTo: startupId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Opportunity.fromMap(doc.id, doc.data())).toList());
  }

  Future<void> postOpportunity(Opportunity opportunity) async {
    await _db.collection('opportunities').add(opportunity.toMap());
  }

  Future<void> deleteOpportunity(String opportunityId) async {
    await _db.collection('opportunities').doc(opportunityId).delete();
  }

  Future<void> toggleOpportunityStatus(String opportunityId, bool isOpen) async {
    await _db.collection('opportunities').doc(opportunityId).update({'isOpen': isOpen});
  }

  // ---------- STARTUP PROFILE ----------

  Future<Startup?> getStartup(String startupId) async {
    final doc = await _db.collection('startups').doc(startupId).get();
    if (!doc.exists) return null;
    return Startup.fromMap(doc.id, doc.data()!);
  }

  Stream<Startup?> streamStartup(String startupId) {
    return _db.collection('startups').doc(startupId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return Startup.fromMap(doc.id, doc.data()!);
    });
  }

  Future<void> updateStartupProfile(String startupId, String name, String description) async {
    await _db.collection('startups').doc(startupId).update({
      'name': name,
      'description': description,
    });
  }

  // ---------- APPLICATIONS ----------

  Future<void> applyToOpportunity(Application application) async {
    await _db.collection('applications').add(application.toMap());
  }

  /// Applications submitted BY one student — used by My Applications screen.
  Stream<List<Application>> streamMyApplications(String studentUid) {
    return _db
        .collection('applications')
        .where('studentUid', isEqualTo: studentUid)
        .orderBy('appliedAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Application.fromMap(doc.id, doc.data())).toList());
  }

  /// Applications received BY one startup — used by Applicants screen.
  Stream<List<Application>> streamApplicantsForStartup(String startupId) {
    return _db
        .collection('applications')
        .where('startupId', isEqualTo: startupId)
        .orderBy('appliedAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Application.fromMap(doc.id, doc.data())).toList());
  }

  Future<void> updateApplicationStatus(String applicationId, String status) async {
    await _db.collection('applications').doc(applicationId).update({'status': status});
  }

  /// Checks if a student has already applied to a specific opportunity —
  /// prevents duplicate applications.
  Future<bool> hasAlreadyApplied(String studentUid, String opportunityId) async {
    final query = await _db
        .collection('applications')
        .where('studentUid', isEqualTo: studentUid)
        .where('opportunityId', isEqualTo: opportunityId)
        .limit(1)
        .get();
    return query.docs.isNotEmpty;
  }
}