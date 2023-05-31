class Doctor {
  final int id;
  final String name;
  final String image;
  final String specialist;
  final String available;
  final String address;
  final String rating;

  const Doctor(
      {required this.id,
      required this.name,
      required this.image,
      required this.specialist,
      required this.available,
      required this.address,
      required this.rating});
}

class DoctorList {
  static List<Doctor> list() {
    const data = <Doctor>[
      Doctor(
          id: 1,
          name: 'Dr. Tomas Khushiya',
          image: 'assets/images/nearby/1.png',
          specialist: 'Liver Specialist',
          available: '12:00pm - 03:00pm',
          address: 'Regent Hospital',
          rating: '5'),
      Doctor(
          id: 2,
          name: 'Dr. Zecop Winner',
          image: 'assets/images/nearby/2.png',
          specialist: 'Gynecologists',
          available: '05:00pm - 08:00pm',
          address: 'Modern Hospital',
          rating: '5'),
      Doctor(
          id: 3,
          name: 'Dr. Jabed Patowari',
          image: 'assets/images/nearby/3.png',
          specialist: 'Medicine Specialist',
          available: '12:00pm - 03:00pm',
          address: 'Regent Hospital',
          rating: '5'),
      Doctor(
          id: 4,
          name: 'Dr. Toma Mirza',
          image: 'assets/images/nearby/4.png',
          specialist: 'Gynecologists',
          available: '05:00pm - 08:00pm',
          address: 'Modern Hospital',
          rating: '5'),
    ];
    return data;
  }
}
