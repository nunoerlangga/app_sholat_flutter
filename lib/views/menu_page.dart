part of '../shared/pages_shared.dart';

class MenuPage extends StatefulWidget {
  final String? id;
  const MenuPage({super.key, this.id});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String _currentTime = DateFormat('HH:mm').format(DateTime.now());
  String _countdownText = "";
  Timer? _countdownTimer;
  Timer? _timeUpdateTimer;
  final PageController _pageController = PageController(viewportFraction: 1);
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    String locationId = widget.id!;
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    int day = DateTime.now().day;

    Future.microtask(() {
      context
          .read<ScheduleViewModel>()
          .fetchSholatSchedule(locationId, year, month, day)
          .then((_) {
        final schedule = context.read<ScheduleViewModel>().schedule;
        if (mounted && schedule != null) {
          _startCurrentTimeUpdater(); // Update jam real-time
          _startCountdownToNextPrayer(schedule); // Countdown sholat otomatis
        }
      });
    });
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentIndex < goodWords.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startCurrentTimeUpdater() {
    _timeUpdateTimer?.cancel();
    _timeUpdateTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _currentTime = DateFormat('HH:mm').format(DateTime.now());
      });
    });
  }

  void _startCountdownToNextPrayer(ScheduleModel schedule) {
    DateTime now = DateTime.now();
    Map<String, String> prayerTimes = {
      "Subuh": schedule.subuh!,
      "Dzuhur": schedule.dzuhur!,
      "Ashar": schedule.ashar!,
      "Maghrib": schedule.maghrib!,
      "Isya": schedule.isya!,
    };

    // Urutkan berdasarkan jam-nya
    final sortedPrayerTimes = prayerTimes.entries
        .map((entry) {
          final parts = entry.value.split(":");
          final time = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(parts[0]),
            int.parse(parts[1]),
          );
          return MapEntry(entry.key, time);
        })
        .where((entry) => entry.value.isAfter(now))
        .toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    if (sortedPrayerTimes.isNotEmpty) {
      final next = sortedPrayerTimes.first;
      final nextPrayerName = next.key;
      final nextPrayerTime = next.value;

      _countdownTimer?.cancel();
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final now = DateTime.now();
        final diff = nextPrayerTime.difference(now);

        if (diff.isNegative) {
          timer.cancel();
          setState(() {
            _countdownText = "Waktu sholat $nextPrayerName telah tiba!";
          });

          Future.delayed(const Duration(minutes: 5), () {
            _startCountdownToNextPrayer(schedule);
          });
        } else {
          setState(() {
            _countdownText =
                "Menuju $nextPrayerName: ${diff.inHours.toString().padLeft(2, '0')}:${(diff.inMinutes % 60).toString().padLeft(2, '0')}:${(diff.inSeconds % 60).toString().padLeft(2, '0')}";
          });
        }
      });
    } else {
      // Semua jadwal hari ini sudah lewat → opsional: ambil jadwal besok
      setState(() {
        _countdownText = "Semua jadwal hari ini sudah lewat.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Consumer<ScheduleViewModel>(builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (viewModel.errorMessage != null) {
          return Center(child: Text(viewModel.errorMessage!));
        } else if (viewModel.schedule == null) {
          return const Center(child: Text('No schedule available.'));
        } else {
          final schedule = viewModel.schedule!;
          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                  width: double.infinity,
                  height: heightSize * 1,
                  child: Image.asset(
                    "assets/bgmenu.png",
                    fit: BoxFit.cover,
                  )),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: heightSize * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Hijriyah.fromDate(DateTime.now())
                                            .toFormat("dd MMMM yyyy"),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          "${schedule.lokasi}, ${schedule.daerah}",
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const KotaPage(
                                                      clearSavedCity: true,
                                                    )))
                                      },
                                  icon: const Icon(
                                    Icons.location_pin,
                                    color: Colors.white,
                                    size: 30,
                                  ))
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_currentTime,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold)),
                              _countdownText.isEmpty
                                  ? const Text("Memuat......",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold))
                                  : Text(_countdownText,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  const Text("Subuh",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        width: widthSize * 0.08,
                                        child: Image.asset(
                                          'assets/subuh.png',
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  Text("${schedule.subuh}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              Column(
                                children: [
                                  const Text("Dzuhur",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        width: widthSize * 0.08,
                                        child: Image.asset(
                                          'assets/dzuhur.png',
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  Text("${schedule.dzuhur}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              Column(
                                children: [
                                  const Text("Ashar",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        width: widthSize * 0.08,
                                        child: Image.asset(
                                          'assets/ashar.png',
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  Text("${schedule.ashar}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              Column(
                                children: [
                                  const Text("Magrib",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        width: widthSize * 0.08,
                                        child: Image.asset(
                                          'assets/magrib.png',
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  Text("${schedule.maghrib}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              Column(
                                children: [
                                  const Text("Isya",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        width: widthSize * 0.05,
                                        child: Image.asset(
                                          'assets/isya.png',
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  Text("${schedule.isya}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: heightSize * 0.5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(widthSize * 0.1),
                            topRight: Radius.circular(widthSize * 0.1)),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 24, bottom: 12, left: 12, right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: widthSize * 0.22,
                                height: heightSize * 0.11,
                                child: ZoomTapAnimation(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SurahPage())),
                                  child: Card(
                                    color: secondarycolor,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                                width: widthSize * 0.12,
                                                height: heightSize * 0.06,
                                                child: Image.asset(
                                                    "assets/al-Quran.png")),
                                            const Gap(4),
                                            Text(
                                              "Al-Quran",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: whitecolor,
                                                  fontSize: 9.5),
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: widthSize * 0.22,
                                height: heightSize * 0.11,
                                child: ZoomTapAnimation(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ListDoaPage())),
                                  child: Card(
                                    color: secondarycolor,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                                width: widthSize * 0.12,
                                                height: heightSize * 0.06,
                                                child: Image.asset(
                                                    "assets/doa-harian.png")),
                                            const Gap(4),
                                            Text(
                                              "Doa Harian",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: whitecolor,
                                                  fontSize: 9.5),
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: widthSize * 0.22,
                                height: heightSize * 0.11,
                                child: ZoomTapAnimation(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AsmaulHusnaPage())),
                                  child: Card(
                                    color: secondarycolor,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                                width: widthSize * 0.12,
                                                height: heightSize * 0.06,
                                                child: Image.asset(
                                                    "assets/asmaul-husna.png")),
                                            const Gap(4),
                                            Text(
                                              "Asmaul Husna",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: whitecolor,
                                                  fontSize: 9.5),
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: widthSize * 0.22,
                                height: heightSize * 0.11,
                                child: ZoomTapAnimation(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ListHijaiyahPage())),
                                  child: Card(
                                    color: secondarycolor,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                                width: widthSize * 0.12,
                                                height: heightSize * 0.06,
                                                child: Image.asset(
                                                    "assets/huruf-hijaiyah.png")),
                                            const Gap(4),
                                            Text(
                                              "Huruf Hijaiyah",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: whitecolor,
                                                  fontSize: 9.5),
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PageView.builder(
                                controller: _pageController,
                                itemCount: goodWords.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Card(
                                    color: secondarycolor,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20,
                                          left: 40,
                                          bottom: 20,
                                          right: 40),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            goodWords[index].words,
                                            style: TextStyle(
                                                color: whitecolor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                goodWords[index].person,
                                                style: TextStyle(
                                                  color: whitecolor,
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ))
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          );
        }
      }),
    );
  }
}
