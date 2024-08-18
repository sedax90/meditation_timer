import 'package:flutter/material.dart';
import 'package:meditation_timer/themes/app_theme.dart';

class SelectionSlider<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final T? selectedItem;
  final Function(T)? onItemSelect;
  final bool disabled;
  final bool lightTheme;

  const SelectionSlider({
    super.key,
    required this.title,
    required this.items,
    this.selectedItem,
    this.onItemSelect,
    this.disabled = false,
    this.lightTheme = false,
  });

  @override
  State<StatefulWidget> createState() => _SelectionSliderState<T>();
}

class _SelectionSliderState<T> extends State<SelectionSlider<T>> {
  T? _selectedItem;

  @override
  void initState() {
    super.initState();

    if (widget.selectedItem != null) {
      _selectedItem = widget.selectedItem;
    } else {
      _selectedItem = widget.items.isNotEmpty ? widget.items.first : null;
    }
  }

  void _onItemTap(final T item) {
    setState(() {
      _selectedItem = item;
    });

    if (widget.onItemSelect != null) {
      widget.onItemSelect!(item);
    }
  }

  Color getColor() {
    return widget.lightTheme ? AppColors.darkGreen : AppColors.lightGreen;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            widget.title,
            style: TextStyle(
              fontFamily: AppFonts.secondary,
              fontStyle: FontStyle.italic,
              color: getColor(),
              fontSize: 30,
            ),
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: widget.disabled == true ? 0.5 : 1.0,
          child: Container(
            height: 35,
            alignment: Alignment.center,
            child: widget.items.isEmpty
                ? Container()
                : ListView.builder(
                    itemCount: widget.items.length,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    physics:
                        widget.disabled ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      final isSelected = item == _selectedItem;
                      final isLast = index == widget.items.length - 1;

                      return GestureDetector(
                        onTap: widget.disabled == false ? () => _onItemTap(item) : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          margin: EdgeInsets.only(right: !isLast ? 12 : 0),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            color: isSelected ? getColor() : getColor().withOpacity(0.5),
                          ),
                          child: Text(
                            item.toString(),
                            style: TextStyle(
                              fontFamily: AppFonts.secondary,
                              fontSize: 18,
                              color: widget.lightTheme ? AppColors.sand : AppColors.darkGreen,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
