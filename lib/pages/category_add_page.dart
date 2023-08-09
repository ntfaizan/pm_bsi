import 'package:flutter/material.dart';

import '../utils/network_client.dart';

class CategoryAddPage extends StatelessWidget {
  CategoryAddPage({super.key, required this.initData});
  final Function initData;
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Name'),
            TextField(
              controller: nameController,
            ),
            SizedBox(
              width: double.maxFinite,
              child: FilledButton(
                onPressed: () {
                  saveCategory(context);
                },
                child: const Text('Save'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> saveCategory(BuildContext context) async {
    final param = {'name': nameController.text};
    final res =
        await NetworkClient().post('api/categories', bodyParameters: param);
    if (res.statusCode == 201) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Successfully Added')));
      nameController.clear();
      initData();
    }
  }
}
