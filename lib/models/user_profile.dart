class UserProfile {
  const UserProfile({
    required this.name,
    required this.schoolLine,
    required this.quote,
    required this.email,
    required this.role,
    required this.city,
    required this.vibe,
    required this.helpfulUpdates,
    required this.weekStreak,
    required this.goalDone,
    required this.goalTotal,
    required this.notificationsOn,
    required this.waitlistAlerts,
    required this.showLocation,
    required this.shareSpots,
  });

  factory UserProfile.demo() {
    return const UserProfile(
      name: 'Buyan',
      schoolLine: 'CS @ SJSU',
      quote: 'Good spaces, brighter days.',
      email: 'buyan@sjsu.edu',
      role: 'Student',
      city: 'San Jose, CA',
      vibe: 'INFP',
      helpfulUpdates: 18,
      weekStreak: 5,
      goalDone: 3,
      goalTotal: 5,
      notificationsOn: true,
      waitlistAlerts: true,
      showLocation: false,
      shareSpots: true,
    );
  }

  final String name;
  final String schoolLine;
  final String quote;
  final String email;
  final String role;
  final String city;
  final String vibe;
  final int helpfulUpdates;
  final int weekStreak;
  final int goalDone;
  final int goalTotal;
  final bool notificationsOn;
  final bool waitlistAlerts;
  final bool showLocation;
  final bool shareSpots;

  UserProfile copyWith({
    String? name,
    String? schoolLine,
    String? quote,
    String? email,
    String? role,
    String? city,
    String? vibe,
    int? helpfulUpdates,
    int? weekStreak,
    int? goalDone,
    int? goalTotal,
    bool? notificationsOn,
    bool? waitlistAlerts,
    bool? showLocation,
    bool? shareSpots,
  }) {
    return UserProfile(
      name: name ?? this.name,
      schoolLine: schoolLine ?? this.schoolLine,
      quote: quote ?? this.quote,
      email: email ?? this.email,
      role: role ?? this.role,
      city: city ?? this.city,
      vibe: vibe ?? this.vibe,
      helpfulUpdates: helpfulUpdates ?? this.helpfulUpdates,
      weekStreak: weekStreak ?? this.weekStreak,
      goalDone: goalDone ?? this.goalDone,
      goalTotal: goalTotal ?? this.goalTotal,
      notificationsOn: notificationsOn ?? this.notificationsOn,
      waitlistAlerts: waitlistAlerts ?? this.waitlistAlerts,
      showLocation: showLocation ?? this.showLocation,
      shareSpots: shareSpots ?? this.shareSpots,
    );
  }
}
