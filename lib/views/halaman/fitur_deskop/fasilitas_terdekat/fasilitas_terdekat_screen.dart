import 'package:flutter/material.dart';

// ====== WARNA TEMA ======
const Color _pageBackground = Color.fromARGB(255, 201, 231, 226);
const Color _textDark = Color(0xFF1F2937);
const Color _textGrey = Color(0xFF6B7280);

// Biru lembut untuk fasilitas (nggak terlalu ngejreng)
const Color _facilityBlue = Color(0xFF4F8DFD);
const Color _facilityBlueSoft = Color(0xFF6FA9FF);

// ====== MODEL DATA FASILITAS ======
class Facility {
  final String name;
  final String type; // Hospital / Clinic / Pharmacy
  final String distance; // misal: "1.2 km away"
  final String statusLabel; // "Open 24/7", "Open until 9 PM", dst
  final Color statusColor; // warna background pill status
  final IconData icon; // icon kategori

  const Facility({
    required this.name,
    required this.type,
    required this.distance,
    required this.statusLabel,
    required this.statusColor,
    required this.icon,
  });
}

// Dummy data
const List<Facility> _dummyFacilities = [
  Facility(
    name: 'Central Hospital',
    type: 'Hospital',
    distance: '1.2 km away',
    statusLabel: 'Open 24/7',
    statusColor: Color(0xFF22C55E),
    icon: Icons.local_hospital,
  ),
  Facility(
    name: 'City Clinic',
    type: 'Clinic',
    distance: '0.8 km away',
    statusLabel: 'Open until 9 PM',
    statusColor: Color(0xFFF97316),
    icon: Icons.local_hospital_outlined,
  ),
  Facility(
    name: 'Wellness Pharmacy',
    type: 'Pharmacy',
    distance: '0.5 km away',
    statusLabel: 'Open now',
    statusColor: Color(0xFF22C55E),
    icon: Icons.local_pharmacy,
  ),
];

class FasilitasTerdekatScreen extends StatelessWidget {
  const FasilitasTerdekatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====== Back to Dashboard ======
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.arrow_back, size: 24, color: _textDark),
                      SizedBox(width: 6),
                      Text(
                        'Back to Dashboard',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ====== Judul & Subjudul ======
              const Text(
                'Fasilitas Terdekat',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Find nearby healthcare facilities',
                style: TextStyle(fontSize: 14, color: _textGrey),
              ),
              const SizedBox(height: 20),

              // ====== Find Facilities Card ======
              const _FindFacilitiesCard(),
              const SizedBox(height: 20),

              const Text(
                'Nearby Facilities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 12),

              // ====== List Fasilitas ======
              Column(
                children: _dummyFacilities
                    .map(
                      (f) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _FacilityCard(facility: f),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================== KARTU FIND FACILITIES ==================
class _FindFacilitiesCard extends StatelessWidget {
  const _FindFacilitiesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [_facilityBlue, _facilityBlueSoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find Facilities',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Based on your location',
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.place_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

// ================== KARTU FASILITAS ==================
class _FacilityCard extends StatelessWidget {
  final Facility facility;

  const _FacilityCard({required this.facility});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ROW: icon + info + status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _pageBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(facility.icon, color: _facilityBlue, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      facility.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${facility.type} • ${facility.distance}',
                      style: const TextStyle(fontSize: 12, color: _textGrey),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: facility.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 10, color: facility.statusColor),
                    const SizedBox(width: 4),
                    Text(
                      facility.statusLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: facility.statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ROW: tombol Directions & Call
          Row(
            children: [
              // Directions
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Membuka rute ke ${facility.name}...'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.directions, size: 18),
                    label: const Text('Directions'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _facilityBlue,
                      side: const BorderSide(color: _facilityBlue),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Call
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Menghubungi ${facility.name}...'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.call, size: 18),
                    label: const Text('Call'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _textDark,
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: const Color(0xFFF9FAFB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
