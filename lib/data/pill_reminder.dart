class PillReminder {
  final int id;
  final String name;
  final String time;
  final String day;
  final bool isBeforeEat;

  const PillReminder({
    required this.id,
    required this.name,
    required this.time,
    required this.day,
    required this.isBeforeEat,
  });
}

class PillReminderList {
  static List<PillReminder> list() {
    const data = <PillReminder>[
      PillReminder(
          id: 1,
          name: 'Penvik Tablet',
          time: '09:00am, 01:30pm, 8:00pm',
          day: 'Everyday',
          isBeforeEat: true),
      PillReminder(
          id: 2,
          name: 'Capton 250mg',
          time: '8:00pm',
          day: 'Sun, Mon, Wed',
          isBeforeEat: false),
      PillReminder(
          id: 3,
          name: 'Gastin Pulse',
          time: '09:00am',
          day: 'Everyday',
          isBeforeEat: true),
      PillReminder(
          id: 4,
          name: 'Kapsorin 10mg',
          time: '09:00am, 01:30pm, 8:00pm',
          day: 'Everyday',
          isBeforeEat: false),
    ];
    return data;
  }
}
