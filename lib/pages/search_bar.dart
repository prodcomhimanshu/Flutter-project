import 'package:flutter/material.dart';

class SearchBar1 extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearchPressed;

  const SearchBar1({
    Key? key,
    required this.controller,
    required this.onSearchPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(Icons.search),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              onSearchPressed(controller.text);
            },
          ),
        ],
      ),
    );
  }
}
