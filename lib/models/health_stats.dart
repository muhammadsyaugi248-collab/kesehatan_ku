/// Model untuk menyimpan vital stats yang disimpan di Firestore
/// dan juga dipakai di tampilan profil / goals.
class HealthStats {
  final double weightKg;
  final double heightCm;
  final int systolic;
  final int diastolic;
  final double glucose; // mg/dL
  final double uricAcid; // mg/dL
  final double hdl; // kolesterol baik
  final double ldl; // kolesterol jahat

  HealthStats({
    required this.weightKg,
    required this.heightCm,
    required this.systolic,
    required this.diastolic,
    required this.glucose,
    required this.uricAcid,
    required this.hdl,
    required this.ldl,
  });

  /// total kolesterol = HDL + LDL (versi simple buat tampilan)
  double get totalCholesterol => hdl + ldl;

  /// BMI (Indeks Massa Tubuh)
  double? get bmi {
    if (weightKg <= 0 || heightCm <= 0) return null;
    final hM = heightCm / 100.0;
    return weightKg / (hM * hM);
  }

  Map<String, dynamic> toMap() {
    return {
      'weightKg': weightKg,
      'heightCm': heightCm,
      'systolic': systolic,
      'diastolic': diastolic,
      'glucose': glucose,
      'uricAcid': uricAcid,
      'hdl': hdl,
      'ldl': ldl,
      'totalCholesterol': totalCholesterol,
    };
  }

  factory HealthStats.fromMap(Map<String, dynamic> map) {
    double d(dynamic v) => (v ?? 0).toDouble();

    return HealthStats(
      weightKg: d(map['weightKg']),
      heightCm: d(map['heightCm']),
      systolic: (map['systolic'] ?? 0) as int,
      diastolic: (map['diastolic'] ?? 0) as int,
      glucose: d(map['glucose']),
      uricAcid: d(map['uricAcid']),
      hdl: d(map['hdl']),
      ldl: d(map['ldl']),
    );
  }
}
