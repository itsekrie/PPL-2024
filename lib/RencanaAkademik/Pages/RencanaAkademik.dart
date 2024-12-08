import 'package:flutter/material.dart';

class RencanaAkademik extends StatefulWidget {
  const RencanaAkademik({super.key});

  @override
  State<RencanaAkademik> createState() => _RencanaAkademikState();
}

class _RencanaAkademikState extends State<RencanaAkademik> {
  List<Map<String, String>> items = [];

  void addItem() {
    setState(() {
      items.add({'name': '', 'description': ''});
    });
  }

  void removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repeater Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                items[index]['name'] = value;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Name',
                            ),
                          ),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                items[index]['description'] = value;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Description',
                            ),
                          ),
                          IconButton(
                            onPressed: () => removeItem(index),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: addItem,
              child: const Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}
