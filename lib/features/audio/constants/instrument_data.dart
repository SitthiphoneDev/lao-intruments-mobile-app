class InstrumentData {
  static Map<String, dynamic> getInstrumentData(String instrumentId) {
    switch (instrumentId.toLowerCase()) {
      case 'khean':
      case 'khaen':
        return _khaenData;
      case 'khong_vong':
      case 'khong':
        return _khongWongData;
      case 'pin':
        return _pinData;
      case 'ranad':
        return _ranadData;
      case 'saw':
      case 'so':
        return _sawData;
      case 'sing':
        return _singData;
      default:
        return _unknownData;
    }
  }

  static final Map<String, dynamic> _khaenData = {
    'emoji': '🎵',
    'name_lao': 'ແຄນ',
    'name_english': 'Khaen',
    'description': 'ແຄນເປັນເຄື່ອງດົນຕີປາກຂອງລາວທີ່ມີປາງໄຜ່ກັບລີ້ນໂລຫະ. UNESCO ໄດ້ຮັບຮອງເປັນມໍລະດົກວັດທະນະທຳທີ່ບໍ່ມີຕົວຕົນຂອງລາວໃນປີ 2017.',
    'sound_characteristics': 'ສຽງຕໍ່ເນື່ອງ, ມີຮາໂມນິກ, ສາມາດຫຼິ້ນໄດ້ຫຼາຍໂນ້ດພ້ອມກັນ',
    'playing_technique': 'ເປົ່າຜ່ານຫ້ອງລົມ, ໃຊ້ນິ້ວມືຄວບຄຸມສຽງແລະຮາໂມນີ',
    'construction': 'ເຮັດຈາກປາງໄຜ່ທີ່ມີລີ້ນໂລຫະ, ຈັດລ່ຽງໃນຮູບຮາງປີກນົກ',
    'cultural_significance': 'ເປັນສັນຍາລັກຂອງຄວາມເປັນລາວ, ໃຊ້ໃນງານບຸນປະເພນີແລະການສະແດງ',
    'history': 'ມີປະຫວັດຍາວນານກວ່າ 3000 ປີ, ຖືກຖ່າຍທອດຕາມແນວພັນ',
    'ceremonies': 'ໃຊ້ໃນງານບຸນປະເພນີ, ງານແຕ່ງງານ, ແລະການສະແດງພື້ນເມືອງ',
    'modern_usage': 'ຍັງຄົງນິຍົມໃນຍຸກສະໄໝ, ມີການສອນໃນໂຮງຮຽນແລະມະຫາວິທະຍາໄລ',
    'pitch_range': '80-400 Hz',
    'materials': 'ປາງໄຜ່, ລີ້ນໂລຫະ, ແວັກ',
    'difficulty': 'ສູງ',
    'ensemble_role': 'ດົນຕີຫຼັກ',
    'frequency_range': '80-2000 Hz',
    'dynamic_range': 'ປານກາງ',
    'attack_time': 'ຊ້າ (>100ms)',
    'sustain_type': 'ຕໍ່ເນື່ອງ',
    'ai_features': 'ຮາໂມນິກສູງ, ສຽງຕໍ່ເນື່ອງ, ອັດຕາການຂ້າມສູນຕ່ຳ',
    'learning_tips': [
      'ຝຶກການຫາຍໃຈຢ່າງຖືກຕ້ອງ',
      'ເລີ່ມຈາກສຽງຂັ້ນພື້ນຖານ',
      'ຝຶກການຄວບຄຸມລີ້ນ',
      'ຮຽນຮູ້ເທັກນິກການເປົ່າ'
    ],
  };

  static final Map<String, dynamic> _khongWongData = {
    'emoji': '🥁',
    'name_lao': 'ຄ້ອງວົງ',
    'name_english': 'Khong Wong',
    'description': 'ເຄື່ອງດົນຕີກົງທີ່ຈັດວາງເປັນວົງກົມ, ເຮັດຈາກທອງແດງຫຼືທອງເຫຼືອງ',
    'sound_characteristics': 'ສຽງໃສ, ມີຊຸນຍ່າງ, ຮົ່ວງເສັງປະສານສຽງ',
    'playing_technique': 'ຕີດ້ວຍໄມ້ຕີທີ່ອ່ອນ, ສ້າງຈັງຫວະແລະທຳນອງ',
    'construction': 'ກົງທອງແດງຫຼືທອງເຫຼືອງ 16 ໃບ ຈັດວາງໃນກອບໄມ້',
    'cultural_significance': 'ເປັນເຄື່ອງດົນຕີຫຼັກໃນວົງດົນຕີລາວ',
    'history': 'ມາຈາກອິນເດຍ, ໄດ້ພັດທະນາເປັນແບບລາວ',
    'ceremonies': 'ໃຊ້ໃນງານບຸນປະເພນີແລະການສະແດງພື້ນເມືອງ',
    'modern_usage': 'ຍັງນິຍົມໃນວົງດົນຕີແລະການສອນ',
    'pitch_range': '200-2000 Hz',
    'materials': 'ທອງແດງ, ທອງເຫຼືອງ, ໄມ້',
    'difficulty': 'ປານກາງ',
    'ensemble_role': 'ທຳນອງຫຼັກ',
    'frequency_range': '200-4000 Hz',
    'dynamic_range': 'ສູງ',
    'attack_time': 'ໄວ (<50ms)',
    'sustain_type': 'ຜ່ອນໆລົງ',
    'ai_features': 'ການໂຈມຕີແຫຼມ, ສຽງໂລຫະ, ການຜ່ອນຄາຍປານກາງ',
    'learning_tips': [
      'ຝຶກການຕີທີ່ຈຸດທີ່ຖືກຕ້ອງ',
      'ຮຽນຮູ້ການຈັບໄມ້ຕີ',
      'ຝຶກການຄວບຄຸມກຳລັງ',
      'ຮຽນຮູ້ທຳນອງພື້ນຖານ'
    ],
  };

  static final Map<String, dynamic> _pinData = {
    'emoji': '🪕',
    'name_lao': 'ພິນ',
    'name_english': 'Pin',
    'description': 'ເຄື່ອງດົນຕີເສັ້ນໄຍທີ່ມີຫົວແຫວງມະພ້າວຫຼືໄມ້, ຄ້າຍກັບ lute',
    'sound_characteristics': 'ສຽງອົບອຸ່ນ, ມີການໂຈມຕີແລະຜ່ອນຄາຍທີ່ຈະແຈ້ງ',
    'playing_technique': 'ດີດເສັ້ນໄຍດ້ວຍນິ້ວມືຫຼື plectrum',
    'construction': 'ຫົວແຫວງມະພ້າວຫຼືໄມ້, ເສັ້ນໄຍໃຍ, ຄໍໄມ້',
    'cultural_significance': 'ໃຊ້ໃນດົນຕີພື້ນເມືອງແລະການເລົ່ານິທານ',
    'history': 'ມີມາແຕ່ຫຼັກຊ່ວງ, ພົບເຫັນໃນເມືອງລຸ່ມແມ່ນ້ຳ',
    'ceremonies': 'ໃຊ້ໃນການສະແດງເດີ່ຍແລະວົງດົນຕີນ້ອຍ',
    'modern_usage': 'ຍັງມີການຮຽນຮູ້ແລະສະແດງໃນປະຈຸບັນ',
    'pitch_range': '80-800 Hz',
    'materials': 'ມະພ້າວ, ໄມ້, ເສັ້ນໄຍ',
    'difficulty': 'ປານກາງ',
    'ensemble_role': 'ທຳນອງປະກອບ',
    'frequency_range': '80-1600 Hz',
    'dynamic_range': 'ປານກາງ',
    'attack_time': 'ໄວ (<30ms)',
    'sustain_type': 'ຜ່ອນໄວ',
    'ai_features': 'ການໂຈມຕີແຫຼມ ຕາມດ້ວຍການຜ່ອນຄາຍແບບເລກຊາເນນ',
    'learning_tips': [
      'ຝຶກການຈັບນິ້ວຢ່າງຖືກຕ້ອງ',
      'ເລີ່ມຈາກ chord ງ່າຍໆ',
      'ຝຶກ fingerpicking ເທັກນິກ',
      'ຮຽນຮູ້ທຳນອງພື້ນບ້ານ'
    ],
  };

  // Add more instrument data for ranad, saw, sing...
  static final Map<String, dynamic> _ranadData = {
    'emoji': '🎹',
    'name_lao': 'ລະນາດ',
    'name_english': 'Ranad',
    'description': 'ເຄື່ອງດົນຕີກົງໄມ້ທີ່ມີຫລອດໄຜ່ຮອງຮັບ',
    'sound_characteristics': 'ສຽງໃສ, ມີການສັ່ນສະເທືອນສັ້ນ',
    'playing_technique': 'ຕີດ້ວຍໄມ້ຕີຢ່າງໄວ',
    'construction': 'ແຜ່ນໄມ້ແຂງກັບຫລອດໄຜ່',
    'cultural_significance': 'ເຄື່ອງດົນຕີສຳຄັນໃນວົງດົນຕີລາວ',
    'history': 'ມາຈາກປະເພນີໄທ-ຂະແມ',
    'ceremonies': 'ໃຊ້ໃນງານບຸນປະເພນີແລະການສະແດງ',
    'modern_usage': 'ຮຽນໃນໂຮງຮຽນດົນຕີ',
    'pitch_range': '200-2000 Hz',
    'materials': 'ໄມ້, ໄຜ່',
    'difficulty': 'ສູງ',
    'ensemble_role': 'ທຳນອງຫຼັກ',
    'frequency_range': '200-4000 Hz',
    'dynamic_range': 'ສູງ',
    'attack_time': 'ໄວ (<20ms)',
    'sustain_type': 'ສັ້ນ',
    'ai_features': 'ການໂຈມຕີແຫຼມ, ສຽງໄມ້, ການຜ່ອນຄາຍສັ້ນ',
    'learning_tips': [
      'ຝຶກຄວາມແມ່ນຍຳຂອງການຕີ',
      'ຮຽນຮູ້ scale ພື້ນຖານ',
      'ຝຶກການເຄື່ອນໄຫວແຂນ',
      'ຝຶກຄວາມໄວ'
    ],
  };

  static final Map<String, dynamic> _sawData = {
    'emoji': '🎻',
    'name_lao': 'ຊໍອູ້',
    'name_english': 'So U',
    'description': 'ເຄື່ອງດົນຕີສາຍທີ່ມີສອງເສັ້ນໄຍ, ຄືດດ້ວຍໄມ້ຄືດ',
    'sound_characteristics': 'ສຽງລື່ນ, ສາມາດເລີຍສຽງຄືມະນຸດ',
    'playing_technique': 'ຄືດຄືກັບ violin ພ້ອມເທັກນິກການເລື່ອນສຽງ',
    'construction': 'ຫົວແຫວງມະພ້າວ, ເສັ້ນໄຍສອງເສັ້ນ, ໄມ້ຄືດ',
    'cultural_significance': 'ໃຊ້ສຳລັບການສະແດງອາລົມ',
    'history': 'ພັດທະນາມາແຕ່ສະໄໝໂບຮານ',
    'ceremonies': 'ການສະແດງເດີ່ຍແລະດົນຕີຈິດວິນຍານ',
    'modern_usage': 'ຍັງນິຍົມໃນການສະແດງປະຈຸບັນ',
    'pitch_range': '150-1000 Hz',
    'materials': 'ມະພ້າວ, ເສັ້ນໄຍ, ໄມ້',
    'difficulty': 'ສູງ',
    'ensemble_role': 'ທຳນອງຫຼັກ',
    'frequency_range': '150-2000 Hz',
    'dynamic_range': 'ສູງ',
    'attack_time': 'ປານກາງ (50-100ms)',
    'sustain_type': 'ຕໍ່ເນື່ອງ',
    'ai_features': 'ການຮັກສາສຽງລື່ນ, ການງ່ຽງສຽງ, ສຽງໄມ້ຄືດໃນຄວາມຖີ່ສູງ',
    'learning_tips': [
      'ຝຶກການຈັບເຄື່ອງມື',
      'ຮຽນຮູ້ເທັກນິກໄມ້ຄືດ',
      'ຝຶກການງ່ຽງສຽງ',
      'ຮຽນຮູ້ການສະແດງອາລົມ'
    ],
  };

  static final Map<String, dynamic> _singData = {
    'emoji': '🥁',
    'name_lao': 'ຊິ່ງ',
    'name_english': 'Sing',
    'description': 'ຈານເຫຼັກນ້ອຍສຳລັບການປະກອບຈັງຫວະ',
    'sound_characteristics': 'ສຽງໃສ, ແຫຼມ, ຜ່ອນໄວ',
    'playing_technique': 'ຕີກັນຫຼືຕີດ້ວຍໄມ້ຕີນ້ອຍ',
    'construction': 'ທອງເຫຼືອງຫຼືທອງແດງ',
    'cultural_significance': 'ໃຫ້ໂຄງສ້າງຈັງຫວະໃນວົງດົນຕີ',
    'history': 'ເປັນສ່ວນຂອງວົງດົນຕີແຕ່ໂບຮານ',
    'ceremonies': 'ຈັງຫວະໃນທຸກງານບຸນປະເພນີ',
    'modern_usage': 'ຍັງໃຊ້ໃນວົງດົນຕີທັນສະໄໝ',
    'pitch_range': '1000-8000 Hz',
    'materials': 'ທອງແດງ, ທອງເຫຼືອງ',
    'difficulty': 'ງ່າຍ',
    'ensemble_role': 'ຈັງຫວະ',
    'frequency_range': '1000-12000 Hz',
    'dynamic_range': 'ສູງ',
    'attack_time': 'ໄວຫຼາຍ (<10ms)',
    'sustain_type': 'ໄວຫຼາຍ',
    'ai_features': 'ການໂຈມຕີໄວຫຼາຍ, ສຽງໂລຫະສະຫວ່າງ, ການຜ່ອນໄວ',
    'learning_tips': [
      'ຝຶກການຈັບທີ່ຖືກຕ້ອງ',
      'ຮຽນຮູ້ຈັງຫວະພື້ນຖານ',
      'ຝຶກການປະສານກັບເຄື່ອງດົນຕີອື່ນ',
      'ຮຽນຮູ້ Dynamic control'
    ],
  };

  static final Map<String, dynamic> _unknownData = {
    'emoji': '❓',
    'name_lao': 'ບໍ່ຮູ້ຈັກ',
    'name_english': 'Unknown',
    'description': 'ສຽງທີ່ບໍ່ຕົງກັບເຄື່ອງດົນຕີລາວທີ່ຮູ້ຈັກ',
    'sound_characteristics': 'ລັກສະນະທີ່ຫຼາກຫຼາຍ',
    'playing_technique': 'ຈັງຫວະພື້ນຖານສະຫວ່າງຍັງໃຊ້ໃນບຸນປະເພນີ',
     'construction': 'ທອງເຫຼືອງຫຼືທອງແດງ',
    'cultural_significance': 'ໃຫ້ໂຄງສ້າງຈັງຫວະໃນວົງດົນຕີ',
    'history': 'ເປັນສ່ວນຂອງວົງດົນຕີແຕ່ໂບຮານ',
    'ceremonies': 'ຈັງຫວະໃນທຸກງານບຸນປະເພນີ',
    'modern_usage': 'ຍັງໃຊ້ໃນວົງດົນຕີທັນສະໄໝ',
    'pitch_range': '1000-8000 Hz',
    'materials': 'ທອງແດງ, ທອງເຫຼືອງ',
    'difficulty': 'ງ່າຍ',
    'ensemble_role': 'ຈັງຫວະ',
    'frequency_range': '1000-12000 Hz',
    'dynamic_range': 'ສູງ',
    'attack_time': 'ໄວຫຼາຍ (<10ms)',
    'sustain_type': 'ໄວຫຼາຍ',
    'ai_features': 'ການໂຈມຕີໄວຫຼາຍ, ສຽງໂລຫະສະຫວ່າງ, ການຜ່ອນໄວ',
    'learning_tips': [
      'ຝຶກການຈັບທີ່ຖືກຕ້ອງ',
      'ຮຽນຮູ້ຈັງຫວະພື້ນຖານ',
      'ຝຶກການປະສານກັບເຄື່ອງດົນຕີອື່ນ',
      'ຮຽນຮູ້ Dynamic control'
    ],
  };
}