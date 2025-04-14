import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shalat_schedule_app/shared/shared.dart';
import 'package:shalat_schedule_app/viewmodel/viewmodel_surat.dart';
import 'package:audioplayers/audioplayers.dart';

class SuratPage extends StatefulWidget {
  final int? nomor;
  const SuratPage({super.key, this.nomor});

  @override
  State<SuratPage> createState() => _SuratPageState();
}

class _SuratPageState extends State<SuratPage> {
  late int nomorId;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    nomorId = widget.nomor ?? 1;
    Future.microtask(() => _fetchSurat());

    // Listener untuk mendeteksi perubahan status audio
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
  }

  void togglePlayPause(String url) async {
    PlayerState state = _audioPlayer.state;

    if (state == PlayerState.playing) {
      await _audioPlayer.pause();
    } else if (state == PlayerState.paused) {
      await _audioPlayer.resume();
    } else {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(url));
    }
  }

  void stopAudio() async {
    await _audioPlayer.stop();
  }

  void _fetchSurat() {
    context.read<SuratViewModel>().fetchSurat(nomorId);
  }

  void increment() {
    if (nomorId < 114) {
      setState(() {
        nomorId++;
      });
      _fetchSurat();
    }
  }

  void decrement() {
    if (nomorId > 1) {
      setState(() {
        nomorId--;
      });
      _fetchSurat();
    }
  }

  String convertToArabicNumber(int number) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number
        .toString()
        .split('')
        .map((digit) => arabicNumbers[int.parse(digit)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: whitecolor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Consumer<SuratViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Text(
                "Memuat...",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: whitecolor),
              );
            }
            if (viewModel.errorMessage != null) {
              return Text(
                "Terjadi Kesalahan",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: whitecolor),
              );
            }
            if (viewModel.surat == null) {
              return const Text("Data tidak ditemukan");
            }
            final surat = viewModel.surat!;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    surat.namaLatin!,
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: whitecolor),
                  ),
                  Text(
                    '(${surat.arti})',
                    style: TextStyle(
                        fontSize: 16, fontStyle: FontStyle.italic, color: whitecolor),
                  ),
                ],
              ),
            );
          },
        ),
        backgroundColor: secondarycolor,
      ),
      body: Consumer<SuratViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(child: Text('Error: ${viewModel.errorMessage}'));
          }

          if (viewModel.surat == null) {
            return const Center(child: Text('Data tidak ditemukan'));
          }

          final surat = viewModel.surat!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(decoration: BoxDecoration(color: thirdcolor),width: double.infinity,height: maxHeight * 0.004,),

              Container(
                decoration: BoxDecoration(color: primarycolor),
                width: double.infinity,
                height: maxHeight * 0.042,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: nomorId < 114 ? () { stopAudio(); decrement(); } : null,

                      icon: Icon(Icons.arrow_back_ios,
                          color: nomorId > 1 ? whitecolor : Colors.grey.shade400),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: whitecolor,
                          ),
                          onPressed: () {
                            if (surat.audioFull != null &&
                                surat.audioFull!['05'] != null) {
                              togglePlayPause(surat.audioFull!['05']!);
                            }
                          },
                        ),
                        IconButton(
                          onPressed: stopAudio,
                          icon: Icon(Icons.stop, color: whitecolor),
                        )
                      ],
                    ),
                    IconButton(
                      onPressed: nomorId < 114 ? () { stopAudio(); increment(); } : null,

                      
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: nomorId == 114 ? Colors.grey.shade400 : whitecolor,
                      ),
                    )
                  ],
                ),
              ),
              Container(decoration: BoxDecoration(color: thirdcolor),width: double.infinity,height: maxHeight * 0.004,),
              Expanded(
                child: ListView.separated(
                  itemCount: surat.ayat?.length ?? 0,
                  itemBuilder: (context, index) {
                    final ayat = surat.ayat![index];
                    return ListTile(
                  
                      title: Text(
                        '${ayat.teksArab} (${convertToArabicNumber(ayat.nomorAyat!)})',
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 20),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(10),
                          Text('[${ayat.nomorAyat}]',
                              style: const TextStyle(fontSize: 12)),
                          Text(ayat.teksIndonesia!),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => Divider(
                    height: 1,
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
