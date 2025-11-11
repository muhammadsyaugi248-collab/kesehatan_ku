import 'package:flutter/material.dart';

// Class untuk merepresentasikan data seorang dokter
class DoctorModel {
  final String id;
  final String name;
  final String specialization;
  final String hospital;
  final String imageUrl;
  final double rating;
  final int reviews;
  final double price;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.hospital,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.price,
  });
}

// Data dummy untuk ditampilkan di daftar
final List<DoctorModel> dummyDoctors = [
  DoctorModel(
    id: 'd001',
    name: 'Dr. Arifin Sudiro, Sp.Jp',
    specialization: 'Jantung & Pembuluh Darah',
    hospital: 'RS Jantung Harapan Kita',
    imageUrl: 'https://placehold.co/100x100/1EC0C7/FFFFFF/png?text=A',
    rating: 4.8,
    reviews: 125,
    price: 150000,
  ),
  DoctorModel(
    id: 'd002',
    name: 'Dr. Karina Putri, Sp.PD',
    specialization: 'Penyakit Dalam',
    hospital: 'RS Umum Pusat Nasional',
    imageUrl: 'https://placehold.co/100x100/00A896/FFFFFF/png?text=K',
    rating: 4.9,
    reviews: 301,
    price: 120000,
  ),
  DoctorModel(
    id: 'd003',
    name: 'Dr. Bima Satria, Sp.A',
    specialization: 'Anak',
    hospital: 'Klinik Anak Ceria',
    imageUrl: 'https://placehold.co/100x100/F7346B/FFFFFF/png?text=B',
    rating: 4.7,
    reviews: 98,
    price: 180000,
  ),
];
