import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final bool show;
  final ValueChanged<String>? onChanged;

  const SearchField({Key? key, required this.onChanged, required this.show})
      : super(key: key);
  @override
  State<SearchField> createState() {
    return _SearchFieldState();
  }
}

class _SearchFieldState extends State<SearchField>
    with TickerProviderStateMixin {
  late AnimationController animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200));
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() => widget.onChanged?.call(searchController.text));
    });
  }

  @override
  void didUpdateWidget(covariant SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
          parent: animationController, curve: Curves.easeInOut)),
      child: Container(
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => searchController.clear()),
                isDense: true,
                border: const OutlineInputBorder(),
                hintText: 'Search credential'),
          ),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(230, 230, 230, 1.0),
          )),
    );
  }
}
