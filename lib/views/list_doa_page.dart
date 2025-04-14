import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shalat_schedule_app/model/listdoa_model.dart';
import 'package:shalat_schedule_app/shared/shared.dart';
import 'package:shalat_schedule_app/viewmodel/viewmodel_listdoa.dart';
import 'package:shalat_schedule_app/views/doa_page.dart';

class ListDoaPage extends StatefulWidget {
  const ListDoaPage({super.key});

  @override
  State<ListDoaPage> createState() => _ListDoaPageState();
}

class _ListDoaPageState extends State<ListDoaPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ListDoaViewModel>().fetchListDoa();

      // Pastikan nama fungsi benar
    });
  }

  @override
  Widget build(BuildContext context) {
    // double widthSize = MediaQuery.of(context).size.width;
    // double heightSize = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: whitecolor),
        backgroundColor: secondarycolor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Doa Harian',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: whitecolor,
      body: Consumer<ListDoaViewModel>(builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (viewModel.errorMessage != null) {
          return Center(child: Text(viewModel.errorMessage!));
        } else if (viewModel.listModel.isEmpty) {
          return const Center(child: Text('No listModel available.'));
        } else {
          return ListView.separated(
            itemCount: viewModel.listModel.length,
            itemBuilder: (context, index) {
              ListDoaModel listDoaModel = viewModel.listModel[index];

              return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DoaPage(id: listDoaModel.id!)));
                  },
                  title: Text(
                    listDoaModel.doa!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ));
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
