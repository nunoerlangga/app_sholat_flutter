import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shalat_schedule_app/model/doa_model.dart';
import 'package:shalat_schedule_app/shared/shared.dart';
import 'package:shalat_schedule_app/viewmodel/viewmodel_doa.dart';

class DoaPage extends StatefulWidget {
  final int id;
  const DoaPage({super.key, required this.id});

  @override
  State<DoaPage> createState() => _DoaPageState();
}

class _DoaPageState extends State<DoaPage> {
  late int idSekarang;
  int get idSebelum => (idSekarang == 1) ? 37 : idSekarang - 1;
  int get idSetelah => (idSekarang == 37) ? 1 : idSekarang + 1;

  @override
  void initState() {
    super.initState();
    idSekarang = widget.id;
    Future.microtask(() => _fetchDoa());
  }

  void _fetchDoa() {
    context.read<DoaViewModel>().fetchDoa(idSekarang, idSebelum, idSetelah);
  }

  void increment() {
    setState(() {
      idSekarang = (idSekarang < 37) ? idSekarang + 1 : 1;
      _fetchDoa();
    });
  }

  void decrement() {
    setState(() {
      idSekarang = (idSekarang > 1) ? idSekarang - 1 : 37;
      _fetchDoa();
    });
  }

  @override
  Widget build(BuildContext context) {
    // double widthSize = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondarycolor,
        iconTheme: IconThemeData(color: whitecolor),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Consumer<DoaViewModel>(builder: (context,viewModel,child){
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
            if (viewModel.doaSekarang == null) {
              return const Text("Data tidak ditemukan");
            }
        final doaNow = viewModel.doaSekarang ?? DoaModel(doa: "Sekarang");
          return Text(doaNow.doa!, style: TextStyle(color: whitecolor,fontWeight: FontWeight.bold),);
        }),
      ),
      backgroundColor: whitecolor,
      body: Consumer<DoaViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.errorMessage != null) {
            return Center(child: Text(viewModel.errorMessage!));
          } else if (viewModel.doaSebelum == null &&
              viewModel.doaSekarang == null &&
              viewModel.doaSesudah == null) {
            return const Center(child: Text('No Doa available.'));
          } else {
            final doaSebelum =
                viewModel.doaSebelum ?? DoaModel(doa: "Sebelumnya");
            final doaSekarang =
                viewModel.doaSekarang ?? DoaModel(doa: "Sekarang");
            final doaSesudah = viewModel.doaSesudah ?? DoaModel(doa: "Sesudah");

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              doaSekarang.ayat!,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          const Gap(10),
                          Text(
                            doaSekarang.latin!,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          const Divider(),
                          Text(
                            'Artinya: ${doaSekarang.artinya}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),

                // Tombol Navigasi Sebelumnya & Setelahnya (Tetap di posisi)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: decrement,
                          child: Text(
                            doaSebelum.doa!.toUpperCase(),
                            style: TextStyle(
                                color: primarycolor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: primarycolor,
                                decorationThickness: 2),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const Gap(6),
                      Expanded(
                        child: InkWell(
                          onTap: increment,
                          child: Text(
                            doaSesudah.doa!.toUpperCase(),
                            style: TextStyle(
                                color: primarycolor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: primarycolor,
                                decorationThickness: 2),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
