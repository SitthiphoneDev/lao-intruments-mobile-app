// // lib/features/audio/widgets/instrument_detail_dialog.dart
// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:lao_instruments/features/audio/constants/instrument_data.dart';
// import '../../../theme/app_colors.dart';

// class InstrumentDetailDialog extends StatefulWidget {
//   final String instrumentId;

//   const InstrumentDetailDialog({
//     super.key,
//     required this.instrumentId,
//   });

//   @override
//   State<InstrumentDetailDialog> createState() => _InstrumentDetailDialogState();
// }

// class _InstrumentDetailDialogState extends State<InstrumentDetailDialog>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final instrumentData = InstrumentData.getInstrumentData(widget.instrumentId);
    
//     return Dialog(
//       insetPadding: const EdgeInsets.all(16),
//       backgroundColor: Colors.transparent,
//       child: Container(
//         width: double.infinity,
//         height: MediaQuery.of(context).size.height * 0.8,
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           children: [
//             // Header
//             Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: _getInstrumentGradient(widget.instrumentId),
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         instrumentData['emoji'],
//                         style: const TextStyle(fontSize: 40),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               instrumentData['name_lao'],
//                               style: const TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.white,
//                               ),
//                             ),
//                             Text(
//                               instrumentData['name_english'],
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 color: AppColors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () => Navigator.of(context).pop(),
//                         icon: const Icon(
//                           Icons.close,
//                           color: AppColors.white,
//                           size: 28,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
            
//             // Tab Bar
//             Container(
//               color: AppColors.lightGrey,
//               child: TabBar(
//                 controller: _tabController,
//                 labelColor: AppColors.primaryRed,
//                 unselectedLabelColor: AppColors.grey,
//                 indicatorColor: AppColors.primaryRed,
//                 tabs: [
//                   Tab(text: 'instrument.overview'.tr()),
//                   Tab(text: 'instrument.details'.tr()),
//                   Tab(text: 'instrument.culture'.tr()),
//                 ],
//               ),
//             ),
            
//             // Tab Content
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   _buildOverviewTab(instrumentData),
//                   _buildDetailsTab(instrumentData),
//                   _buildCultureTab(instrumentData),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOverviewTab(Map<String, dynamic> data) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Description
//           _buildInfoSection(
//             'instrument.description'.tr(),
//             data['description'],
//             Icons.info_outline,
//           ),
          
//           const SizedBox(height: 20),
          
//           // Sound Characteristics
//           _buildInfoSection(
//             'instrument.sound_characteristics'.tr(),
//             data['sound_characteristics'],
//             Icons.graphic_eq,
//           ),
          
//           const SizedBox(height: 20),
          
//           // Playing Technique
//          _buildInfoSection(
//             'instrument.playing_technique'.tr(),
//             data['playing_technique'],
//             Icons.touch_app,
//           ),
          
//           const SizedBox(height: 20),
          
//           // Quick Facts
//           _buildQuickFacts(data),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailsTab(Map<String, dynamic> data) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Construction & Materials
//           _buildInfoSection(
//             'instrument.construction'.tr(),
//             data['construction'],
//             Icons.build,
//           ),
          
//           const SizedBox(height: 20),
          
//           // Technical Specifications
//           _buildTechnicalSpecs(data),
          
//           const SizedBox(height: 20),
          
//           // AI Recognition Features
//           _buildInfoSection(
//             'instrument.ai_features'.tr(),
//             data['ai_features'],
//             Icons.smart_toy,
//           ),
          
//           const SizedBox(height: 20),
          
//           // Learning Tips
//           _buildLearningTips(data),
//         ],
//       ),
//     );
//   }

//   Widget _buildCultureTab(Map<String, dynamic> data) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Cultural Significance
//           _buildInfoSection(
//             'instrument.cultural_significance'.tr(),
//             data['cultural_significance'],
//             Icons.account_balance,
//           ),
          
//           const SizedBox(height: 20),
          
//           // Historical Context
//           _buildInfoSection(
//             'instrument.history'.tr(),
//             data['history'],
//             Icons.history_edu,
//           ),
          
//           const SizedBox(height: 20),
          
//           // Usage in Ceremonies
//           _buildInfoSection(
//             'instrument.ceremonies'.tr(),
//             data['ceremonies'],
//             Icons.celebration,
//           ),
          
//           const SizedBox(height: 20),
          
//           // Modern Usage
//           _buildInfoSection(
//             'instrument.modern_usage'.tr(),
//             data['modern_usage'],
//             Icons.theater_comedy,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoSection(String title, String content, IconData icon) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.lightGrey,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: AppColors.primaryRed.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(
//                   icon,
//                   color: AppColors.primaryRed,
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.darkGrey,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             content,
//             style: const TextStyle(
//               fontSize: 14,
//               color: AppColors.darkGrey,
//               height: 1.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickFacts(Map<String, dynamic> data) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.primaryBlue.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'instrument.quick_facts'.tr(),
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: AppColors.primaryBlue,
//             ),
//           ),
//           const SizedBox(height: 12),
//           _buildFactRow('instrument.pitch_range'.tr(), data['pitch_range']),
//           _buildFactRow('instrument.materials'.tr(), data['materials']),
//           _buildFactRow('instrument.difficulty'.tr(), data['difficulty']),
//           _buildFactRow('instrument.ensemble_role'.tr(), data['ensemble_role']),
//         ],
//       ),
//     );
//   }

//   Widget _buildTechnicalSpecs(Map<String, dynamic> data) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.primaryGold.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColors.primaryGold.withOpacity(0.3)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'instrument.technical_specs'.tr(),
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: AppColors.darkGrey,
//             ),
//           ),
//           const SizedBox(height: 12),
//           _buildFactRow('instrument.frequency_range'.tr(), data['frequency_range']),
//           _buildFactRow('instrument.dynamic_range'.tr(), data['dynamic_range']),
//           _buildFactRow('instrument.attack_time'.tr(), data['attack_time']),
//           _buildFactRow('instrument.sustain_type'.tr(), data['sustain_type']),
//         ],
//       ),
//     );
//   }

//   Widget _buildLearningTips(Map<String, dynamic> data) {
//     final tips = data['learning_tips'] as List<String>;
    
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.success.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColors.success.withOpacity(0.3)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'instrument.learning_tips'.tr(),
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: AppColors.success,
//             ),
//           ),
//           const SizedBox(height: 12),
//           ...tips.map((tip) => Padding(
//             padding: const EdgeInsets.only(bottom: 8),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('• ', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
//                 Expanded(
//                   child: Text(
//                     tip,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: AppColors.darkGrey,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )),
//         ],
//       ),
//     );
//   }

//   Widget _buildFactRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 100,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 12,
//                 color: AppColors.grey,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 12,
//                 color: AppColors.darkGrey,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   LinearGradient _getInstrumentGradient(String instrument) {
//     switch (instrument.toLowerCase()) {
//       case 'khean':
//       case 'khaen':
//         return AppColors.goldGradient;
//       case 'khong_vong':
//       case 'khong':
//         return AppColors.blueGradient;
//       case 'pin':
//         return const LinearGradient(
//           colors: [Color(0xFF8B4513), Color(0xFFD2691E)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         );
//       case 'ranad':
//         return const LinearGradient(
//           colors: [Color(0xFF228B22), Color(0xFF32CD32)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         );
//       case 'saw':
//       case 'so':
//         return const LinearGradient(
//           colors: [Color(0xFF4B0082), Color(0xFF8A2BE2)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         );
//       case 'sing':
//         return const LinearGradient(
//           colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         );
//       default:
//         return AppColors.redGradient;
//     }
//   }
// }