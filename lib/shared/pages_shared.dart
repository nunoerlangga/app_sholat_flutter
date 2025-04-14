import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hijriyah_indonesia/hijriyah_indonesia.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shalat_schedule_app/model/good_words.dart';
import 'package:shalat_schedule_app/model/schedule_model.dart';
import 'package:provider/provider.dart';
import 'package:shalat_schedule_app/model/kota_model.dart';
import 'package:shalat_schedule_app/shared/shared.dart';
import 'package:shalat_schedule_app/views/asmaul_husna_page.dart';
import 'package:shalat_schedule_app/views/kota_page.dart';
import 'package:shalat_schedule_app/views/list_doa_page.dart';
import 'package:shalat_schedule_app/views/list_hijaiyah_page.dart';
import 'package:shalat_schedule_app/views/surah_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
part '../viewmodel/viewmodel_kota.dart';
part '../viewmodel/viewmodel_schedule.dart';


part '../views/menu_page.dart';
part '../views/splash_screen.dart';
