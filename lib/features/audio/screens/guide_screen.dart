import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lao_instruments/generated/locale_keys.g.dart';
import 'package:lao_instruments/routers/app_router.dart';
import 'package:lao_instruments/theme/app_colors.dart';

@RoutePage()
class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentTutorialStep = 0;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        title: Text(LocaleKeys.guide_title.tr()),
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(
              icon: const Icon(Icons.school),
              text: LocaleKeys.guide_tutorial_title.tr(),
            ),
            Tab(
              icon: const Icon(Icons.help_outline),
              text: LocaleKeys.guide_faq_title.tr(),
            ),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildTutorialTab(),
            _buildFaqTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildInteractiveGuide(),
          const SizedBox(height: 20),
          _buildRecordVsImportChoice(),
          const SizedBox(height: 20),
          _buildInternetRequirementCard(),
          const SizedBox(height: 20),
          _buildBestPracticesCard(),
        ],
      ),
    );
  }

  Widget _buildInteractiveGuide() {
    final steps = [
      {
        'icon': Icons.wifi,
        'title': 'ເຊື່ອມຕໍ່ອິນເຕີເນັດ',
        'description': 'ກວດສອບການເຊື່ອມຕໍ່ອິນເຕີເນັດກ່ອນໃຊ້ງານ',
        'details': 'ແອັບຕ້ອງການອິນເຕີເນັດເພື່ອສົ່ງສຽງໄປຫາ AI server ສຳລັບການວິເຄາະ. WiFi ຫຼື Mobile Data ທັງຄູ່ສາມາດໃຊ້ໄດ້.',
        'color': Colors.blue,
        'image': '📶',
      },
      {
        'icon': Icons.mic,
        'title': 'ບັນທຶກສຽງ',
        'description': 'ບັນທຶກສຽງເຄື່ອງດົນຕີໂດຍກົງ',
        'details': 'ແຕະປຸ່ມໄມໂຄຣໂຟນ ແລະ ບັນທຶກ 8 ວິນາທີ. ຫຼິ້ນເຄື່ອງດົນຕີໃຫ້ຊັດເຈນ ແລະ ຖືອຸປະກອນໃຫ້ໝັ້ນຄົງ.',
        'color': Colors.red,
        'image': '🎙️',
      },
      {
        'icon': Icons.upload_file,
        'title': 'ອັບໂຫຼດໄຟລ໌',
        'description': 'ເລືອກໄຟລ໌ສຽງທີ່ມີຢູ່ແລ້ວ',
        'details': 'ທາງເລືອກອື່ນ: ເລືອກໄຟລ໌ WAV ຫຼື MP3 ທີ່ມີຢູ່ໃນໂທລະສັບ. ຂະໜາດສູງສຸດ 10MB, ແນະນຳ 10 ວິນາທີ.',
        'color': Colors.orange,
        'image': '📁',
      },
      {
        'icon': Icons.analytics,
        'title': 'ລໍຖ້າຜົນການວິເຄາະ',
        'description': 'AI ຈະວິເຄາະແລະສົ່ງຜົນກັບມາ',
        'details': 'ແອັບຈະສົ່ງສຽງໄປຫາ server, AI ຈະວິເຄາະແລະສົ່ງຜົນການຈຳແນກພ້ອມລະດັບຄວາມໝັ້ນໃຈກັບມາ.',
        'color': Colors.green,
        'image': '🤖',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryBlue, AppColors.primaryRed],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.guide_tutorial_title.tr(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'ຄຳແນະນຳລະອຽດສຳລັບການໃຊ້ງານແອັບ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Progress indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (_currentTutorialStep + 1) / steps.length,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${_currentTutorialStep + 1}/${steps.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGrey,
                  ),
                ),
              ],
            ),
          ),

          // Current step content
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Container(
              key: ValueKey(_currentTutorialStep),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Step visual
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: (steps[_currentTutorialStep]['color'] as Color).withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: steps[_currentTutorialStep]['color'] as Color,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        steps[_currentTutorialStep]['image'] as String,
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Step number
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: steps[_currentTutorialStep]['color'] as Color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'ຂັ້ນຕອນທີ ${_currentTutorialStep + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Step title
                  Text(
                    steps[_currentTutorialStep]['title'] as String,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  
                  // Step description
                  Text(
                    steps[_currentTutorialStep]['description'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.grey,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  
                  // Detailed explanation
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Text(
                      steps[_currentTutorialStep]['details'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.darkGrey,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Navigation buttons
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                if (_currentTutorialStep > 0)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _currentTutorialStep--;
                        });
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('ກ່ອນໜ້າ'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                if (_currentTutorialStep > 0) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_currentTutorialStep < steps.length - 1) {
                        setState(() {
                          _currentTutorialStep++;
                        });
                      } else {
                        _showTutorialCompleted();
                      }
                    },
                    icon: Icon(_currentTutorialStep < steps.length - 1 
                      ? Icons.arrow_forward 
                      : Icons.check),
                    label: Text(_currentTutorialStep < steps.length - 1 
                      ? 'ຕໍ່ໄປ' 
                      : 'ສຳເລັດ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: steps[_currentTutorialStep]['color'] as Color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordVsImportChoice() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.compare_arrows,
                  color: AppColors.primaryGold,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '🎯 ເລືອກວິທີການໃຊ້ງານ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'ຜູ້ໃຊ້ຄວນເລືອກວິທີການໃດວິທີການໜຶ່ງ:',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.darkGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          
          // Record option
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.mic, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🎙️ ບັນທຶກສຽງໂດຍກົງ (ແນະນຳ)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '• ບັນທຶກລົງໃນແອັບໂດຍກົງ\n• ຄຸນນະພາບດີກວ່າ\n• ແອັບຄວບຄຸມໄດ້ດີກວ່າ',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Import option
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.upload_file, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '📁 ອັບໂຫຼດໄຟລ໌ທີ່ມີແລ້ວ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '• ໃຊ້ໄຟລ໌ WAV, MP3 ທີ່ມີແລ້ວ\n• ສູງສຸດ 10MB\n• ແນະນຳ 10 ວິນາທີ',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInternetRequirementCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue[50]!,
            Colors.blue[100]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.wifi,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '🌐 ຕ້ອງການອິນເຕີເນັດ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'ແອັບນີ້ຕ້ອງການການເຊື່ອມຕໍ່ອິນເຕີເນັດເພື່ອ:',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.darkGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          _buildRequirementItem('📤', 'ສົ່ງໄຟລ໌ສຽງໄປຫາ AI Server'),
          _buildRequirementItem('🤖', 'ໃຊ້ AI ທີ່ມີປະສິດທິພາບສູງ'),
          _buildRequirementItem('📥', 'ຮັບຜົນການວິເຄາະກັບມາ'),
          _buildRequirementItem('☁️', 'ອັບເດດໂມເດລ AI ໃໝ່'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'WiFi ຫຼື Mobile Data ທັງຄູ່ສາມາດໃຊ້ໄດ້',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.darkGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestPracticesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGold.withOpacity(0.1),
            AppColors.primaryRed.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGold.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.primaryGold,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '💡 ເຄັດລັບສຳລັບຜົນລັບທີ່ດີ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipItem('🔇', 'ບັນທຶກໃນບ່ອນງຽບ', 'ສຽງລົບກວນຈະມີຜົນກະທົບຕໍ່ຄວາມແມ່ນຍໍາ'),
          _buildTipItem('📏', 'ໄລຍະທາງທີ່ເໝາະສົມ', 'ຖືອຸປະກອນຫ່າງຈາກເຄື່ອງດົນຕີ 30-50 ຊັງຕີແມັດ'),
          _buildTipItem('⏱️', 'ເວລາທີ່ເໝາະສົມ', 'ບັນທຶກ 8 ວິນາທີເພື່ອການວິເຄາະທີ່ດີທີ່ສຸດ'),
          _buildTipItem('🎵', 'ຫຼິ້ນໃຫ້ຊັດເຈນ', 'ໃຫ້ສຽງເຄື່ອງດົນຕີໄດ້ຍິນຊັດ ແລະ ດັງພໍ'),
          _buildTipItem('📶', 'ສັນຍານດີ', 'ກວດສອບສັນຍານອິນເຕີເນັດກ່ອນການວິເຄາະ'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String emoji, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.darkGrey,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqTab() {
    final faqs = [
      {
        'question': 'ຍ້ອນຫຍັງແອັບບໍ່ສາມາດເຊື່ອມຕໍ່ໄດ້?',
        'answer': 'ກວດສອບການເຊື່ອມຕໍ່ອິນເຕີເນັດ ແລະ ລອງໃໝ່',
        'icon': Icons.wifi_off,
        'color': Colors.red,
        'solutions': [
          'ກວດສອບ WiFi ຫຼື Mobile Data',
          'ລອງປິດເປີດແອັບໃໝ່',
          'ກວດສອບວ່າມີສັນຍານດີຫຼືບໍ່',
          'ລອງໃຊ້ເຄືອຂ່າຍອື່ນ',
        ],
      },
      {
        'question': 'ການວິເຄາະໃຊ້ເວລານານເກີນໄປ?',
        'answer': 'ອາດເປັນເພາະສັນຍານອິນເຕີເນັດຊ້າ',
        'icon': Icons.hourglass_empty,
        'color': Colors.orange,
        'solutions': [
          'ກວດສອບຄວາມໄວອິນເຕີເນັດ',
          'ລະຍະເວລາປົກກະຕິ 10-30 ວິນາທີ',
          'ຫຼີກເວັ້ນການໃຊ້ອິນເຕີເນັດແບບຫຼາຍ app',
          'ລົງອາດຕ້ອງລໍ 1-2 ນາທີຖ້າສັນຍານອ່ອນ',
        ],
      },
      {
        'question': 'ຄວາມແມ່ນຍໍາຕ່ຳ - ແກ້ແນວໃດ?',
        'answer': 'ປັບປຸງຄຸນນະພາບການບັນທຶກ ແລະ ສະພາບແວດລ້ອມ',
        'icon': Icons.verified,
        'color': Colors.blue,
        'solutions': [
          'ບັນທຶກໃນບ່ອນງຽບທີ່ບໍ່ມີສຽງລົບກວນ',
          'ຖືອຸປະກອນໄວຍະຫ່າງເຄື່ອງດົນຕີ 30-50cm',
          'ຫຼິ້ນເຄື່ອງດົນຕີໃຫ້ຊັດເຈນ ແລະ ດັງພໍ',
          'ບັນທຶກໃຫ້ຄົບ 8 ວິນາທີຢ່າງຕໍ່ເນື່ອງ',
        ],
      },
      {
        'question': 'ໄຟລ໌ອັບໂຫຼດບໍ່ສຳເລັດ?',
        'answer': 'ກວດສອບຂະໜາດ ແລະ ປະເພດໄຟລ໌',
        'icon': Icons.file_upload,
        'color': Colors.purple,
        'solutions': [
          'ໃຊ້ໄຟລ໌ WAV ຫຼື MP3 ເທົ່ານັ້ນ',
          'ຂະໜາດໄຟລ໌ບໍ່ເກີນ 10MB',
          'ແນະນຳໄຟລ໌ສັ້ນກວ່າ 10 ວິນາທີ',
          'ກວດສອບວ່າໄຟລ໌ບໍ່ເສຍຫາຍ',
        ],
      },
      {
        'question': 'ຜົນການວິເຄາະບໍ່ຖືກຕ້ອງ?',
        'answer': 'AI ອາດຈຳແນກຜິດເນື່ອງຈາກຄຸນນະພາບສຽງ',
        'icon': Icons.error_outline,
        'color': Colors.teal,
        'solutions': [
          'ລອງບັນທຶກໃໝ່ໃນສະພາບແວດລ້ອມທີ່ດີກວ່າ',
          'ໃຫ້ແນ່ໃຈວ່າມີສຽງເຄື່ອງດົນຕີຢ່າງດຽວ',
          'ຫຼີກເວັ້ນສຽງລົບກວນຈາກແຫຼ່ງອື່ນ',
          'AI ຈະແມ່ນຍໍາກວ່າຖ້າມີສຽງຊັດເຈນ',
        ],
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryGold, AppColors.primaryRed],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.help_outline,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  LocaleKeys.guide_faq_title.tr(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ຄໍາຕອບສໍາລັບຄໍາຖາມທີ່ພົບເປັນປະຈໍາ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...faqs.map((faq) => _buildFaqCard(faq)).toList(),
        ],
      ),
    );
  }

  Widget _buildFaqCard(Map<String, dynamic> faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (faq['color'] as Color).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            faq['icon'] as IconData,
            color: faq['color'] as Color,
            size: 24,
          ),
        ),
        title: Text(
          faq['question'] as String,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (faq['color'] as Color).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (faq['color'] as Color).withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: faq['color'] as Color,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          faq['answer'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'ວິທີແກ້ໄຂທີລະ:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 8),
                ...(faq['solutions'] as List<String>).asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: faq['color'] as Color,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.darkGrey,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTutorialCompleted() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryGold, AppColors.primaryRed],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.celebration,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '🎉 ຂໍສະແດງຄວາມຍິນດີ!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'ເຈົ້າໄດ້ຮຽນຈົບບົດຮຽນແລ້ວ!\nພ້ອມທີ່ຈະເລີ່ມຈຳແນກເຄື່ອງດົນຕີລາວ.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.grey,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _currentTutorialStep = 0;
                      });
                    },
                    icon: const Icon(Icons.replay),
                    label: const Text('ເລີ່ມໃໝ່'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigate to recording screen
                      context.router.pushAndPopUntil(
                        const MainNavigationRoute(),
                        predicate: (route) => false,
                      );
                    },
                    icon: const Icon(Icons.mic),
                    label: const Text('ເລີ່ມໃຊ້ງານ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}