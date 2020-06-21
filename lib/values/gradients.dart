part of values;

//enum GradientColors { curvesGradient0, curvesGradient1, curvesGradient2, curvesGradient3, curvesGradient4 }

List<LinearGradient> GradientColors = [Gradients.curvesGradient0, Gradients.curvesGradient1, Gradients.curvesGradient2, Gradients.curvesGradient3, Gradients.curvesGradient4];

class Gradients {
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      AppColors.green,
      AppColors.greenShade1,
    ],
  );

  static const LinearGradient curvesGradient0 = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xff12c2e9),
      Color(0xffc471ed),
      Color(0xfff64f59),
    ],
  );

  static const LinearGradient curvesGradient1 = LinearGradient(
    colors: [
      AppColors.orange,
      AppColors.orangeShade1,
      AppColors.deepOrange,
    ],
  );

  static const LinearGradient curvesGradient2 = LinearGradient(
    colors: [
      Color(0xff4e54c8),
      Color(0xff4e54c8),
    ],
  );

  static const LinearGradient curvesGradient3 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff0f0c29),
      Color(0xFF302b63),
      Color(0xFF24243e),
    ],
  );

  static const LinearGradient curvesGradient4 = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xff4e54c8),
      Color(0xff8f94fb),
    ],
  );

  static const Gradient headerOverlayGradient = LinearGradient(
    begin: Alignment(0.51436, 1.07565),
    end: Alignment(0.51436, -0.03208),
    stops: [
      0,
      0.17571,
      1,
    ],
    colors: [
      Color.fromARGB(255, 0, 0, 0),
      Color.fromARGB(255, 8, 8, 8),
      Color.fromARGB(105, 45, 45, 45),
    ],
  );
}
