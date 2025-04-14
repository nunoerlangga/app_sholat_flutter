import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shalat_schedule_app/model/asmaulhusna_model.dart';
import 'package:shalat_schedule_app/shared/shared.dart';

class AsmaulHusnaPage extends StatefulWidget {
  const AsmaulHusnaPage({super.key});

  @override
  State<AsmaulHusnaPage> createState() => _AsmaulHusnaPageState();
}

class _AsmaulHusnaPageState extends State<AsmaulHusnaPage>{
  List<AsmaulHusna> asmaulHusnaList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAsmaulHusna();
  }

  Future<void> loadAsmaulHusna() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulasi loading
    final String response =
        await rootBundle.loadString('data/AsmaulHusna.json');
    setState(() {
      asmaulHusnaList = AsmaulHusna.fromJsonList(response);
      isLoading = false;
    });
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
    // double maxWidth = MediaQuery.of(context).size.width;
    // double maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: whitecolor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: whitecolor),
        title: Text(
          "Asmaul Husna",textAlign: TextAlign.center,
          style: TextStyle(color: whitecolor, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: secondarycolor,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: asmaulHusnaList.length,
              itemBuilder: (context, index) {
                final asma = asmaulHusnaList[index];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: whitecolor,
                          border: Border.all(color: blackcolor, width: 2)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          convertToArabicNumber(asma.urutan),
                          style: TextStyle(
                              color: blackcolor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                    ),
                    title: Column(
                      children: [
                        Text(
                          asma.arab,
                          style: TextStyle(
                              color: blackcolor,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(asma.latin,
                            style: TextStyle(
                              color: blackcolor,
                              fontSize: 18,
                            ))
                      ],
                    ),
                    subtitle: Text(
                      asma.arti,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: blackcolor),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 1,
                color: Colors.grey.shade300,
              ),
            ),
    );
  }
}
