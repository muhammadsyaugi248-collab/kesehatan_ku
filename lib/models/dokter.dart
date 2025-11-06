class Doctor {
  final String name;
  final String specialization;
  final String location;
  final String hospital;
  final double fee;
  final int pointsReward;
  final String nextAvailable;

  Doctor({
    required this.name,
    required this.specialization,
    required this.location,
    required this.hospital,
    required this.fee,
    required this.pointsReward,
    required this.nextAvailable,
  });
}

final List<Doctor> dummyDoctors = [
  Doctor(
    name: 'Dr. Sarah Johnson',
    specialization: 'Practitioner',
    location: 'Jakarta',
    hospital: 'RS Columbia Hospital',
    fee: 150000.0,
    pointsReward: 300,
    nextAvailable: 'Today, 2:00 PM',
  ),
  Doctor(
    name: 'Dr. John Chen',
    specialization: 'Dentist',
    location: 'Jakarta',
    hospital: 'Klinik Utama Sentosa',
    fee: 120000.0,
    pointsReward: 200,
    nextAvailable: 'Tomorrow, 10:00 AM',
  ),
  Doctor(
    name: 'Dr. Anya Sharma',
    specialization: 'Cardiologist',
    location: 'Jakarta',
    hospital: 'Jaya Clinic',
    fee: 200000.0,
    pointsReward: 400,
    nextAvailable: 'Nov 2, 3:00 PM',
  ),
];
