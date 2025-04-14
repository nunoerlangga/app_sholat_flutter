import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shalat_schedule_app/model/hijaiyah_model.dart';
import 'package:shalat_schedule_app/shared/shared.dart';
import 'package:shalat_schedule_app/views/huruf_hijaiyah_page.dart';

class ListHijaiyahPage extends StatefulWidget {
  const ListHijaiyahPage({super.key});

  @override
  State<ListHijaiyahPage> createState() => _ListHijaiyahPageState();
}

class _ListHijaiyahPageState extends State<ListHijaiyahPage> {
  List<HijaiyahModel> hijaiyahList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    loadHijaiyah();
  }

  Future<void> loadHijaiyah() async {
    await Future.delayed(const Duration(seconds: 1));
    final String response =
        await rootBundle.loadString('data/HurufHijaiyah.json');
    setState(() {
      hijaiyahList = HijaiyahModel.fromJsonList(response);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whitecolor,
        appBar: AppBar(
          backgroundColor: secondarycolor,
          centerTitle: true,
          title: Text(
            "Huruf Hijaiyah",
            style: TextStyle(color: whitecolor, fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemCount: hijaiyahList.length,
                itemBuilder: (context, index) {
                  final hijaiyah = hijaiyahList[index];

                  return ListTile(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HurufHijaiyahPage(
                              id: hijaiyah.urutan - 1,
                            ),
                          ))
                    },
                    leading: Text('${hijaiyah.urutan}.'),
                    title: Text(hijaiyah.nama,
                        style: TextStyle(
                          color: blackcolor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                    trailing: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: whitecolor,
                          border: Border.all(color: blackcolor, width: 2)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          (hijaiyah.huruf),
                          style: TextStyle(
                              color: blackcolor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 1,
                  color: Colors.grey.shade300,
                ),
              ));
  }
}
