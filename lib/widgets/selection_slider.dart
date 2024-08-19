import 'package:flutter/material.dart';
import 'package:meditation_timer/themes/app_theme.dart';

class SelectionSlider<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final T? defaultSelectedItem;
  final Function(T)? onItemSelect;
  final bool disabled;
  final bool lightTheme;
  final double titlePadding;

  const SelectionSlider({
    super.key,
    required this.title,
    required this.items,
    this.defaultSelectedItem,
    this.onItemSelect,
    this.disabled = false,
    this.lightTheme = false,
    this.titlePadding = 30,
  });

  @override
  State<StatefulWidget> createState() => SelectionSliderState<T>();
}

class SelectionSliderState<T> extends State<SelectionSlider<T>> {
  T? _selectedItem;

  @override
  void initState() {
    super.initState();

    if (widget.defaultSelectedItem != null) {
      _selectedItem = widget.defaultSelectedItem;
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

  void setSelectedItem(T item) {
    setState(() {
      _selectedItem = item;
    });
  }

  Color _getColor() {
    return widget.lightTheme ? AppColors.darkGreen : AppColors.lightGreen;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.symmetric(horizontal: widget.titlePadding),
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(color: _getColor()),
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
                    padding: EdgeInsets.symmetric(horizontal: widget.titlePadding),
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
                            color: isSelected ? _getColor() : _getColor().withOpacity(0.5),
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
