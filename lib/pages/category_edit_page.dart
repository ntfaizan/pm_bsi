import 'package:flutter/material.dart';
import 'package:pm_bsi/models/category.dart';

import '../utils/network_client.dart';

class CategoryEditPage extends StatelessWidget {
  CategoryEditPage({super.key, required this.initData, required this.category});
  final Function initData;
  Category category;
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Name'),
            TextField(
              controller: nameController..text = category.name!,
            ),
            SizedBox(
              width: double.maxFinite,
              child: FilledButton(
                onPressed: () {
                  updateCategory(context);
                },
                child: const Text('Update'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateCategory(BuildContext context) async {
    final param = {'name': nameController.text};
    final res = await NetworkClient().post(
        'api/categories/${category.id}?_method=PUT',
        bodyParameters: param);
    if (res.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Successfully Updated')));
      nameController.clear();
      initData();
    }
  }
}
