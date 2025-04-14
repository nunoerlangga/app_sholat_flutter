import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shalat_schedule_app/model/hijaiyah_model.dart';
import 'package:shalat_schedule_app/shared/shared.dart';

class HurufHijaiyahPage extends StatefulWidget {
  final int id;
  
  const HurufHijaiyahPage({super.key, required this.id,});

  @override
  State<HurufHijaiyahPage> createState() => _HurufHijaiyahPageState();
}

class _HurufHijaiyahPageState extends State<HurufHijaiyahPage> {
   List<HijaiyahModel> hijaiyahList = [];
  bool isLoading = true;
  late int arrayId;
  @override
  void initState() {
    super.initState();
    loadHijaiyah();
  }

  Future<void> loadHijaiyah() async {
    await Future.delayed(const Duration(seconds: 1));
    final String response =
        await rootBundle.loadString('data/HurufHijaiyah.json');
        arrayId = widget.id;
    setState(() {
      hijaiyahList = HijaiyahModel.fromJsonList(response);
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
          backgroundColor: secondarycolor,
          centerTitle: true,
          title: Text(
            "Huruf Hijaiyah",
            style: TextStyle(color: whitecolor, fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
        ),
      backgroundColor: whitecolor,
      
      body: isLoading 
            ? const Center(child: CircularProgressIndicator()):
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                  Text(hijaiyahList[arrayId].nama ,style: TextStyle(
                                    color: blackcolor,
                                    fontSize: 55,
                                    fontWeight: FontWeight.bold),),
                  Text(hijaiyahList[arrayId].huruf ,style: TextStyle(
                                    color: blackcolor,
                                    fontSize: 120,
                                    fontWeight: FontWeight.bold),),]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                             Column(
                               children: [
                                 Text(hijaiyahList[arrayId].baca[2],style: TextStyle(
                                        color: blackcolor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),),
                                         Text(hijaiyahList[arrayId].harakat[2],style: TextStyle(
                                color: blackcolor,
                                fontSize: 55,
                                fontWeight: FontWeight.bold),),
                               ],
                             ),
                             Column(
                               children: [
                                 Text(hijaiyahList[arrayId].baca[1],style: TextStyle(
                                        color: blackcolor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),),
                                         Text(hijaiyahList[arrayId].harakat[2],style: TextStyle(
                                color: blackcolor,
                                fontSize: 55,
                                fontWeight: FontWeight.bold),),
                               ],
                             ),
                             Column(
                               children: [
                                 Text(hijaiyahList[arrayId].baca[0],style: TextStyle(
                                        color: blackcolor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),),
                                         Text(hijaiyahList[arrayId].harakat[0],style: TextStyle(
                                color: blackcolor,
                                fontSize: 55,
                                fontWeight: FontWeight.bold),),
                               ],
                             ),
                            
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                             Column(
                               children: [
                                 Text(hijaiyahList[arrayId].baca[5],style: TextStyle(
                                        color: blackcolor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),),
                                         Text(hijaiyahList[arrayId].harakat[5],style: TextStyle(
                                color: blackcolor,
                                fontSize: 55,
                                fontWeight: FontWeight.bold),),
                               ],
                             ),
                             Column(
                               children: [
                                 Text(hijaiyahList[arrayId].baca[4],style: TextStyle(
                                        color: blackcolor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),),
                                         Text(hijaiyahList[arrayId].harakat[4],style: TextStyle(
                                color: blackcolor,
                                fontSize: 55,
                                fontWeight: FontWeight.bold),),
                               ],
                             ),
                             Column(
                               children: [
                                 Text(hijaiyahList[arrayId].baca[3],style: TextStyle(
                                        color: blackcolor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),),
                                         Text(hijaiyahList[arrayId].harakat[3],style: TextStyle(
                                color: blackcolor,
                                fontSize: 55,
                                fontWeight: FontWeight.bold),),
                               ],
                             ),
                            
                          ],
                        ),
                        
                ],
              ),
            ),
    );
  }
}
