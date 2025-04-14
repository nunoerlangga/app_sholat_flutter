import 'package:flutter/material.dart';
import 'package:hijriyah_indonesia/hijriyah_indonesia.dart';
import 'package:provider/provider.dart';
import 'package:shalat_schedule_app/shared/pages_shared.dart';
import 'package:shalat_schedule_app/viewmodel/viewmodel_doa.dart';
import 'package:shalat_schedule_app/viewmodel/viewmodel_listdoa.dart';
import 'package:shalat_schedule_app/viewmodel/viewmodel_surah.dart';
import 'package:shalat_schedule_app/viewmodel/viewmodel_surat.dart';
import 'package:shalat_schedule_app/views/hukum_tajwid_page.dart';

void main() {
   Hijriyah.setLocal('id');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DoaViewModel>(create: (_) => DoaViewModel()),
        ChangeNotifierProvider<ListDoaViewModel>(create: (_) => ListDoaViewModel()),
        ChangeNotifierProvider<ScheduleViewModel>(create: (_) => ScheduleViewModel()),
        ChangeNotifierProvider<KotaViewModel>(create: (_) => KotaViewModel()),
        ChangeNotifierProvider<SurahViewModel>(create: (_) => SurahViewModel()),
        ChangeNotifierProvider<SuratViewModel>(create: (_) => SuratViewModel()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HukumTajwidPage(),
      ),
    );
  }
}
