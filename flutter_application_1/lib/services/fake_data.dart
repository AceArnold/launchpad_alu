import '../models/application.dart';
import '../models/opportunity.dart';
import '../models/startup.dart';

class FakeData {
  static List<Opportunity> opportunities = [
    Opportunity(
      opportunityId: '1',
      startupId: 'startup1',
      startupName: 'TechNova',
      title: 'Frontend Developer Intern',
      description: 'Help us build our new student dashboard using Flutter. Great for someone learning mobile dev.',
      category: 'Software Engineering',
      location: 'Kigali, Remote-friendly',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isOpen: true,
    ),
    Opportunity(
      opportunityId: '2',
      startupId: 'startup2',
      startupName: 'GreenHarvest',
      title: 'Marketing Assistant',
      description: 'Support our social media campaigns and help grow our sustainable agriculture brand.',
      category: 'Marketing',
      location: 'Kigali',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isOpen: true,
    ),
    Opportunity(
      opportunityId: '3',
      startupId: 'startup3',
      startupName: 'FinLink',
      title: 'Data Analysis Intern',
      description: 'Work with our team analyzing financial transaction data to improve our lending model.',
      category: 'Data Science',
      location: 'Remote',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isOpen: true,
    ),
  ];

  static List<Application> applications = [
    Application(
      applicationId: 'app1',
      opportunityId: '1',
      opportunityTitle: 'Frontend Developer Intern',
      studentUid: 'student1',
      studentName: 'Aline',
      startupId: 'startup1',
      status: 'pending',
      appliedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Application(
      applicationId: 'app2',
      opportunityId: '2',
      opportunityTitle: 'Marketing Assistant',
      studentUid: 'student1',
      studentName: 'Aline',
      startupId: 'startup2',
      status: 'accepted',
      appliedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];


// add inside the FakeData class
static Startup myStartup = Startup(
  startupId: 'startup1',
  ownerUid: 'startup1',
  name: 'TechNova',
  description: 'We build student-focused productivity tools.',
  category: 'Software Engineering',
  isVerified: true,
  createdAt: DateTime.now().subtract(const Duration(days: 30)),
);

  // list of applicants for "my" opportunities
  static List<Application> myApplicants = [
    Application(
      applicationId: 'a1',
      opportunityId: '1',
      opportunityTitle: 'Frontend Developer Intern',
      studentUid: 'student1',
      studentName: 'Aline Uwase',
      startupId: 'startup1',
      status: 'pending',
      appliedAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    Application(
      applicationId: 'a2',
      opportunityId: '1',
      opportunityTitle: 'Frontend Developer Intern',
      studentUid: 'student2',
      studentName: 'Eric Niyonzima',
      startupId: 'startup1',
      status: 'pending',
      appliedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

}
