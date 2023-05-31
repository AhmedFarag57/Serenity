class EmergencyCategory {
  final int id;
  final String name;
  final String image;

  const EmergencyCategory(
      {required this.id, required this.name, required this.image});
}

class EmergencyCategoryList {
  static List<EmergencyCategory> list() {
    const data = <EmergencyCategory>[
      EmergencyCategory(
          id: 1,
          name: 'Doctor',
          image: 'assets/images/emergency_category/3.png'),
      /*
      EmergencyCategory(
          id: 2,
          name: 'Ambulance',
          image: 'assets/images/emergency_category/2.png'
      ),
      EmergencyCategory(
          id: 4,
          name: 'Health Care',
          image: 'assets/images/emergency_category/4.png'
      ),
      EmergencyCategory(
        id: 1,
        name: 'Hospital',
        image: 'assets/images/emergency_category/1.png'
      ),
      */
    ];
    return data;
  }
}
