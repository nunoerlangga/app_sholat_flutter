import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shalat_schedule_app/model/kota_model.dart';
import 'package:shalat_schedule_app/shared/pages_shared.dart';
import 'package:shalat_schedule_app/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KotaPage extends StatefulWidget {
  final bool clearSavedCity;
  const KotaPage({super.key,  this.clearSavedCity = false});

  @override
  State<KotaPage> createState() => _KotaPageState();
}

class _KotaPageState extends State<KotaPage> {
  TextEditingController searchController = TextEditingController();
  List<KotaModel> filteredKota = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
       if (widget.clearSavedCity) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove("selected_city_id");
    }
      context.read<KotaViewModel>().fetchKota();
      String? savedCityId = await _getSavedCity();
      if (savedCityId != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MenuPage(id: savedCityId),
          ),
        );
      }
    });
  }

  Future<void> _saveCity(String cityId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("selected_city_id", cityId);
  }

  Future<String?> _getSavedCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("selected_city_id");
  }

  void _filterKota(List<KotaModel> kotaList) {
    setState(() {
      filteredKota = kotaList
          .where((kota) => kota.lokasi!
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
      filteredKota.sort((a, b) => a.lokasi!.compareTo(b.lokasi!)); // Urutkan A-Z
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthSize = MediaQuery.of(context).size.width;
    double heightSize = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: whitecolor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: secondarycolor,
        title: Text(
          'Daftar Kota',
          style: TextStyle(color: whitecolor, fontWeight: FontWeight.bold),
        ),
        
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14,top: 8,bottom: 8),
            child: SizedBox(
              width: widthSize * 0.42,
              height: heightSize * 0.38,
              child: TextField(
                controller: searchController,
                onChanged: (value) => _filterKota(context.read<KotaViewModel>().kotaModel),
                style: TextStyle(color: blackcolor),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0, horizontal: 16),
                ),
              ),
            ),
          )
        ],
      ),
      body: Consumer<KotaViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.errorMessage != null) {
            return Center(child: Text(viewModel.errorMessage!));
          } else if (viewModel.kotaModel.isEmpty) {
            return const Center(child: Text('Tidak ada data kota.'));
          } else {
            if (filteredKota.isEmpty || searchController.text.isEmpty) {
              filteredKota = List.from(viewModel.kotaModel);
              filteredKota.sort((a, b) => a.lokasi!.compareTo(b.lokasi!)); // Urutkan A-Z
            }
            return ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: filteredKota.length,
              itemBuilder: (context, index) {
                KotaModel city = filteredKota[index];
                return ListTile(
                  title: Text(city.lokasi ?? "Tidak diketahui"),
                  onTap: () async {
                    await _saveCity(city.id!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuPage(id: city.id!),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (_, __) => Divider(
                color: Colors.grey.shade300,
                thickness: 1,
              ),
            );
          }
        },
      ),
    );
  }
}
