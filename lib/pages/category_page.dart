import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pm_bsi/pages/category_add_page.dart';
import 'package:pm_bsi/utils/network_client.dart';

import '../models/category.dart';
import 'category_edit_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Category> categoryList = [];

  @override
  void initState() {
    initData();
    super.initState();
  }

  Future<void> initData() async {
    final res = await NetworkClient().get('api/categories');
    // json.decode(res.toString());
    Map<String, dynamic> mp = jsonDecode(res.toString());
    categoryList =
        (mp['data'] as List).map((e) => Category.fromJson(e)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CategoryAddPage(initData: initData),
                ),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: categoryList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categoryList.length,
              itemBuilder: (context, index) => Card(
                child: Row(
                  children: [
                    CircleAvatar(
                      child: Text('${categoryList[index].id}'),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${categoryList[index].name}'),
                        Row(
                          children: [
                            Text('Created: ${categoryList[index].createdAt}'),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CategoryEditPage(
                                    initData: initData,
                                    category: categoryList[index],
                                  ),
                                ));
                              },
                              icon: const Icon(Icons.edit),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Updated: ${categoryList[index].updatedAt}'),
                            IconButton(
                              onPressed: () {
                                deleteCategory(categoryList[index].id!);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> deleteCategory(int id) async {
    final res = await NetworkClient().delete('api/categories/$id');
    if (res.statusCode == 200) {
      initData();
    }
  }
}
