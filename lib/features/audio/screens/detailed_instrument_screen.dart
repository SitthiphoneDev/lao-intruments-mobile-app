import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/services.dart';
import 'package:lao_instruments/generated/locale_keys.g.dart';
import '../../../theme/app_colors.dart';
import '../models/audio_models.dart';

@RoutePage()
class  DetailedInstrumentScreen extends StatefulWidget {
  final String instrumentId;
  final PredictionResult? predictionResult;

  const DetailedInstrumentScreen({
    super.key,
    required this.instrumentId,
    this.predictionResult,
  });

  @override
  State<DetailedInstrumentScreen> createState() => _DetailedInstrumentScreenState();
}

class _DetailedInstrumentScreenState extends State<DetailedInstrumentScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final instrumentData = _getInstrumentData(widget.instrumentId);
    
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          _buildSliverAppBar(instrumentData),
          
          // Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Prediction Result (if available)
                    if (widget.predictionResult != null)
                      _buildPredictionResultCard(),
                    
                    if (widget.predictionResult != null)
                      const SizedBox(height: 20),
                    
                    // Main Description
                    _buildDescriptionCard(instrumentData),
                    
                    const SizedBox(height: 20),
                    
                    // Sound Characteristics
                    _buildSoundCharacteristicsCard(instrumentData),
                    
                    const SizedBox(height: 20),
                    
                    // Cultural Significance
                    _buildCulturalSignificanceCard(instrumentData),
                    
                    const SizedBox(height: 20),
                    
                    // Historical Context
                    _buildHistoricalContextCard(instrumentData),
                    
                    const SizedBox(height: 20),
                    
                    // Playing Technique
                    _buildPlayingTechniqueCard(instrumentData),
                    
                    const SizedBox(height: 20),
                    
                    // Construction & Materials
                    _buildConstructionCard(instrumentData),
                    
                    const SizedBox(height: 20),
                    
                    // UNESCO Recognition (for Khaen)
                    if (widget.instrumentId.toLowerCase() == 'khean' || widget.instrumentId.toLowerCase() == 'khaen')
                      _buildUNESCOCard(),
                    
                    if (widget.instrumentId.toLowerCase() == 'khean' || widget.instrumentId.toLowerCase() == 'khaen')
                      const SizedBox(height: 20),
                    
                    // Modern Usage
                    _buildModernUsageCard(instrumentData),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(Map<String, dynamic> instrumentData) {
    return SliverAppBar(
      expandedHeight: 300,
      floating: false,
      pinned: true,
      backgroundColor: _getInstrumentGradient(widget.instrumentId).colors.first,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: _getInstrumentGradient(widget.instrumentId),
          ),
          child: _buildHeaderContent(instrumentData),
        ),
      ),
      );
  }

  Widget _buildHeaderContent(Map<String, dynamic> instrumentData) {
    return Stack(
      children: [
        // Background pattern
        Positioned.fill(
          child: Opacity(
            opacity: 0.1,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/pattern_lao.png'),
                  repeat: ImageRepeat.repeat,
                  onError: (exception, stackTrace) {},
                ),
              ),
            ),
          ),
        ),
        
        // Main content
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60), // Space for status bar
                
                // Instrument Image
                Hero(
                  tag: 'instrument_${widget.instrumentId}',
                  child: Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: _buildInstrumentImage(),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Lao Name
                Text(
                  instrumentData['name_lao'] ?? _getInstrumentName(widget.instrumentId),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                // Short tagline
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                //   decoration: BoxDecoration(
                //     color: AppColors.white.withOpacity(0.2),
                //     borderRadius: BorderRadius.circular(25),
                //   ),
                //   child: Text(
                //     _getInstrumentTagline(widget.instrumentId),
                //     style: const TextStyle(
                //       fontSize: 16,
                //       color: AppColors.white,
                //       fontWeight: FontWeight.w600,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstrumentImage() {
    // print("#### widget.instrumentId.toLowerCase() ${widget.instrumentId.toLowerCase()}");
    return FutureBuilder<bool>(
      future: _checkImageExists(widget.instrumentId.toLowerCase()),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return Image.asset(
            'assets/images/instruments/${widget.instrumentId.toLowerCase()}.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildEmojiImage();
            },
          );
        } else {
          return _buildEmojiImage();
        }
      },
    );
  }

  Widget _buildEmojiImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.white.withOpacity(0.8),
            AppColors.lightGrey.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Text(
          _getInstrumentEmoji(widget.instrumentId),
          style: const TextStyle(fontSize: 64),
        ),
      ),
    );
  }

  Widget _buildPredictionResultCard() {
  if (widget.predictionResult == null) return const SizedBox();
  
  final result = widget.predictionResult!;
  
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.instrument_ai_detection_result.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  Text(
                    LocaleKeys.instrument_confidence_category.tr(args: [
                      (result.confidence * 100).toStringAsFixed(1),
                      result.confidenceCategory
                    ]),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                LocaleKeys.instrument_detected.tr(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildDescriptionCard(Map<String, dynamic> data) {
  return _buildInfoCard(
    'instrument.description'.tr(),
    data['description'] ?? LocaleKeys.instrument_no_description.tr(),
    Icons.info_outline,
    AppColors.primaryBlue,
  );
}

Widget _buildSoundCharacteristicsCard(Map<String, dynamic> data) {
  return _buildInfoCard(
    'instrument.sound_characteristics'.tr(),
    data['sound_characteristics'] ?? LocaleKeys.instrument_no_information.tr(),
    Icons.graphic_eq,
    AppColors.primaryGold,
  );
}

Widget _buildCulturalSignificanceCard(Map<String, dynamic> data) {
  return _buildInfoCard(
    'instrument.cultural_significance'.tr(),
    data['cultural_significance'] ?? LocaleKeys.instrument_important_culture.tr(),
    Icons.account_balance,
    AppColors.primaryRed,
  );
}

Widget _buildHistoricalContextCard(Map<String, dynamic> data) {
  return _buildInfoCard(
    'instrument.history'.tr(),
    data['history'] ?? LocaleKeys.instrument_rich_history.tr(),
    Icons.history_edu,
    AppColors.success,
  );
}

Widget _buildPlayingTechniqueCard(Map<String, dynamic> data) {
  return _buildInfoCard(
    'instrument.playing_technique'.tr(),
    data['playing_technique'] ?? LocaleKeys.instrument_traditional_methods.tr(),
    Icons.touch_app,
    AppColors.primaryBlue,
  );
}

Widget _buildConstructionCard(Map<String, dynamic> data) {
  return _buildInfoCard(
    'instrument.construction'.tr(),
    data['construction'] ?? LocaleKeys.instrument_traditional_construction.tr(),
    Icons.build,
    AppColors.primaryGold,
  );
}

Widget _buildModernUsageCard(Map<String, dynamic> data) {
  return _buildInfoCard(
    'instrument.modern_usage'.tr(),
    data['modern_usage'] ?? LocaleKeys.instrument_contemporary_practice.tr(),
    Icons.theater_comedy,
    AppColors.success,
  );
}

Widget _buildUNESCOCard() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF1E3C72),
          Color(0xFF2A5298),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Color(0xFF1E3C72).withOpacity(0.3),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.workspace_premium,
                color: AppColors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.instrument_unesco_heritage.tr(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    LocaleKeys.instrument_unesco_subtitle.tr(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            LocaleKeys.instrument_unesco_description.tr(),
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.white,
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildInfoCard(String title, String content, IconData icon, Color color) {
return Container(
width: double.infinity,
padding: const EdgeInsets.all(24),
decoration: BoxDecoration(
color: AppColors.white,
borderRadius: BorderRadius.circular(20),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.05),
blurRadius: 15,
offset: const Offset(0, 8),
),
],
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Container(
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
color: color.withOpacity(0.1),
borderRadius: BorderRadius.circular(12),
),
child: Icon(
icon,
color: color,
size: 28,
),
),
const SizedBox(width: 16),
Expanded(
child: Text(
title,
style: const TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
color: AppColors.darkGrey,
),
),
),
],
),
const SizedBox(height: 20),
Text(
content,
style: const TextStyle(
fontSize: 16,
color: AppColors.darkGrey,
height: 1.6,
),
),
],
),
);
}

Widget _buildQuickFactsCard(Map<String, dynamic> data) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.fact_check,
                color: AppColors.primaryBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              LocaleKeys.instrument_quick_facts.tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGrey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildFactTile('🎵', LocaleKeys.instrument_type.tr(), data['type'] ?? 'Traditional', AppColors.primaryRed),
            _buildFactTile('🏗️', LocaleKeys.instrument_materials.tr(), data['materials'] ?? 'Various', AppColors.primaryBlue),
            _buildFactTile('📊', LocaleKeys.instrument_difficulty.tr(), data['difficulty'] ?? 'Medium', AppColors.primaryGold),
            _buildFactTile('🎭', LocaleKeys.instrument_role.tr(), data['role'] ?? 'Cultural', AppColors.success),
          ],
        ),
      ],
    ),
  );
}
Widget _buildFactTile(String emoji, String label, String value, Color color) {
return Container(
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: color.withOpacity(0.1),
borderRadius: BorderRadius.circular(15),
border: Border.all(color: color.withOpacity(0.3)),
),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(emoji, style: const TextStyle(fontSize: 28)),
const SizedBox(height: 8),
Text(
label,
style: TextStyle(
fontSize: 12,
color: color,
fontWeight: FontWeight.w600,
),
textAlign: TextAlign.center,
),
const SizedBox(height: 4),
Text(
value,
style: const TextStyle(
fontSize: 11,
color: AppColors.darkGrey,
fontWeight: FontWeight.w500,
),
textAlign: TextAlign.center,
maxLines: 2,
overflow: TextOverflow.ellipsis,
),
],
),
);
}

  // Data for each instrument based on the provided Lao text
  Map<String, dynamic> _getInstrumentData(String instrumentId) {
    switch (instrumentId.toLowerCase()) {
      case 'khean':
      case 'khaen':
        return {
          'name_lao': 'ແຄນ',
          'name_english': 'Khaen',
          'description': 'ແຄນແມ່ນເຄື່ອງດົນຕີທີ່ຖືກຖືວ່າເປັນເຄື່ອງດົນຕີປະຈຳຊາດຂອງລາວ. ມັນຖືກສ້າງຂຶ້ນຈາກທໍ່ໄມ້ໄຜ່ຫຼາຍອັນທີ່ຖືກຕິດຕັ້ງດ້ວຍລີ້ນໂລຫະ. ແຄນມີຕົ້ນກຳເນີດຈາກເຂດຊົນນະບົດ ແລະ ມີຄວາມສໍາພັນກັບເຄື່ອງດົນຕີປະເພດອື່ນໆທີ່ພົບເຫັນໃນເຂດອາຊີຕາເວັນອອກ ແລະ ອາຊີຕາເວັນອອກສ່ຽງໃຕ້, ອາດມີຕົ້ນກຳເນີດມາຈາກເຄື່ອງດົນຕີຈີນທີ່ເອີ້ນວ່າ "sheng".',
          'sound_characteristics': 'ແຄນສາມາດສ້າງສຽງທີ່ອຸດົມສົມບູນດ້ວຍສຽງຄູ່ (polyphonic) ທີ່ມີທັງສຽງພື້ນ (drone) ແລະ ສຽງທຳນອງ. ສຽງສາມາດທັງນຸ້ມນວນ ແລະ ມີຊີວິດຊີວາ, ຂຶ້ນກັບວິທີການຫຼິ້ນ ແລະ ໄລ (lai) ຫຼືໂໝດ (mode) ສະເພາະທີ່ໃຊ້.',
          'cultural_significance': 'ດົນຕີແຄນເປັນສ່ວນສຳຄັນຂອງຊີວິດຄົນລາວ, ສົ່ງເສີມຄວາມສາມັກຄີໃນຄອບຄົວ ແລະ ສັງຄົມ. ໃນປີ 2017, ແຄນລາວໄດ້ຖືກຂຶ້ນທະບຽນເປັນມໍລະດົກທາງວັດທະນະທໍາທີ່ບໍ່ແມ່ນວັດຖຸຂອງມວນມະນຸດຈາກອົງການ UNESCO.',
          'history': 'ມັນຖືກນໍາໃຊ້ເປັນເວລາຫຼາຍສະຕະວັດໃນລາວ ແລະ ພາກຕາເວັນອອກສຽງເໜືອຂອງໄທ (ອີສານ), ມັກຈະເຂົ້າຄູ່ກັບນັກຮ້ອງ (ໝໍລຳ) ໃນສະພາບແວດລ້ອມທາງສັງຄົມ ແລະ ພິທີກຳຕ່າງໆ.',
          'playing_technique': 'ນັກດົນຕີຈະເປົ່າຫຼືດຶງອາກາດຜ່ານກ່ອງລົມໃນຂະນະທີ່ປິດຮູນິ້ວຢູ່ທໍ່ໄມ້ໄຜ່ເພື່ອສ້າງລະດັບສຽງທີ່ແຕກຕ່າງກັນ.',
          'construction': 'ສ້າງຂຶ້ນຈາກທໍ່ໄມ້ໄຜ່ຫຼາຍອັນທີ່ຖືກຕິດຕັ້ງດ້ວຍລີ້ນໂລຫະ',
          'modern_usage': 'ຍັງຄົງເປັນເຄື່ອງດົນຕີສຳຄັນໃນວັດທະນະທຳລາວແລະໃຊ້ໃນງານບຸນປະເພນີ',
          'ai_features': 'ມີສຽງຄູ່ທີ່ເປັນເອກະລັກ, ສຽງພື້ນຕໍ່ເນື່ອງ, ແລະຮາໂມນິກທີ່ສັບສົນ',
          'type': 'Wind Instrument',
          'materials': 'Bamboo, Metal',
          'difficulty': 'High',
          'role': 'National Symbol',
        };
        
      case 'saw':
      case 'so':
        return {
          'name_lao': 'ຊໍອູ້',
          'name_english': 'So U',
          'description': 'ຊໍອູ້ແມ່ນເຄື່ອງດົນຕີສາຍແບບໃຊ້ຄັນຊັກທີ່ມີຕົ້ນກຳເນີດໃນລາວ ແລະ ໄທ. ມັນມີສຽງຕໍ່າກວ່າຊໍດ້ວງ ແລະ ເປັນເຄື່ອງດົນຕີໃນຕະກູນຊໍທີ່ມີສຽງຕໍ່າທີ່ສຸດ.',
          'sound_characteristics': 'ຊໍອູ້ມີສຽງທີ່ອຸດົມ, ເລິກ, ແລະ ນຸ້ມນວນ. ກ່ອງສຽງທີ່ເຮັດຈາກກະລາມະພ້າວປະກອບສ່ວນໃຫ້ເກີດສຽງກ້ອງສະເພາະຕົວຂອງມັນ.',
          'cultural_significance': 'ມັນຖືກໃຊ້ເລື້ອຍໆເພື່ອເປັນພື້ນຖານຂອງວົງດົນຕີ, ໂດຍສະເພາະສຳລັບທຳນອງທີ່ມີຈັງຫວະຊ້າຫາປານກາງ.',
          'history': 'ຫຼັກຖານຊີ້ໃຫ້ເຫັນວ່າການອອກແບບຂອງມັນອາດຈະໄດ້ຮັບການດັດແປງຈາກເຄື່ອງດົນຕີສາຍສອງເສັ້ນຂອງຈີນທີ່ເອີ້ນວ່າ "ຮູຮູ" (hu hu), ອາດຈະໃນຊ່ວງຕົ້ນສະໄໝກຸງເທບ (ປະມານປີ 1782) ຫຼື ປາຍສະໄໝອະຍຸທະຍາ.',
          'playing_technique': 'ເປັນເຄື່ອງດົນຕີສາຍທີ່ໃຊ້ຄັນຊັກ, ສ້າງສຽງທີ່ລື່ນແລະອຸດົມ',
          'construction': 'ກ່ອງສຽງເຮັດຈາກກະລາມະພ້າວ, ມີສາຍສອງເສັ້ນ',
          'modern_usage': 'ຍັງຄົງໃຊ້ໃນວົງດົນຕີລາວພື້ນເມືອງແລະຄລາສສິກ',
          'ai_features': 'ສຽງເລິກແລະນຸ້ມນວນ, ຄວາມຖີ່ຕໍ່າ, ລັກສະນະການສັ່ນສະເທືອນຂອງສາຍ',
          'type': 'String Instrument',
          'materials': 'Coconut, Strings',
          'difficulty': 'Medium',
          'role': 'Bass Foundation',
        };
        
      case 'sing':
        return {
          'name_lao': 'ຊິ່ງ',
          'name_english': 'Sing',
          'description': 'ໃນບໍລິບົດຂອງດົນຕີລາວ, "ຊິ່ງ" ໝາຍເຖິງຉາບທີ່ໃຊ້ເພື່ອສ້າງຈັງຫວະ. ໃນວົງເຊບໃຫຍ່ (ວົງດົນຕີຄລາສສິກລາວ), ມີຉາບສອງຊຸດ (ຊິ່ງ, ຄ້າຍຄືກັບຉາບໄທຫຼື "ຈິ່ງ") ທີ່ຖືກລວມເຂົ້າເປັນເຄື່ອງດົນຕີທີ່ເນັ້ນຈັງຫວະ.',
          'sound_characteristics': 'ຊິ່ງສ້າງສຽງທີ່ແຈ້ງກະຈ່າງ, ກະທົບ, ແລະ ກ້ອງທີ່ໃຊ້ເພື່ອກຳນົດວົງຈອນຂອງຈັງຫວະ ແລະ ເນັ້ນຈຸດສຳຄັນໃນດົນຕີ.',
          'cultural_significance': 'ຉາບມີປະຫວັດສາດອັນຍາວນານໃນຫຼາຍວັດທະນະທໍາ, ແລະ ການໃຊ້ຕາບໃນດົນຕີຄລາສສິກລາວເປັນສ່ວນໜຶ່ງຂອງປະເພນີວົງເຄື່ອງຕີ.',
          'history': 'ມີບົດບາດສຳຄັນໃນດົນຕີຄລາສສິກລາວມາເປັນເວລາຍາວນານ',
          'playing_technique': 'ຕີກັນເພື່ອສ້າງຈັງຫວະແລະເນັ້ນຈຸດສຳຄັນຂອງດົນຕີ',
          'construction': 'ເຮັດຈາກໂລຫະ, ມີຂະໜາດແລະຄວາມໜາທີ່ແຕກຕ່າງກັນ',
          'modern_usage': 'ຍັງຄົງເປັນສ່ວນສຳຄັນຂອງວົງດົນຕີລາວ',
          'ai_features': 'ສຽງແຈ້ງກະຈ່າງ, ການໂຈມຕີທີ່ແຫຼມ, ຄວາມຖີ່ສູງ',
          'type': 'Percussion',
          'materials': 'Metal Alloy',
          'difficulty': 'Easy',
          'role': 'Rhythm Keeper',
        };
        
      case 'pin':
        return {
          'name_lao': 'ພິນ',
          'name_english': 'Pin',
          'description': 'ພິນແມ່ນເຄື່ອງດົນຕີປະເພດລູດທີ່ມີຮູບຮ່າງຄ້າຍຄືໝາກສາລີ, ມີຕົ້ນກຳເນີດໃນພາກອີສານຂອງໄທ ແລະ ສ່ວນໃຫຍ່ຫຼິ້ນໂດຍຄົນເຊື້ອຊາດລາວໃນໄທ ແລະ ລາວ. ໂດຍທົ່ວໄປ, ມັນມີສາຍໂລຫະສອງຫຼືສາມເສັ້ນທີ່ຖືກຂຶງຜ່ານຄໍທີ່ມີເຟຣັດແລະຖືກດີດດ້ວຍວິຫຼືປິກ.',
          'sound_characteristics': 'ພິນສ້າງສຽງທີ່ແຈ້ງ, ແຫລມ, ທີ່ມີສຽງສັ້ນພໍສົມຄວນ. ສຽງຂອງມັນເປັນລັກສະນະສະເພາະຂອງດົນຕີໝໍລຳແລະລູກທຸ່ງ.',
          'cultural_significance': 'ມັນມັກຈະຫຼິ້ນຄູ່ກັບແຄນໃນດົນຕີໝໍລຳແລະລູກທຸ່ງ, ໃຫ້ການປະກອບຈັງຫວະແລະທຳນອງໃຫ້ກັບສຽງຮ້ອງ ແລະ ແຄນ.',
          'history': 'ມີຕົ້ນກຳເນີດໃນພາກອີສານແລະແຜ່ຂະຫຍາຍໄປທົ່ວລາວ',
          'playing_technique': 'ດີດດ້ວຍນິ້ວຫຼືປິກ, ມີເຟຣັດສຳລັບການປ່ຽນລະດັບສຽງ',
          'construction': 'ໂຕແລະຄໍມັກຈະຖືກແກະສະຫຼັກຈາກໄມ້ທ່ອນດຽວ',
          'modern_usage': 'ຍັງຄົງນິຍົມໃນດົນຕີໝໍລຳແລະລູກທຸ່ງ',
          'ai_features': 'ສຽງແຫຼມ, ການໂຈມຕີທີ່ແຈ້ງ, ຮູບແບບການສັ່ນຂອງສາຍ',
          'type': 'Plucked String',
          'materials': 'Wood, Metal Strings',
          'difficulty': 'Medium',
          'role': 'Melodic Support',
        };
        
      case 'khong_vong':
      case 'khong':
        return {
          'name_lao': 'ຄ້ອງວົງ',
          'name_english': 'Khong Wong',
          'description': 'ຄ້ອງວົງໝາຍເຖິງຊຸດຄ້ອງທີ່ຈັດວາງໃນກອບວົງມົນ. ເຄື່ອງດົນຕີປະເພດນີ້ມີຮູບແບບຕ່າງໆໃນທົ່ວອາຊີຕາເວັນອອກສຽງໃຕ້. ໃນວົງດົນຕີຄລາສສິກລາວ (ເຊບໃຫຍ່), ໂດຍທົ່ວໄປມີຊຸດຄ້ອງ (ຄ້ອງວົງ) ສອງຊຸດ.',
          'sound_characteristics': 'ຄ້ອງວົງສ້າງສຽງຄ້ອງທີ່ປັບລະດັບສຽງຊຶ່ງສາມາດສ້າງທັງຮູບແບບທຳນອງແລະຈັງຫວະ. ສຽງກ້ອງແລະລະດັບສຽງຂອງຄ້ອງແຕ່ລະໜ່ວຍຂຶ້ນກັບຂະໜາດແລະວັດສະດຸທີ່ໃຊ້.',
          'cultural_significance': 'ວົງຄ້ອງເຫຼົ່ານີ້ອາດມີຕົ້ນກຳເນີດບູຮານ, ພັດທະນາຜ່ານຫຼາຍສະຕະວັດແລະຖືກລວມເຂົ້າໃນດົນຕີລາຊະສຳນັກແລະດົນຕີປະກອບພິທີກຳ.',
          'history': 'ມີປະຫວັດຍາວນານໃນດົນຕີອາຊີຕາເວັນອອກສຽງໃຕ້',
          'playing_technique': 'ຕີດ້ວຍໄມ້ຕີພິເສດເພື່ອສ້າງທຳນອງແລະຈັງຫວະ',
          'construction': 'ເຮັດຈາກທອງແດງຫຼືທອງເຫຼືອງ, ຈັດວາງໃນກອບວົງມົນ',
          'modern_usage': 'ຍັງຄົງເປັນເຄື່ອງດົນຕີຫຼັກໃນວົງດົນຕີລາວ',
          'ai_features': 'ສຽງໂລຫະທີ່ມີຮາໂມນິກ, ການສັ່ນສະເທືອນທີ່ຊັບຊ້ອນ',
          'type': 'Percussion',
          'materials': 'Bronze, Copper',
          'difficulty': 'High',
          'role': 'Melodic Lead',
        };
        
      case 'ranad':
        return {
          'name_lao': 'ລະນາດ',
          'name_english': 'Ranad',
          'description': 'ລະນາດແມ່ນຄຳທົ່ວໄປສຳລັບເຄື່ອງດົນຕີປະເພດເຄາະທີ່ມີຮູບຄີບອດໃນດົນຕີໄທແລະລາວ. ໄມ້ຕີສາມາດເຮັດຈາກໄມ້ແຂງຫຼືໄມ້ໄຜ່, ໂລຫະ, ຫຼືບາງຄັ້ງກໍ່ເຮັດຈາກແກ້ວ.',
          'sound_characteristics': 'ສຽງຂອງລະນາດແຕກຕ່າງກັນໄປຂຶ້ນກັບວັດສະດຸຂອງໄມ້ຕີແລະໄມ້ທີ່ໃຊ້. ໄມ້ສ້າງສຽງທີ່ສົດໃສ, ແລະກະທົບ, ໃນຂະນະທີ່ໂລຫະມີສຽງທີ່ແຈ້ງກະຈ່າງ, ກ້ອງກວ່າ.',
          'cultural_significance': 'ລະນາດເອກແມ່ນເຄື່ອງດົນຕີນຳພາໃນວົງປີ່ພາດ. ຮູບແບບດັ້ງເດີມທີ່ສຸດໄດ້ວິວັດທະນາຈາກເຄື່ອງດົນຕີແບບງ່າຍໆ.',
          'history': 'ພັດທະນາຈາກເຄື່ອງດົນຕີແບບງ່າຍໆທີ່ໃຊ້ຮັກສາຈັງຫວະ',
          'playing_technique': 'ໄມ້ຕີຕ່າງໆ (ແຂງຫຼືນຸ້ມ) ຖືກໃຊ້ເພື່ອໃຫ້ໄດ້ສີສຽງທີ່ແຕກຕ່າງກັນ',
          'construction': 'ແຜ່ນໄມ້ຫຼືໂລຫະທີ່ຈັດວາງຢ່າງເປັນລະບົບ',
          'modern_usage': 'ຍັງຄົງເປັນເຄື່ອງດົນຕີສຳຄັນໃນວົງດົນຕີ',
          'ai_features': 'ສຽງກະທົບທີ່ແຈ້ງ, ການໂຈມຕີທີ່ແຫຼມ, ຄວາມຖີ່ປານກາງ',
          'type': 'Xylophone',
          'materials': 'Wood, Metal',
          'difficulty': 'High',
          'role': 'Melodic Lead',
        };
        
      default:
        return {
          'name_lao': 'ບໍ່ຮູ້ຈັກ',
          'name_english': 'Unknown',
          'description': 'ສຽງທີ່ບໍ່ສາມາດລະບຸເປັນເຄື່ອງດົນຕີລາວທີ່ຮູ້ຈັກໄດ້',
          'sound_characteristics': 'ລັກສະນະທີ່ຫຼາກຫຼາຍ',
          'cultural_significance': 'ບໍ່ແມ່ນເຄື່ອງດົນຕີລາວພື້ນເມືອງ',
          'history': 'ບໍ່ສາມາດລະບຸໄດ້',
          'playing_technique': 'ບໍ່ແມ່ນເຄື່ອງດົນຕີ',
          'construction': 'ບໍ່ສາມາດລະບຸໄດ້',
          'modern_usage': 'ບໍ່ແມ່ນເຄື່ອງດົນຕີ',
          'ai_features': 'ລັກສະນະທີ່ບໍ່ແມ່ນເຄື່ອງດົນຕີ',
          'type': 'Unknown',
          'materials': 'Various',
          'difficulty': 'N/A',
          'role': 'None',
        };
    }
  }

  // Helper methods
  Future<bool> _checkImageExists(String instrumentId) async {
    try {
      await rootBundle.load('assets/images/instruments/${instrumentId}.jpg');
      return true;
    } catch (e) {
      return false;
    }
  }

  LinearGradient _getInstrumentGradient(String instrument) {
    switch (instrument.toLowerCase()) {
      case 'khean':
      case 'khaen':
        return const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'khong_vong':
      case 'khong':
        return const LinearGradient(
          colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'pin':
        return const LinearGradient(
          colors: [Color(0xFF8B4513), Color(0xFFD2691E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'ranad':
        return const LinearGradient(
          colors: [Color(0xFF228B22), Color(0xFF32CD32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'saw':
      case 'so':
        return const LinearGradient(
          colors: [Color(0xFF4B0082), Color(0xFF8A2BE2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'sing':
        return const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  String _getInstrumentEmoji(String instrument) {
    switch (instrument.toLowerCase()) {
      case 'khean':
      case 'khaen':
        return '🎵';
      case 'khong_vong':
      case 'khong':
        return '🥁';
      case 'pin':
        return '🪕';
      case 'ranad':
        return '🎹';
      case 'saw':
      case 'so':
        return '🎻';
      case 'sing':
        return '🥁';
      default:
        return '❓';
    }
  }

  String _getInstrumentName(String instrument) {
    switch (instrument.toLowerCase()) {
      case 'khean':
      case 'khaen':
        return 'ແຄນ (Khaen)';
      case 'khong_vong':
      case 'khong':
        return 'ຄ້ອງວົງ (Khong Wong)';
      case 'pin':
        return 'ພິນ (Pin)';
      case 'ranad':
        return 'ລະນາດ (Ranad)';
      case 'saw':
      case 'so':
        return 'ຊໍອູ້ (So U)';
      case 'sing':
        return 'ຊິ່ງ (Sing)';
      case 'unknown':
        return 'ບໍ່ຮູ້ຈັກ (Unknown)';
      default:
        return instrument;
    }
  }

  String _getInstrumentTagline(String instrument) {
    switch (instrument.toLowerCase()) {
      case 'khean':
      case 'khaen':
        return 'UNESCO Heritage • National Symbol of Laos';
      case 'khong_vong':
      case 'khong':
        return 'Melodic Foundation • Bronze Harmony';
      case 'pin':
        return 'Folk Storyteller • Plucked Poetry';
      case 'ranad':
        return 'Wooden Percussion • Bright Tones';
      case 'saw':
      case 'so':
        return 'Voice Mimic • Expressive Strings';
      case 'sing':
        return 'Rhythmic Sparkle • Ensemble Heart';
      default:
        return 'Traditional Lao Music';
    }
  }

  void _shareInstrumentInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${_getInstrumentName(widget.instrumentId)}...'),
        backgroundColor: AppColors.primaryBlue,
      ),
    );
  }
}