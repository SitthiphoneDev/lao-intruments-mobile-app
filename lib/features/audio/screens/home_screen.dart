import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lao_instruments/generated/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lao_instruments/theme/app_colors.dart';
import 'package:lao_instruments/routers/app_router.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInstrumentsExpanded = false;
   bool _isGitHubExpanded = false;
  
  // Launch URLs
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  // Download functions
  void _downloadPDF() {
    _launchURL('https://your-domain.com/proposal.pdf');
  }

  void _downloadWord() {
    _launchURL('https://your-domain.com/proposal.docx');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Beautiful Header Section (replaces app bar)
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/nuol_bg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      AppColors.primaryRed.withOpacity(0.6),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Pattern Background (optional)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _PatternPainter(),
                      ),
                    ),
                    // Content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // University Logo (Big)
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/nuol_logo.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.school,
                                    size: 50,
                                    color: AppColors.primaryRed,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'ມະຫາວິທະຍາໄລແຫ່ງຊາດລາວ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black26,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            'National University of Laos',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Main Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  // Faculty Badge
Center(
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Clean logo design
        Container(
          width: 44,
          height: 44,
         
          child: Center(
            child: ClipOval(
              child: Image.asset(
                'assets/images/faculty_of_sciences.png',
                width: 100,
                height: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.science,
                    size: 22,
                    color: AppColors.primaryGold,
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        
        // Clean text layout
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.home_faculty.tr(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGrey,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              LocaleKeys.home_major.tr(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.grey,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ],
    ),
  ),
),   
                  const SizedBox(height: 24),
                  
                  // Project Title Card - Modern Design
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGold.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Gold Accent
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.goldGradient,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGold.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  LocaleKeys.home_thesis_project.tr(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'ການຈໍາແນກເຄື່ອງດົນຕີລາວດ້ວຍສຽງ\nໂດຍໃຊ້ Deep Learning',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkGrey,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Audio Classification of Lao Instruments\nUsing Deep Learning Techniques',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.grey,
                                  fontStyle: FontStyle.italic,
                                  height: 1.3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Team Section - Card Style
                  _buildSectionCard(
                    title: LocaleKeys.home_team.tr(),
                    icon: Icons.groups,
                    children: [
                      _buildTeamMemberCard(
                        title: LocaleKeys.home_students.tr(),
                        members: [
                          {
                            'nameLao': 'ທ້າວ ເອກທະວີພົນ ທອງເພັດ',
                            'nameEng': 'Mr. Ekthaviphonh THONGPHET',
                            'email': 'ekthaviphonh@gmail.com',
                            'phone': '020 59 179 444',
                          },
                          {
                            'nameLao': 'ທ້າວ ສິດທິພອນ ພຸດຕະວົງ',
                            'nameEng': 'Mr. Sitthiphone PHOUTTAVONG',
                            'email': 'sitthiphone.pv@gmail.com',
                            'phone': '020 77 717 904',
                          },
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildAdvisorCard(
                        title: LocaleKeys.home_advisor.tr(),
                        nameLao: 'ຮສ.ປອ. ລັດສະຫມີ ຈິດຕະວົງ',
                        nameEng: 'Assoc.Prof.Dr. Lathsamy CHIDTAVONG',
                        isMainAdvisor: true,
                      ),
                      const SizedBox(height: 12),
                      _buildAdvisorCard(
                        title: LocaleKeys.home_co_advisor.tr(),
                        nameLao: 'ອຈ.ປອ. ສົມສັກ ອິນທະສອນ',
                        nameEng: 'Ph.D. Somsack INTHASONE',
                        isMainAdvisor: false,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Musical Instruments Section - Expandable
                  _buildInstrumentsSection(),
                  
                  const SizedBox(height: 20),
                  
                  // Quick Actions Grid
                  _buildQuickActionsGrid(),
                  
                  const SizedBox(height: 20),
                  
                  // Downloads Section
                  _buildDownloadsSection(),
                  
                  const SizedBox(height: 20),
                  
                  // Links Section
                  _buildLinksSection(),
                  
                  const SizedBox(height: 20),
                  
                  // // Features Grid
                  // _buildFeaturesGrid(),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGitHubDropdownSection() {
  return Container(
    child: Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isGitHubExpanded = !_isGitHubExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.code,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.home_github_repositories.tr(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      Text(
                        LocaleKeys.home_view_source_code.tr(),
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _isGitHubExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.expand_more,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            children: [
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    // AI Model Repository
                    _buildGitHubRepoCard(
                      icon: Icons.smart_toy,
                      title: LocaleKeys.home_ai_model_repo.tr(),
                      subtitle: LocaleKeys.home_ai_model_desc.tr(),
                      color: Colors.purple,
                      onTap: () => _launchURL('https://github.com/your-username/lao-instruments-ai-model'),
                    ),
                    const SizedBox(height: 12),
                    
                    // Backend Repository
                    _buildGitHubRepoCard(
                      icon: Icons.storage,
                      title: LocaleKeys.home_backend_repo.tr(),
                      subtitle: LocaleKeys.home_backend_desc.tr(),
                      color: Colors.orange,
                      onTap: () => _launchURL('https://github.com/your-username/lao-instruments-backend'),
                    ),
                    const SizedBox(height: 12),
                    
                    // Mobile App Repository
                    _buildGitHubRepoCard(
                      icon: Icons.phone_android,
                      title: LocaleKeys.home_mobile_repo.tr(),
                      subtitle: LocaleKeys.home_mobile_desc.tr(),
                      color: Colors.blue,
                      onTap: () => _launchURL('https://github.com/your-username/lao-instruments-mobile'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          crossFadeState: _isGitHubExpanded 
            ? CrossFadeState.showSecond 
            : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    ),
  );
}

Widget _buildGitHubRepoCard({
  required IconData icon,
  required String title,
  required String subtitle,
  required Color color,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.open_in_new,
              size: 16,
              color: color,
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primaryRed,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMemberCard({
    required String title,
    required List<Map<String, String>> members,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(height: 12),
        ...members.map((member) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lightGrey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.grey.withOpacity(0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member['nameLao']!,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
              Text(
                member['nameEng']!,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.email_outlined, size: 14, color: AppColors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      member['email']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.phone_outlined, size: 14, color: AppColors.grey),
                  const SizedBox(width: 6),
                  Text(
                    member['phone']!,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildAdvisorCard({
    required String title,
    required String nameLao,
    required String nameEng,
    required bool isMainAdvisor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isMainAdvisor 
            ? [AppColors.primaryGold.withOpacity(0.1), AppColors.primaryGold.withOpacity(0.05)]
            : [AppColors.primaryRed.withOpacity(0.05), AppColors.primaryRed.withOpacity(0.02)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMainAdvisor 
            ? AppColors.primaryGold.withOpacity(0.3)
            : AppColors.primaryRed.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isMainAdvisor ? AppColors.primaryGold : AppColors.primaryRed,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            nameLao,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            ),
          ),
          Text(
            nameEng,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstrumentsSection() {
    final instruments = [
      {
        'name': 'ແຄນ',
        'eng': 'Khaen',
        'image': 'assets/images/instruments/khaen.jpg',
        'description': 'ແຄນແມ່ນເຄື່ອງດົນຕີທີ່ຖືກຖືວ່າເປັນເຄື່ອງດົນຕີປະຈຳຊາດຂອງລາວ...',
        'fullDescription': '''ແຄນແມ່ນເຄື່ອງດົນຕີທີ່ຖືກຖືວ່າເປັນເຄື່ອງດົນຕີປະຈຳຊາດຂອງລາວ. ມັນຖືກສ້າງຂຶ້ນຈາກທໍ່ໄມ້ໄຜ່ຫຼາຍອັນທີ່ຖືກຕິດຕັ້ງດ້ວຍລີ້ນໂລຫະ. ແຄນມີຕົ້ນກຳເນີດຈາກເຂດຊົນນະບົດ ແລະ ມີຄວາມສໍາພັນກັບເຄື່ອງດົນຕີປະເພດອື່ນໆທີ່ພົບເຫັນໃນເຂດອາຊີຕາເວັນອອກ ແລະ ອາຊີຕາເວັນອອກສ່ຽງໃຕ້, ອາດມີຕົ້ນກຳເນີດມາຈາກເຄື່ອງດົນຕີຈີນທີ່ເອີ້ນວ່າ "sheng". 

ມັນຖືກນໍາໃຊ້ເປັນເວລາຫຼາຍສະຕະວັດໃນລາວ ແລະ ພາກຕາເວັນອອກສຽງເໜືອຂອງໄທ (ອີສານ), ມັກຈະເຂົ້າຄູ່ກັບນັກຮ້ອງ (ໝໍລຳ) ໃນສະພາບແວດລ້ອມທາງສັງຄົມ ແລະ ພິທີກຳຕ່າງໆ. ດົນຕີແຄນເປັນສ່ວນສຳຄັນຂອງຊີວິດຄົນລາວ, ສົ່ງເສີມຄວາມສາມັກຄີໃນຄອບຄົວ ແລະ ສັງຄົມ.

ໃນປີ 2017, ແຄນລາວໄດ້ຖືກຂຶ້ນທະບຽນເປັນມໍລະດົກທາງວັດທະນະທໍາທີ່ບໍ່ແມ່ນວັດຖຸຂອງມວນມະນຸດຈາກອົງການ UNESCO. ແຄນສາມາດສ້າງສຽງທີ່ອຸດົມສົມບູນດ້ວຍສຽງຄູ່ (polyphonic) ທີ່ມີທັງສຽງພື້ນ (drone) ແລະ ສຽງທຳນອງ. ນັກດົນຕີຈະເປົ່າຫຼືດຶງອາກາດຜ່ານກ່ອງລົມໃນຂະນະທີ່ປິດຮູນິ້ວຢູ່ທໍ່ໄມ້ໄຜ່ເພື່ອສ້າງລະດັບສຽງທີ່ແຕກຕ່າງກັນ. ສຽງສາມາດທັງນຸ້ມນວນ ແລະ ມີຊີວິດຊີວາ, ຂຶ້ນກັບວິທີການຫຼິ້ນ ແລະ ໄລ (lai) ຫຼືໂໝດ (mode) ສະເພາະທີ່ໃຊ້.''',
      },
      {
        'name': 'ຊໍອູ້',
        'eng': 'So U',
        'image': 'assets/images/instruments/saw.jpg',
        'description': 'ຊໍອູ້ແມ່ນເຄື່ອງດົນຕີສາຍແບບໃຊ້ຄັນຊັກທີ່ມີຕົ້ນກຳເນີດໃນລາວ ແລະ ໄທ...',
        'fullDescription': '''ຊໍອູ້ແມ່ນເຄື່ອງດົນຕີສາຍແບບໃຊ້ຄັນຊັກທີ່ມີຕົ້ນກຳເນີດໃນລາວ ແລະ ໄທ. ມັນມີສຽງຕໍ່າກວ່າຊໍດ້ວງ ແລະ ເປັນເຄື່ອງດົນຕີໃນຕະກູນຊໍທີ່ມີສຽງຕໍ່າທີ່ສຸດ. ຫຼັກຖານຊີ້ໃຫ້ເຫັນວ່າການອອກແບບຂອງມັນອາດຈະໄດ້ຮັບການດັດແປງຈາກເຄື່ອງດົນຕີສາຍສອງເສັ້ນຂອງຈີນທີ່ເອີ້ນວ່າ "ຮູຮູ" (hu hu), ອາດຈະໃນຊ່ວງຕົ້ນສະໄໝກຸງເທບ (ປະມານປີ 1782) ຫຼື ປາຍສະໄໝອະຍຸທະຍາ. 

ພາຍໃນຊ່ວງທ້າຍຂອງສະຕະວັດທີ 19, ມັນຖືກລວມເຂົ້າໃນວົງປີ່ພາດໄມ້ນວມ. ຊື່ "ຊໍອູ້" ມາຈາກສຽງລັກສະນະສະເພາະທີ່ຄົນໄທເຊື່ອມໂຍງກັບມັນ. ຊໍອູ້ມີສຽງທີ່ອຸດົມ, ເລິກ, ແລະ ນຸ້ມນວນ. ມັນຖືກໃຊ້ເລື້ອຍໆເພື່ອເປັນພື້ນຖານຂອງວົງດົນຕີ, ໂດຍສະເພາະສຳລັບທຳນອງທີ່ມີຈັງຫວະຊ້າຫາປານກາງ. ກ່ອງສຽງທີ່ເຮັດຈາກກະລາມະພ້າວປະກອບສ່ວນໃຫ້ເກີດສຽງກ້ອງສະເພາະຕົວຂອງມັນ.''',
      },
      {
        'name': 'ຊິ່ງ',
        'eng': 'Xing',
        'image': 'assets/images/instruments/sing.jpg',
        'description': 'ໃນບໍລິບົດຂອງດົນຕີລາວ, "ຊິ່ງ" ໝາຍເຖິງຉາບທີ່ໃຊ້ເພື່ອສ້າງຈັງຫວະ...',
        'fullDescription': '''ໃນບໍລິບົດຂອງດົນຕີລາວ, "ຊິ່ງ" ໝາຍເຖິງຉາບທີ່ໃຊ້ເພື່ອສ້າງຈັງຫວະ. ໃນວົງເຊບໃຫຍ່ (ວົງດົນຕີຄລາສສິກລາວ), ມີຉາບສອງຊຸດ (ຊິ່ງ, ຄ້າຍຄືກັບຉາບໄທຫຼື "ຈິ່ງ") ທີ່ຖືກລວມເຂົ້າເປັນເຄື່ອງດົນຕີທີ່ເນັ້ນຈັງຫວະ. ຉາບມີປະຫວັດສາດອັນຍາວນານໃນຫຼາຍວັດທະນະທໍາ, ແລະ ການໃຊ້ຕາບໃນດົນຕີຄລາສສິກລາວເປັນສ່ວນໜຶ່ງຂອງປະເພນີວົງເຄື່ອງຕີ.

ຊິ່ງສ້າງສຽງທີ່ແຈ້ງກະຈ່າງ, ກະທົບ, ແລະ ກ້ອງທີ່ໃຊ້ເພື່ອກຳນົດວົງຈອນຂອງຈັງຫວະ ແລະ ເນັ້ນຈຸດສຳຄັນໃນດົນຕີ. ສຽງສະເພາະຂຶ້ນກັບຂະໜາດ, ຄວາມໜາ, ແລະ ໂລຫະປະສົມຂອງຉາບ, ເຊັ່ນດຽວກັບວິທີການຕີ.''',
      },
      {
        'name': 'ພິນ',
        'eng': 'Phin',
        'image': 'assets/images/instruments/pin.jpg',
        'description': 'ພິນແມ່ນເຄື່ອງດົນຕີປະເພດລູດທີ່ມີຮູບຮ່າງຄ້າຍຄືໝາກສາລີ...',
        'fullDescription': '''ພິນແມ່ນເຄື່ອງດົນຕີປະເພດລູດທີ່ມີຮູບຮ່າງຄ້າຍຄືໝາກສາລີ, ມີຕົ້ນກຳເນີດໃນພາກອີສານຂອງໄທ ແລະ ສ່ວນໃຫຍ່ຫຼິ້ນໂດຍຄົນເຊື້ອຊາດລາວໃນໄທ ແລະ ລາວ. ໂດຍທົ່ວໄປ, ມັນມີສາຍໂລຫະສອງຫຼືສາມເສັ້ນທີ່ຖືກຂຶງຜ່ານຄໍທີ່ມີເຟຣັດແລະຖືກດີດດ້ວຍວິຫຼືປິກ. ມັນມັກຈະຫຼິ້ນຄູ່ກັບແຄນໃນດົນຕີໝໍລຳແລະລູກທຸ່ງ. ໂຕແລະຄໍມັກຈະຖືກແກະສະຫຼັກຈາກໄມ້ທ່ອນດຽວ.

ພິນສ້າງສຽງທີ່ແຈ້ງ, ແຫລມ, ທີ່ມີສຽງສັ້ນພໍສົມຄວນ. ສຽງຂອງມັນເປັນລັກສະນະສະເພາະຂອງດົນຕີໝໍລຳແລະລູກທຸ່ງ, ໃຫ້ການປະກອບຈັງຫວະແລະທຳນອງໃຫ້ກັບສຽງຮ້ອງ ແລະ ແຄນ.''',
      },
      {
        'name': 'ຄ້ອງວົງ',
        'eng': 'Khong Vong',
        'image': 'assets/images/instruments/khong_vong.jpg',
        'description': 'ຄ້ອງວົງໝາຍເຖິງຊຸດຄ້ອງທີ່ຈັດວາງໃນກອບວົງມົນ...',
        'fullDescription': '''ຄ້ອງວົງໝາຍເຖິງຊຸດຄ້ອງທີ່ຈັດວາງໃນກອບວົງມົນ. ເຄື່ອງດົນຕີປະເພດນີ້ມີຮູບແບບຕ່າງໆໃນທົ່ວອາຊີຕາເວັນອອກສຽງໃຕ້. ໃນວົງດົນຕີຄລາສສິກລາວ (ເຊບໃຫຍ່), ໂດຍທົ່ວໄປມີຊຸດຄ້ອງ (ຄ້ອງວົງ) ສອງຊຸດ. ວົງຄ້ອງເຫຼົ່ານີ້ອາດມີຕົ້ນກຳເນີດບູຮານ, ພັດທະນາຜ່ານຫຼາຍສະຕະວັດແລະຖືກລວມເຂົ້າໃນດົນຕີລາຊະສຳນັກແລະດົນຕີປະກອບພິທີກຳ.

ຄ້ອງວົງສ້າງສຽງຄ້ອງທີ່ປັບລະດັບສຽງຊຶ່ງສາມາດສ້າງທັງຮູບແບບທຳນອງແລະຈັງຫວະ. ສຽງກ້ອງແລະລະດັບສຽງຂອງຄ້ອງແຕ່ລະໜ່ວຍຂຶ້ນກັບຂະໜາດແລະວັດສະດຸທີ່ໃຊ້ (ໂດຍທົ່ວໄປແມ່ນທອງແດງຫຼືທອງເຫຼືອງ). ໃນວົງດົນຕີ, ຄ້ອງວົງສອງຊຸດ (ຊຸດໜຶ່ງສຽງສູງກວ່າ, ອີກຊຸດສຽງຕໍ່າກວ່າ) ຮ່ວມກັນສ້າງທຳນອງແລະລວດລາຍທີ່ຊັບຊ້ອນ.''',
      },
      {
        'name': 'ລະນາດ',
        'eng': 'Lanat',
        'image': 'assets/images/instruments/ranad.jpg',
        'description': 'ລະນາດແມ່ນຄຳທົ່ວໄປສຳລັບເຄື່ອງດົນຕີປະເພດເຄາະທີ່ມີຮູບຄີບອດ...',
        'fullDescription': '''ລະນາດແມ່ນຄຳທົ່ວໄປສຳລັບເຄື່ອງດົນຕີປະເພດເຄາະທີ່ມີຮູບຄີບອດໃນດົນຕີໄທແລະລາວ. ໄມ້ຕີສາມາດເຮັດຈາກໄມ້ແຂງຫຼືໄມ້ໄຜ່ (ລະນາດເອກແລະລະນາດທຸ້ມ), ໂລຫະ (ລະນາດເອກເຫຼັກແລະລະນາດທຸ້ມເຫຼັກ), ຫຼືບາງຄັ້ງກໍ່ເຮັດຈາກແກ້ວ (ລະນາດແກ້ວ). ລະນາດເອກແມ່ນເຄື່ອງດົນຕີນຳພາໃນວົງປີ່ພາດ. ຮູບແບບດັ້ງເດີມທີ່ສຸດໄດ້ວິວັດທະນາຈາກເຄື່ອງດົນຕີແບບງ່າຍໆທີ່ໃຊ້ຮັກສາຈັງຫວະ (ກຣັບ) ໄປເປັນຊຸດໄມ້ທີ່ປັບລະດັບສຽງ.

ສຽງຂອງລະນາດແຕກຕ່າງກັນໄປຂຶ້ນກັບວັດສະດຸຂອງໄມ້ຕີແລະໄມ້ທີ່ໃຊ້. ໄມ້ສ້າງສຽງທີ່ສົດໃສ, ແລະກະທົບ, ໃນຂະນະທີ່ໂລຫະມີສຽງທີ່ແຈ້ງກະຈ່າງ, ກ້ອງກວ່າ. ໄມ້ຕີຕ່າງໆ (ແຂງຫຼືນຸ້ມ) ຖືກໃຊ້ເພື່ອໃຫ້ໄດ້ສີສຽງທີ່ແຕກຕ່າງກັນ. ລະນາດເອກໂດຍທົ່ວໄປຫຼິ້ນທຳນອງຫຼັກດ້ວຍສຽງທີ່ຄົມແລະແຈ້ງຊັດ, ໃນຂະນະທີ່ລະນາດທຸ້ມໃຫ້ສຽງທີ່ຕໍ່າກວ່າ, ມັກຈະເປັນທຳນອງປະກອບ.''',
      },
    ];
return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        // Header Section
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.library_music,
                  color: AppColors.primaryGold,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ເຄື່ອງດົນຕີພື້ນເມືອງລາວ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    Text(
                      'ປະຫວັດຄວາມເປັນມາຂໍ້ມູນເຄື່ອງດົນຕີ',
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
        
        // Always visible content
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'ເຄື່ອງດົນຕີພື້ນເມືອງລາວແມ່ນມໍລະດົກທາງວັດທະນະທໍາທີ່ສຳຄັນຂອງປະເທດລາວ, ເຊິ່ງເປັນສິ່ງທີ່ສະທ້ອນໃຫ້ເຫັນເຖິງເອກະລັກ ແລະ ປະຫວັດສາດອັນຍາວນານຂອງວັດທະນະທໍາລາວ. ເຄື່ອງດົນຕີເຫຼົ່ານີ້ບໍ່ພຽງແຕ່ເປັນເຄື່ອງມືສຳລັບສ້າງສຽງດົນຕີເທົ່ານັ້ນ, ແຕ່ຍັງເປັນສ່ວນໜຶ່ງຂອງພິທີກຳທາງສາສະໜາ, ງານສະຫຼອງ, ແລະ ກິດຈະກຳທາງສັງຄົມຕ່າງໆ.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.darkGrey,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...instruments.map((instrument) => 
                _buildInstrumentCard(instrument)
              ).toList(),
            ],
          ),
        ),
      ],
    ),
  );
}
  Widget _buildInstrumentCard(Map<String, String> instrument) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primaryGold.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                instrument['image']!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.music_note,
                    color: AppColors.primaryGold,
                    size: 30,
                  );
                },
              ),
            ),
          ),
          title: Text(
            '${instrument['name']} (${instrument['eng']})',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            ),
          ),
          subtitle: Text(
            instrument['description']!,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.grey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightGrey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                instrument['fullDescription']!,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.darkGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.flash_on,
                  color: AppColors.primaryRed,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
               Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.home_quick_actions.tr(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    Text(
                      LocaleKeys.home_quick_actions_desc.tr(),
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

          // Actions Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 12,
            children: [
              _buildActionCard(
                icon: Icons.mic,
                title: LocaleKeys.home_record.tr(),
                subtitle: LocaleKeys.home_start_recording.tr(),
                color: AppColors.primaryRed,
                onTap: () {
                  context.router.navigate(const AudioRoute());
                },
              ),
              _buildActionCard(
                icon: Icons.help_outline,
                title: LocaleKeys.home_guide.tr(),
                subtitle: LocaleKeys.home_learn_more.tr(),
                color: AppColors.primaryGold,
                onTap: () {
                  context.router.navigate(const GuideRoute());
                },
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.download,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                LocaleKeys.home_downloads.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _downloadPDF,
                  icon: const Icon(Icons.picture_as_pdf, size: 20),
                  label: Text(LocaleKeys.home_download_pdf.tr()),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _downloadWord,
                  icon: const Icon(Icons.article, size: 20),
                  label: Text(LocaleKeys.home_download_word.tr()),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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

  Widget _buildLinksSection() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.link,
                  color: AppColors.primaryRed,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                LocaleKeys.home_external_links.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        _buildLinkTile(
          icon: Icons.school,
          title: LocaleKeys.home_nuol_website.tr(),
          subtitle: LocaleKeys.home_visit_university.tr(),
          color: AppColors.primaryRed,
          onTap: () => _launchURL('https://www.nuol.edu.la'),
        ),
        const Divider(height: 1, indent: 70),
        // Add Faculty Website Link
        _buildLinkTile(
          icon: Icons.science,
          title: LocaleKeys.home_faculty_website.tr(),
          subtitle: LocaleKeys.home_visit_faculty.tr(),
          color: AppColors.primaryGold,
          onTap: () => _launchURL('https://fns.nuol.edu.la'),
        ),
        const Divider(height: 1, indent: 70),
             // GitHub Repositories Dropdown
          _buildGitHubDropdownSection(),
      ],
    ),
  );
}

  Widget _buildLinkTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.darkGrey,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: AppColors.grey,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.grey,
      ),
    );
  }


  Widget _buildFeaturesGrid() {
    final features = [
      {
        'icon': Icons.smart_toy,
        'title': LocaleKeys.home_ai_powered.tr(),
        'subtitle': LocaleKeys.home_deep_learning.tr(),
        'color': Colors.purple,
      },
      {
        'icon': Icons.timer,
        'title': LocaleKeys.home_real_time.tr(),
        'subtitle': LocaleKeys.home_fast_processing.tr(),
        'color': Colors.orange,
      },
      {
        'icon': Icons.school,
        'title': LocaleKeys.home_educational.tr(),
        'subtitle': LocaleKeys.home_cultural_info.tr(),
        'color': Colors.green,
      },
      {
        'icon': Icons.phone_android,
        'title': LocaleKeys.home_mobile_friendly.tr(),
        'subtitle': LocaleKeys.home_flutter_built.tr(),
        'color': Colors.blue,
      },
      {
        'icon': Icons.storage,
        'title': LocaleKeys.home_large_dataset.tr(),
        'subtitle': LocaleKeys.home_audio_samples.tr(),
        'color': Colors.teal,
      },
      {
        'icon': Icons.precision_manufacturing,
        'title': LocaleKeys.home_high_accuracy.tr(),
        'subtitle': LocaleKeys.home_advanced_processing.tr(),
        'color': Colors.red,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGold.withOpacity(0.05),
            AppColors.primaryRed.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryGold.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.home_key_features.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              final feature = features[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (feature['color'] as Color).withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (feature['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        feature['icon'] as IconData,
                        size: 20,
                        color: feature['color'] as Color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column( 
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            feature['title'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkGrey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            feature['subtitle'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
}

// Pattern Painter for App Bar
class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    const double spacing = 30;
    for (double i = 0; i < size.width + spacing; i += spacing) {
      for (double j = 0; j < size.height + spacing; j += spacing) {
        canvas.drawCircle(Offset(i, j), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}