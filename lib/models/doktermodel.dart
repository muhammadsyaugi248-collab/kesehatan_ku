// lib/models/doktermodel.dart

import 'package:flutter/foundation.dart';

@immutable
class DoctorModel {
  final String id;
  final String name;
  final String specialization;
  final String location; // contoh: "Central Hospital, Jakarta"
  final double price; // Rp
  final double rating; // 0.0 - 5.0
  final String nextAvailable; // contoh: "Today, 2:00 PM"
  final int reviewsCount; // JUMLAH REVIEW

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.location,
    required this.price,
    required this.rating,
    required this.nextAvailable,
    required this.reviewsCount,
  });

  // ---------- fromJson / toJson (kalau nanti ambil dari API / Firestore) ----------

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      specialization: json['specialization'] as String,
      location: json['location'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      nextAvailable: json['nextAvailable'] as String,
      // kalau belum ada di DB, default 0 biar nggak error
      reviewsCount: (json['reviewsCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'location': location,
      'price': price,
      'rating': rating,
      'nextAvailable': nextAvailable,
      'reviewsCount': reviewsCount,
    };
  }

  DoctorModel copyWith({
    String? id,
    String? name,
    String? specialization,
    String? location,
    double? price,
    double? rating,
    String? nextAvailable,
    int? reviewsCount,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      specialization: specialization ?? this.specialization,
      location: location ?? this.location,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      nextAvailable: nextAvailable ?? this.nextAvailable,
      reviewsCount: reviewsCount ?? this.reviewsCount,
    );
  }
}

// ------------------ DUMMY DATA UNTUK DESAIN / TESTING ------------------

final List<DoctorModel> dummyDoctors = [
  DoctorModel(
    id: 'doc-001',
    name: 'Dr. Sarah Johnson',
    specialization: 'General Practitioner',
    location: 'Central Hospital, Jakarta',
    price: 150000,
    rating: 4.8,
    nextAvailable: 'Today, 2:00 PM',
    reviewsCount: 120,
  ),
  DoctorModel(
    id: 'doc-002',
    name: 'Dr. Michael Chen',
    specialization: 'Cardiologist',
    location: 'Heart Care Center, Jakarta',
    price: 300000,
    rating: 4.7,
    nextAvailable: 'Tomorrow, 10:00 AM',
    reviewsCount: 87,
  ),
  DoctorModel(
    id: 'doc-003',
    name: 'Dr. Lisa Putri',
    specialization: 'Psychologist',
    location: 'Mental Health Clinic, Bandung',
    price: 200000,
    rating: 4.9,
    nextAvailable: 'Today, 4:30 PM',
    reviewsCount: 210,
  ),
];
