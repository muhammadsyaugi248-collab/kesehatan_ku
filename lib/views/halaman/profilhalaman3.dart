// import 'package:flutter/material.dart';

// void main() {
//   runApp(const KesehatanKuApp());
// }

// class KesehatanKuApp extends StatelessWidget {
//   const KesehatanKuApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'KesehatanKu',
//       theme: ThemeData(
//         primarySwatch: Colors.teal,
//         fontFamily: 'Inter',
//         scaffoldBackgroundColor: const Color(
//           0xFFF0F2F5,
//         ), // Latar belakang abu-abu sangat muda
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           foregroundColor: Colors.black,
//         ),
//       ),
//       home: const ProfileScreen(),
//     );
//   }
// }

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Profile',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//         ),
//         centerTitle: false,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings_outlined, color: Color(0xFF526D82)),
//             onPressed: () {
//               _showSnackBar(context, 'Pengaturan dibuka!');
//             },
//           ),
//           const SizedBox(width: 8),
//         ],
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(kToolbarHeight - 10),
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: TabBar(
//               controller: _tabController,
//               isScrollable: true,
//               labelColor: const Color(0xFF0D9488), // Warna teks tab aktif
//               unselectedLabelColor: Colors.grey.shade600,
//               indicatorColor: const Color(
//                 0xFF0D9488,
//               ), // Warna indikator tab aktif
//               indicatorWeight: 3.0,
//               labelStyle: const TextStyle(fontWeight: FontWeight.bold),
//               tabs: const [
//                 Tab(text: 'Info'),
//                 Tab(text: 'Health'),
//                 Tab(text: 'Goals'),
//                 Tab(text: 'Awards'),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: const [InfoTab(), HealthTab(), GoalsTab(), AwardsTab()],
//       ),
//     );
//   }
// }

// // =========================================================================
// // WIDGET UTAMA (MAIN TABS)
// // =========================================================================

// class InfoTab extends StatelessWidget {
//   const InfoTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const ProfileInfoSection(),
//           const SizedBox(height: 20),
//           const PersonalInformationCard(),
//           const SizedBox(height: 20),
//           const PrivacySecurityCard(),
//           const SizedBox(height: 20),
//           const RecentActivityLogCard(),
//         ],
//       ),
//     );
//   }
// }

// class HealthTab extends StatelessWidget {
//   const HealthTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const MedicalConditionsCard(),
//           const SizedBox(height: 20),
//           const AllergiesCard(),
//           const SizedBox(height: 20),
//           const DoctorsRecommendationsCard(),
//           const SizedBox(height: 20),
//           _CustomCard(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.lightbulb_outline,
//                       color: Colors.purple.shade300,
//                       size: 24,
//                     ),
//                     const SizedBox(width: 8),
//                     // Menggunakan Expanded untuk memastikan teks judul menyesuaikan
//                     Expanded(
//                       child: Text(
//                         'AI Health Insight',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey.shade800,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   // Text dalam Column akan wrap secara default, tidak perlu Expanded
//                   'Your sleep duration decreased by 30 minutes this week. Try going to bed 30 minutes earlier tonight for better rest and recovery.',
//                   style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//                 ),
//               ],
//             ),
//             backgroundColor: Colors.purple.shade50,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class GoalsTab extends StatelessWidget {
//   const GoalsTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _CustomCard(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.adjust_outlined,
//                       color: Colors.teal.shade600,
//                       size: 24,
//                     ),
//                     const SizedBox(width: 8),
//                     const Text(
//                       'Active Goals',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF1E293B), // Teks gelap
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 15),
//                 const _GoalProgress(
//                   title: 'Weight Loss',
//                   current: 72,
//                   target: 68,
//                   unit: 'kg',
//                   progress: 0.66,
//                 ),
//                 const SizedBox(height: 15),
//                 const _GoalProgress(
//                   title: 'Sleep Duration',
//                   current: 7.5,
//                   target: 8,
//                   unit: 'hours',
//                   progress: 0.94,
//                 ),
//                 const SizedBox(height: 15),
//                 const _GoalProgress(
//                   title: 'Monthly Checkups',
//                   current: 2,
//                   target: 2,
//                   unit: 'visits',
//                   progress: 1.0,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           _CustomCard(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'This Week vs Last Week',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.grey.shade800,
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 const _ComparisonRow(
//                   icon: Icons.directions_walk_outlined,
//                   label: 'Avg Steps',
//                   value: '8,234',
//                   change: '+12%',
//                   changeColor: Colors.green,
//                 ),
//                 const SizedBox(height: 10),
//                 const _ComparisonRow(
//                   icon: Icons.dark_mode_outlined,
//                   label: 'Avg Sleep',
//                   value: '7.5h',
//                   change: '-6%',
//                   changeColor: Colors.red,
//                 ),
//                 const SizedBox(height: 10),
//                 const _ComparisonRow(
//                   icon: Icons.favorite_border_outlined,
//                   label: 'Avg Heart Rate',
//                   value: '72 bpm',
//                   change: 'Stable',
//                   changeColor: Colors.grey,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AwardsTab extends StatelessWidget {
//   const AwardsTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _CustomCard(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.emoji_events_outlined,
//                       color: Colors.amber.shade600,
//                       size: 24,
//                     ),
//                     const SizedBox(width: 8),
//                     const Text(
//                       'Achievements',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF1E293B), // Teks gelap
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 15),
//                 GridView.count(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                   childAspectRatio: 1.2,
//                   children: const [
//                     _AwardTile(
//                       icon: Icons.emoji_events_outlined,
//                       title: '12 Checkups Complete',
//                       color: Color(0xFFFEF9C3), // Yellow 100
//                       iconColor: Color(0xFFFACC15), // Yellow 500
//                     ),
//                     _AwardTile(
//                       icon: Icons.bedtime_outlined,
//                       title: '7 Days Good Sleep',
//                       color: Color(0xFFFEE2E2), // Red 100 (soft pink)
//                       iconColor: Color(0xFFEF4444), // Red 500
//                     ),
//                     _AwardTile(
//                       icon: Icons.lock_open_outlined,
//                       title: '10K Steps Streak',
//                       color: Color(0xFFDBEAFE), // Blue 100
//                       iconColor: Color(0xFF3B82F6), // Blue 500
//                     ),
//                     _AwardTile(
//                       icon: Icons.balance_outlined,
//                       title: 'Healthy Weight',
//                       color: Color(0xFFDCFCE7), // Green 100
//                       iconColor: Color(0xFF22C55E), // Green 500
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           _CustomCard(
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.emoji_events_outlined,
//                   color: Colors.teal.shade500,
//                   size: 30,
//                 ),
//                 const SizedBox(width: 15),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Great Progress!',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey.shade800,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         // Text dalam Column sudah aman untuk wrap
//                         'You\'ve unlocked 3 out of 4 achievements. Keep up the good work!',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             backgroundColor: const Color(0xFFECFDF5), // Green 50
//             borderColor: const Color(0xFF34D399), // Green 400
//           ),
//         ],
//       ),
//     );
//   }
// }

// // =========================================================================
// // WIDGET KECIL & KOMPONEN (REUSABLE)
// // =========================================================================

// // Widget Kartu Kustom dengan Bayangan dan Sudut Membulat
// class _CustomCard extends StatelessWidget {
//   final Widget child;
//   final Color backgroundColor;
//   final Color? borderColor;
//   final double padding;

//   const _CustomCard({
//     required this.child,
//     this.backgroundColor = Colors.white,
//     this.borderColor,
//     this.padding = 16.0,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(padding),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(16.0),
//         border: borderColor != null
//             ? Border.all(color: borderColor!, width: 1.5)
//             : null,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.08),
//             spreadRadius: 0,
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
// }

// // === Info Tab Widgets ===
// class ProfileInfoSection extends StatelessWidget {
//   const ProfileInfoSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return _CustomCard(
//       child: Column(
//         children: [
//           Stack(
//             alignment: Alignment.center,
//             children: [
//               Container(
//                 width: double.infinity,
//                 height: 120,
//                 decoration: BoxDecoration(
//                   color: const Color(
//                     0xFF67E8F9,
//                   ), // Warna background teal terang
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               Positioned(
//                 top: 60, // Setengah dari tinggi background + radius avatar
//                 child: Container(
//                   width: 100,
//                   height: 100,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.white, width: 4),
//                   ),
//                   child: const CircleAvatar(
//                     radius: 46,
//                     backgroundColor: Color(0xFFE0F2F7), // Background avatar
//                     // Menggunakan placeholder untuk gambar asset
//                     child: Text(
//                       'AR', // Inisial jika tidak ada gambar
//                       style: TextStyle(fontSize: 36, color: Colors.teal),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 60), // Space for avatar below background
//           Text(
//             'Ahmad Ridwan',
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey.shade800,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             'ahmad.ridwan@example.com',
//             style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//           ),
//           const SizedBox(height: 8),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF0FDF4), // Green 50
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(
//                 color: const Color(0xFF34D399),
//                 width: 1,
//               ), // Green 400
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   Icons.schedule_outlined,
//                   size: 16,
//                   color: Colors.grey.shade600,
//                 ),
//                 const SizedBox(width: 6),
//                 const Text(
//                   'Member since January 2024',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Color(0xFF374151),
//                   ), // Teks lebih gelap agar terbaca
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton.icon(
//               icon: const Icon(Icons.edit_outlined, size: 20),
//               label: const Text('Edit Profile', style: TextStyle(fontSize: 16)),
//               onPressed: () => _showSnackBar(context, 'Edit Profile ditekan!'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF2DD4BF), // Teal 400
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           // Health stats grid
//           GridView.count(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             crossAxisCount: 2,
//             childAspectRatio: 1.3,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             children: const [
//               _HealthStatTile(
//                 icon: Icons.show_chart,
//                 label: 'Checkups',
//                 value: '12',
//                 subtitle: '+2 this month',
//                 iconColor: Color(0xFF06B6D4), // Cyan 600
//                 backgroundColor: Color(0xFFECFDFF), // Cyan 50
//               ),
//               _HealthStatTile(
//                 icon: Icons.favorite_border,
//                 label: 'Heart Rate',
//                 value: '72 bpm',
//                 subtitle: 'Normal',
//                 iconColor: Color(0xFFEF4444), // Red 500
//                 backgroundColor: Color(0xFFFEF2F2), // Red 50
//               ),
//               _HealthStatTile(
//                 icon: Icons.dark_mode_outlined,
//                 label: 'Sleep',
//                 value: '7.5h',
//                 subtitle: '-0.5h from last week',
//                 iconColor: Color(0xFF6366F1), // Indigo 500
//                 backgroundColor: Color(0xFFEEF2FF), // Indigo 50
//               ),
//               _HealthStatTile(
//                 icon: Icons.directions_run_outlined,
//                 label: 'Steps Today',
//                 value: '8,234',
//                 subtitle: 'Goal: 10,000',
//                 iconColor: Color(0xFFF59E0B), // Amber 500
//                 backgroundColor: Color(0xFFFFFBEB), // Amber 50
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _HealthStatTile extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//   final String subtitle;
//   final Color iconColor;
//   final Color backgroundColor;

//   const _HealthStatTile({
//     required this.icon,
//     required this.label,
//     required this.value,
//     required this.subtitle,
//     required this.iconColor,
//     required this.backgroundColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.05),
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: backgroundColor,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(icon, color: iconColor, size: 24),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey.shade800,
//             ),
//           ),
//           Text(
//             subtitle,
//             style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class PersonalInformationCard extends StatelessWidget {
//   const PersonalInformationCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return _CustomCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Personal Information',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey.shade800,
//             ),
//           ),
//           const SizedBox(height: 15),
//           const _InfoRow(
//             icon: Icons.calendar_today_outlined,
//             label: 'Age',
//             value: '34 years',
//           ),
//           const Divider(height: 25, color: Color(0xFFE2E8F0)),
//           const _InfoRow(
//             icon: Icons.bloodtype_outlined,
//             label: 'Blood Type',
//             value: 'O+',
//           ),
//           const Divider(height: 25, color: Color(0xFFE2E8F0)),
//           const _InfoRow(
//             icon: Icons.height_outlined,
//             label: 'Height',
//             value: '175 cm',
//           ),
//           const Divider(height: 25, color: Color(0xFFE2E8F0)),
//           const _InfoRow(
//             icon: Icons.monitor_weight_outlined,
//             label: 'Weight',
//             value: '72 kg',
//           ),
//           const Divider(height: 25, color: Color(0xFFE2E8F0)),
//           const _InfoRow(
//             icon: Icons.calculate_outlined,
//             label: 'BMI',
//             value: '23.5',
//             valueWidget: _StatusChip(
//               text: 'Normal',
//               color: Color(0xFFD1FAE5),
//               textColor: Color(0xFF065F46),
//             ),
//           ),
//           const Divider(height: 25, color: Color(0xFFE2E8F0)),
//           const _InfoRow(
//             icon: Icons.medical_services_outlined,
//             label: 'Last Checkup',
//             value: 'Nov 10, 2025',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _InfoRow extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String? value;
//   final Widget? valueWidget;

//   const _InfoRow({
//     required this.icon,
//     required this.label,
//     this.value,
//     this.valueWidget,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(icon, color: Colors.grey.shade500, size: 20),
//         const SizedBox(width: 10),
//         // Menggunakan Flexible untuk label agar memiliki ruang untuk value/chip
//         Flexible(
//           child: Text(
//             label,
//             style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
//           ),
//         ),
//         const Spacer(),
//         if (valueWidget != null)
//           valueWidget!
//         else if (value != null)
//           Text(
//             value!,
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey.shade800,
//             ),
//           ),
//       ],
//     );
//   }
// }

// class _StatusChip extends StatelessWidget {
//   final String text;
//   final Color color;
//   final Color textColor;

//   const _StatusChip({
//     required this.text,
//     required this.color,
//     required this.textColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 12,
//           color: textColor,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
// }

// class PrivacySecurityCard extends StatefulWidget {
//   const PrivacySecurityCard({super.key});

//   @override
//   State<PrivacySecurityCard> createState() => _PrivacySecurityCardState();
// }

// class _PrivacySecurityCardState extends State<PrivacySecurityCard> {
//   bool showSensitiveData = false;
//   bool doctorOnlyAccess = false;

//   @override
//   Widget build(BuildContext context) {
//     return _CustomCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Privacy & Security',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey.shade800,
//             ),
//           ),
//           const SizedBox(height: 15),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: const Color(0xFFECFDF5), // Green 50
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                 color: const Color(0xFF34D399),
//                 width: 1,
//               ), // Green 400
//             ),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.security_outlined,
//                   color: Colors.teal.shade500,
//                   size: 24,
//                 ),
//                 const SizedBox(width: 10),
//                 Icon(
//                   Icons.lock_outlined,
//                   color: Colors.orange.shade400,
//                   size: 20,
//                 ),
//                 const SizedBox(width: 5),
//                 // Menggunakan Expanded untuk memastikan teks notifikasi tidak overflow
//                 Expanded(
//                   child: Text(
//                     'Your data is safe and encrypted',
//                     style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 15),
//           _ToggleRow(
//             icon: Icons.visibility_outlined,
//             label: 'Show Sensitive Data',
//             description: 'Display medical conditions & allergies',
//             value: showSensitiveData,
//             onChanged: (bool value) {
//               setState(() {
//                 showSensitiveData = value;
//               });
//               _showSnackBar(context, 'Show Sensitive Data: $value');
//             },
//           ),
//           const Divider(height: 25, color: Color(0xFFE2E8F0)),
//           _ToggleRow(
//             icon: Icons.local_hospital_outlined,
//             label: 'Doctor-Only Access',
//             description: 'Limit data visibility to doctors only',
//             value: doctorOnlyAccess,
//             onChanged: (bool value) {
//               setState(() {
//                 doctorOnlyAccess = value;
//               });
//               _showSnackBar(context, 'Doctor-Only Access: $value');
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ToggleRow extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String description;
//   final bool value;
//   final ValueChanged<bool> onChanged;

//   const _ToggleRow({
//     required this.icon,
//     required this.label,
//     required this.description,
//     required this.value,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(icon, color: Colors.grey.shade500, size: 20),
//         const SizedBox(width: 10),
//         Expanded(
//           // Text di dalam Expanded akan wrap, aman dari overflow
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
//               ),
//               Text(
//                 description,
//                 style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
//               ),
//             ],
//           ),
//         ),
//         Switch(
//           value: value,
//           onChanged: onChanged,
//           activeColor: const Color(0xFF10B981), // Green 500
//         ),
//       ],
//     );
//   }
// }

// class RecentActivityLogCard extends StatelessWidget {
//   const RecentActivityLogCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return _CustomCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Recent Activity Log',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey.shade800,
//             ),
//           ),
//           const SizedBox(height: 15),
//           const _ActivityLogItem(
//             title: 'Profile updated',
//             subtitle: 'By: You',
//             time: '2 hours ago',
//           ),
//           const Divider(height: 25, color: Color(0xFFE2E8F0)),
//           const _ActivityLogItem(
//             title: 'Blood pressure measured',
//             subtitle: 'By: Dr. Sarah Johnson',
//             time: '1 day ago',
//           ),
//           const Divider(height: 25, color: Color(0xFFE2E8F0)),
//           const _ActivityLogItem(
//             title: 'Medical record accessed',
//             subtitle: 'By: Dr. Sarah Johnson',
//             time: '3 days ago',
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ActivityLogItem extends StatelessWidget {
//   final String title;
//   final String subtitle;
//   final String time;

//   const _ActivityLogItem({
//     required this.title,
//     required this.subtitle,
//     required this.time,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           // Kolom judul dan subjudul mendapatkan semua ruang yang tersedia
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey.shade700,
//                 ),
//               ),
//               Text(
//                 subtitle,
//                 style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
//               ),
//             ],
//           ),
//         ),
//         Text(time, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
//       ],
//     );
//   }
// }

// // === Health Tab Widgets ===

// class MedicalConditionsCard extends StatelessWidget {
//   const MedicalConditionsCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return _CustomCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.warning_amber_outlined,
//                 color: Colors.orange.shade500,
//                 size: 24,
//               ),
//               const SizedBox(width: 8),
//               const Text(
//                 'Medical Conditions',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1E293B), // Teks gelap
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             decoration: BoxDecoration(
//               color: Colors.orange.shade50,
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: Colors.orange.shade300, width: 1),
//             ),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.warning_amber_outlined,
//                   color: Colors.orange.shade600,
//                   size: 18,
//                 ),
//                 const SizedBox(width: 8),
//                 // Fix Overflow: Menggunakan Expanded untuk memastikan teks kondisi melentur
//                 Expanded(
//                   child: Text(
//                     'Mild Hypertension',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.orange.shade800,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AllergiesCard extends StatelessWidget {
//   const AllergiesCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return _CustomCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.medical_information_outlined,
//                 color: Colors.red.shade400,
//                 size: 24,
//               ),
//               const SizedBox(width: 8),
//               const Text(
//                 'Allergies',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1E293B), // Teks gelap
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),
//           Wrap(
//             spacing: 8.0,
//             runSpacing: 8.0,
//             children: const [
//               _AllergyChip(text: 'Peanuts'),
//               _AllergyChip(text: 'Penicillin'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _AllergyChip extends StatelessWidget {
//   final String text;

//   const _AllergyChip({required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Chip(
//       label: Text(
//         text,
//         style: TextStyle(fontSize: 14, color: Colors.red.shade800),
//       ),
//       backgroundColor: Colors.red.shade50,
//       side: BorderSide(color: Colors.red.shade300, width: 1),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//     );
//   }
// }

// class DoctorsRecommendationsCard extends StatelessWidget {
//   const DoctorsRecommendationsCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return _CustomCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.assignment_turned_in_outlined,
//                 color: Colors.blue.shade400,
//                 size: 24,
//               ),
//               const SizedBox(width: 8),
//               const Text(
//                 'Doctor\'s Recommendations',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1E293B), // Teks gelap
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),
//           const _RecommendationItem(text: 'Regular blood pressure monitoring'),
//           const SizedBox(height: 10),
//           const _RecommendationItem(text: 'Low-sodium diet'),
//         ],
//       ),
//     );
//   }
// }

// class _RecommendationItem extends StatelessWidget {
//   final String text;

//   const _RecommendationItem({required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.blue.shade50,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.blue.shade300, width: 1),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             Icons.check_circle_outline,
//             color: Colors.blue.shade600,
//             size: 18,
//           ),
//           const SizedBox(width: 8),
//           // Fix Overflow: Menggunakan Expanded untuk memastikan teks rekomendasi melentur
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.blue.shade800,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // === Goals Tab Widgets ===

// class _GoalProgress extends StatelessWidget {
//   final String title;
//   final double current;
//   final double target;
//   final String unit;
//   final double progress;

//   const _GoalProgress({
//     required this.title,
//     required this.current,
//     required this.target,
//     required this.unit,
//     required this.progress,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // Menggunakan Flexible agar judul tidak overflow jika terlalu panjang
//             Flexible(
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey.shade700,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             Text(
//               '${current.toStringAsFixed(unit == 'kg' ? 0 : 1)}/${target.toStringAsFixed(unit == 'kg' ? 0 : 1)} $unit',
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey.shade800,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         LinearProgressIndicator(
//           value: progress,
//           backgroundColor: Colors.grey.shade200,
//           valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade500),
//           borderRadius: BorderRadius.circular(10),
//           minHeight: 8,
//         ),
//         const SizedBox(height: 5),
//         Text(
//           '${(progress * 100).toStringAsFixed(0)}% complete',
//           style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
//         ),
//       ],
//     );
//   }
// }

// class _ComparisonRow extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//   final String change;
//   final Color changeColor;

//   const _ComparisonRow({
//     required this.icon,
//     required this.label,
//     required this.value,
//     required this.change,
//     required this.changeColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(icon, color: Colors.grey.shade500, size: 20),
//         const SizedBox(width: 10),
//         // Fix Overflow: Menggunakan Expanded untuk memastikan label mendapatkan semua ruang yang dibutuhkan
//         Expanded(
//           child: Text(
//             label,
//             style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
//           ),
//         ),
//         // Spacer dihapus karena Expanded sudah mengambil ruang yang tersedia
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w600,
//             color: Colors.grey.shade800,
//           ),
//         ),
//         const SizedBox(width: 8),
//         if (change != 'Stable')
//           Icon(
//             change.startsWith('+') ? Icons.arrow_upward : Icons.arrow_downward,
//             size: 14,
//             color: changeColor,
//           ),
//         Text(
//           change,
//           style: TextStyle(
//             fontSize: 14,
//             color: changeColor,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }
// }

// // === Awards Tab Widgets ===

// class _AwardTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final Color color;
//   final Color iconColor;

//   const _AwardTile({
//     required this.icon,
//     required this.title,
//     required this.color,
//     required this.iconColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: iconColor.withOpacity(0.5), width: 1),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, size: 40, color: iconColor),
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Text(
//               title,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: iconColor.darken(
//                   0.3,
//                 ), // Membuat warna teks sedikit lebih gelap dari icon
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Ekstensi untuk menggelapkan warna
// extension ColorBrightness on Color {
//   Color darken([double amount = .1]) {
//     assert(amount >= 0 && amount <= 1);
//     final hsl = HSLColor.fromColor(this);
//     final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
//     return hslDark.toColor();
//   }
// }

// // Fungsi pembantu untuk menampilkan pesan singkat (SnackBar)
// void _showSnackBar(BuildContext context, String message) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(message),
//       duration: const Duration(seconds: 1),
//       backgroundColor: Colors.teal,
//     ),
//   );
// }
