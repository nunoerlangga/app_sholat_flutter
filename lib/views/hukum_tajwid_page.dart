import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shalat_schedule_app/model/hukumtajwid_model.dart';

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
      body: FutureBuilder<List<Tajwid>>(
        future: loadTajwid(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(item.nama),
                        Text(item.keterangan != null &&
                                item.keterangan!.isNotEmpty
                            ? item.pengertian + item.keterangan!
                            : item.pengertian),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: item.huruf!
                                .map((huruf) => Text(huruf))
                                .toList(),
                          ),
                        if (item.jenis != null && item.jenis!.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: item.jenis!
                                .map((jenis) => Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Text(jenis.nama),
                                            Text(
                                              jenis.keterangan,
                                              textAlign: TextAlign.center,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: jenis.huruf
                                                  .map((huruf) => Text(huruf))
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
                  const Divider(thickness: 2,),
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
