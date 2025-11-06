import 'package:intl/intl.dart';

class BookingModel {
  final int? id;
  final String doctorName;
  final String specialty;
  final DateTime dateTime;
  final double price;
  final int points;
  final bool isActive;
  final bool isCancelled;
  final bool isCompleted;
  final bool hasRated;

  BookingModel({
    this.id,
    required this.doctorName,
    required this.specialty,
    required this.dateTime,
    required this.price,
    required this.points,
    this.isActive = true,
    this.isCancelled = false,
    this.isCompleted = false,
    this.hasRated = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doctorName': doctorName,
      'specialty': specialty,
      // 🧠 Simpan tanggal sebagai teks dengan intl
      'dateTime': DateFormat('yyyy-MM-dd HH:mm').format(dateTime),
      'price': price,
      'points': points,
      'isActive': isActive ? 1 : 0,
      'isCancelled': isCancelled ? 1 : 0,
      'isCompleted': isCompleted ? 1 : 0,
      'hasRated': hasRated ? 1 : 0,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'],
      doctorName: map['doctorName'],
      specialty: map['specialty'],
      dateTime: DateFormat('yyyy-MM-dd HH:mm').parse(map['dateTime']),
      price: map['price'],
      points: map['points'],
      isActive: map['isActive'] == 1,
      isCancelled: map['isCancelled'] == 1,
      isCompleted: map['isCompleted'] == 1,
      hasRated: map['hasRated'] == 1,
    );
  }
}
