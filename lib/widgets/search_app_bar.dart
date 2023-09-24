import 'package:cs310group1/utils/colors.dart';
import 'package:cs310group1/utils/dimensions.dart';
import 'package:flutter/material.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double height;
  static late String selectedCategory = 'All';
  static late String query = '';
  const SearchAppBar({
    Key? key,
    required this.height,
  }) : super(key: key);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _SearchAppBarState extends State<SearchAppBar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: 350,
      color: AppColors.appBarColor,
      padding: Dimen.searchAppBarPadding,
      child: Column(
        children: [
          const SizedBox(
            height: 25
          ),
          _searchBar(context),
          _categoryList(context),
    ],
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return Row(
      children: [
        Container(
          height: widget.height - 73,
          width: 40,
          padding: Dimen.left5Padding,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topLeft: Radius.circular(10)
              )
          ),
          child: const Icon(
            Icons.search,
            color: AppColors.searchBarIconColor,
          ),
        ),
        Container(
          height: widget.height - 73,
          width: 350,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(10),
                topRight: Radius.circular(10),
              )),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(
                color: AppColors.searchBarIconColor,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
            ),
            onSubmitted: (value) {
              setState(() {
                SearchAppBar.query = value;
                SearchAppBar.selectedCategory = '';
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _categoryList(BuildContext context) {
    return Container(
      height: widget.height - 85,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          OutlinedButton(
            onPressed: () {
              setState(() {
                SearchAppBar.query = '';
                SearchAppBar.selectedCategory = '';
              });
            },
            child: const Text("All"),
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                SearchAppBar.query = '';
                SearchAppBar.selectedCategory = 'Sports';
              });
            },
            child: const Text("Sports"),
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                SearchAppBar.query = '';
                SearchAppBar.selectedCategory = 'Ride';
              });
            },
            child: const Text("Ride"),
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                SearchAppBar.query = '';
                SearchAppBar.selectedCategory = 'Study';
              });
            },
            child: const Text("Study"),
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                SearchAppBar.query = '';
                SearchAppBar.selectedCategory = 'Movies';
              });
            },
            child: const Text("Movies"),
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                SearchAppBar.query = '';
                SearchAppBar.selectedCategory = 'Meal';
              });
            },
            child: const Text("Meal"),
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                SearchAppBar.query = '';
                SearchAppBar.selectedCategory = 'Event';
              });
            },
            child: const Text("Events"),
          ),
        ],
      ),
    );
  }
}