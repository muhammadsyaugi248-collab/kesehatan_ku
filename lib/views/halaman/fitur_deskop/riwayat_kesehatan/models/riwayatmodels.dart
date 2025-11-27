class Diagnosis {
  final String name; // contoh: "Hipertensi"
  final bool isChronic; // penyakit kronis atau tidak

  const Diagnosis({required this.name, this.isChronic = false});
}

class Medication {
  final String name; // contoh: "Amlodipine 5 mg"
  final String dosage; // contoh: "1 tablet"
  final String frequency; // contoh: "1x sehari setelah makan"

  const Medication({
    required this.name,
    required this.dosage,
    required this.frequency,
  });
}

class CheckupRecord {
  final String title; // contoh: "Check-up"
  final DateTime date;
  final String doctorName;
  final String summary; // ringkasan singkat
  final bool isNormal; // true = semua normal, false = ada temuan
  final List<Diagnosis> diagnoses;
  final List<Medication> medications;
  final List<String> advices;

  const CheckupRecord({
    required this.title,
    required this.date,
    required this.doctorName,
    required this.summary,
    required this.isNormal,
    required this.diagnoses,
    required this.medications,
    required this.advices,
  });
}
