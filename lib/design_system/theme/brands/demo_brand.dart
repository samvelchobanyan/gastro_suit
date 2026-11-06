import 'package:flutter/painting.dart';

import '../ds_brand.dart';

/// Not a client. A deliberately different accent, used to check that every
/// brand value follows the theme: anything still red under this brand is
/// read outside `Theme.of(context)`.
const demoBrand = DSBrand(
  accent50: Color(0xFFEEF2FF),
  accent100: Color(0xFFE0E7FF),
  accent200: Color(0xFFC7D2FE),
  accent300: Color(0xFFA5B4FC),
  accent400: Color(0xFF818CF8),
  accent500: Color(0xFF6366F1),
  accent600: Color(0xFF4F46E5),
  accent700: Color(0xFF4338CA),
  accent800: Color(0xFF3730A3),
  accent900: Color(0xFF312E81),
  accentContrast: Color(0xFFFFFFFF),
);
