import 'dart:math' as math;
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  int _itemCount = 100;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Text('List Item Count: '),
              Expanded(
                child: Slider(
                  value: _itemCount.toDouble(),
                  min: 10,
                  max: 1000,
                  divisions: 99,
                  label: _itemCount.toString(),
                  onChanged: (value) {
                    setState(() {
                      _itemCount = value.toInt();
                    });
                  },
                ),
              ),
              Text('$_itemCount'),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _itemCount,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(
                      (math.Random(index).nextDouble() * 0xFFFFFF).toInt(),
                    ).withOpacity(1.0),
                    child: Text('${index % 10}'),
                  ),
                  title: Text('List Item ${index + 1}'),
                  subtitle: const Text('This is a sample list item description text used to test performance.'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
