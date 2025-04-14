part of '../shared/pages_shared.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSavedCity();
  }

  Future<void> _checkSavedCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedCityId = prefs.getString("selected_city_id");

    await Future.delayed(const Duration(seconds: 2)); // Simulasi splash delay

    if (savedCityId != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MenuPage(id: savedCityId)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const KotaPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Image.asset(
          "assets/splashscreen.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
