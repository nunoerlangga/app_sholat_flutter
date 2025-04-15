import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shalat_schedule_app/model/hukumtajwid_model.dart';
import 'package:shalat_schedule_app/shared/shared.dart';

class HukumTajwidPage extends StatefulWidget {
  const HukumTajwidPage({super.key});

  @override
  State<HukumTajwidPage> createState() => _HukumTajwidPageState();
}

class _HukumTajwidPageState extends State<HukumTajwidPage> {
  Future<List<Tajwid>> loadTajwid() async {
    final String response =
        await rootBundle.loadString('data/HukumTajwid.json');
    final data = json.decode(response);
    final tajwidMap = data['tajwid'] as Map<String, dynamic>;

    // Gabungkan semua hukum dari nun, mim, dan lainnya ke satu list
    final List<dynamic> allTajwid = [
      ...tajwidMap['nun_sukun_dan_tanwin'],
      ...tajwidMap['mim_sukun'],
      ...tajwidMap['lainnya'],
    ];

    return allTajwid.map((item) => Tajwid.fromJson(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: secondarycolor,
        title: Text(
          'Hukum Tajwid',
          style: TextStyle(color: whitecolor, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Tajwid>>(
        future: loadTajwid(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          item.nama,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              if (item.keterangan != null &&
                                  item.keterangan!.isNotEmpty) ...[
                                for (var part
                                    in ("${item.pengertian} ${item.keterangan!}")
                                        .split(" "))
                                  TextSpan(
                                    text: "$part ",
                                    style: TextStyle(
                                      fontSize: part.contains('مْ') ||
                                              part.contains('نْ') ||
                                              part.contains("م") ||
                                              part.contains("ب") ||
                                              part.contains(
                                                  "(ــًــ ــٍــ ــٌــ)")
                                          ? 24
                                          : 16,
                                    ),
                                  )
                              ] else ...[
                                TextSpan(
                                  text: item.pengertian,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                )
                              ]
                            ],
                          ),
                        ),
                        if (item.tingkatan != null &&
                            item.tingkatan!.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: item.tingkatan!
                                .map((tingkatan) => Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text(tingkatan.nama),
                                            Text(
                                              tingkatan.keterangan,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        if (item.huruf != null && item.huruf!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Text('Di bawah ini adalah huruf dari ${item.nama}:'
                                      ),
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 12,
                                    runSpacing: 4.0,
                                    children: item.huruf!
                                        .map((huruf) => Column(
                                              children: [
                                                Text(
                                                  huruf,
                                                  style: const TextStyle(
                                                      fontSize: 24),
                                                ),
                                              ],
                                            ))
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (item.jenis != null && item.jenis!.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: item.jenis!
                                .map((jenis) => Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(jenis.nama),
                                            Text(
                                              jenis.keterangan,
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              'Di bawah ini adalah huruf dari ${jenis.nama}:'
                                                  ,
                                              textAlign: TextAlign.center,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: jenis.huruf
                                                  .map((huruf) => Text(
                                                        huruf,
                                                        style: const TextStyle(
                                                            fontSize: 24),
                                                      ))
                                                  .toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                      ]),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                thickness: 2,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
