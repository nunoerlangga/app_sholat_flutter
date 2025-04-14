import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shalat_schedule_app/model/surah_model.dart';
import 'package:shalat_schedule_app/shared/shared.dart';
import 'package:shalat_schedule_app/viewmodel/viewmodel_surah.dart';
import 'package:shalat_schedule_app/views/surat_page.dart';

class SurahPage extends StatefulWidget {
  const SurahPage({super.key});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SurahViewModel>().fetchSurah();

      // Pastikan nama fungsi benar
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    // double heightSize = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: whitecolor),
        backgroundColor: secondarycolor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "AL-Qur'an",
          style: TextStyle(color: whitecolor, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: whitecolor,
      body: Consumer<SurahViewModel>(builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (viewModel.errorMessage != null) {
          return Center(child: Text(viewModel.errorMessage!));
        } else if (viewModel.surah.isEmpty) {
          return const Center(child: Text('No surah available.'));
        } else {
          return ListView.separated(
            itemCount: viewModel.surah.length,
            itemBuilder: (context, index) {
              SurahModel surah = viewModel.surah[index];

              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SuratPage(nomor: surah.nomor!)));
                },
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${surah.nomor!}."),
                    const Gap(8),
                    Expanded(
                      child: Wrap(
                        children: [
                          Text(
                            "${surah.arti!} (${surah.namaLatin!})",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        surah.nama!,
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
                leading: surah.tempatTurun! == "Mekah"
                    ? Image.asset(
                        'assets/kabah.png',
                        width: widthSize * 0.075,
                      )
                    : surah.tempatTurun! == "Madinah"
                        ? Image.asset(
                            'assets/masjid.png',
                            width: widthSize * 0.07,
                          )
                        : null,
              );
            },
            separatorBuilder: (BuildContext context, int index) => Divider(
              height: 1,
              color: Colors.grey.shade300,
            ),
          );
        }
      }),
    );
  }
}
