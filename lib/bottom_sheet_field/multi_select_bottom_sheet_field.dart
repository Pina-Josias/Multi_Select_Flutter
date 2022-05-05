import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import '../util/multi_select_list_type.dart';
import '../chip_display/multi_select_chip_display.dart';
import '../util/multi_select_item.dart';
import 'multi_select_bottom_sheet.dart';

/// A customizable InkWell widget that opens the MultiSelectBottomSheet
class MultiSelectBottomSheetField<V> extends StatefulWidget {
  const MultiSelectBottomSheetField({
    Key? key,
    required this.items,
    this.keyText,
    this.title,
    this.buttonText,
    this.buttonIcon,
    this.listType,
    this.onSelectionChanged,
    this.onConfirm,
    this.chipDisplay,
    this.initialValue,
    this.searchable = false,
    this.confirmText,
    this.cancelText,
    this.selectedColor,
    this.initialChildSize,
    this.minChildSize,
    this.maxChildSize,
    this.shape,
    this.barrierColor,
    this.searchHint,
    this.hintText,
    this.colorator,
    this.backgroundColor,
    this.unselectedColor,
    this.searchIcon,
    this.closeSearchIcon,
    this.itemsTextStyle,
    this.searchTextStyle,
    this.searchHintStyle,
    this.selectedItemsTextStyle,
    this.showBottomSelection = true,
    this.showButtonsModal = false,
    this.separateSelectedItems = false,
    this.theme,
    this.validator,
    this.checkColor,
  }) : super(key: key);

  final Key? keyText;

  /// Set text that is displayed on the button.
  final Text? buttonText;

  /// Specify the button icon.
  final Icon? buttonIcon;

  /// List of items to select from.
  final List<MultiSelectItem<V>> items;

  /// The list of selected values before interaction.
  final List<V>? initialValue;

  /// The text at the top of the dialog.
  final Widget? title;

  /// Fires when the an item is selected / unselected.
  final void Function(List<V>)? onSelectionChanged;

  /// Fires when confirm is tapped.
  final void Function(List<V>)? onConfirm;

  /// Toggles search functionality.
  final bool searchable;

  /// Text on the confirm button.
  final Text? confirmText;

  /// Text on the cancel button.
  final Text? cancelText;

  /// An enum that determines which type of list to render.
  final MultiSelectListType? listType;

  /// Sets the color of the checkbox or chip body when selected.
  final Color? selectedColor;

  /// Set the hint text of the search field.
  final String? searchHint;

  /// Set the initial height of the BottomSheet.
  final double? initialChildSize;

  /// Set the minimum height threshold of the BottomSheet before it closes.
  final double? minChildSize;

  /// Set the maximum height of the BottomSheet.
  final double? maxChildSize;

  /// Apply a ShapeBorder to alter the edges of the BottomSheet.
  final ShapeBorder? shape;

  /// Set the color of the space outside the BottomSheet.
  final Color? barrierColor;

  /// Overrides the default MultiSelectChipDisplay attached to this field.
  /// If you want to remove it, use MultiSelectChipDisplay.none().
  final MultiSelectChipDisplay<V>? chipDisplay;

  /// A function that sets the color of selected items based on their value.
  /// It will either set the chip color, or the checkbox color depending on the list type.
  final Color Function(V)? colorator;

  /// Placeholder text for the search field.
  final String? hintText;

  /// Set the background color of the bottom sheet.
  final Color? backgroundColor;

  /// Color of the chip body or checkbox border while not selected.
  final Color? unselectedColor;

  /// Replaces the deafult search icon when searchable is true.
  final Icon? searchIcon;

  /// Replaces the default close search icon when searchable is true.
  final Icon? closeSearchIcon;

  /// The TextStyle of the items within the BottomSheet.
  final TextStyle? itemsTextStyle;

  /// Style the text on the selected chips or list tiles.
  final TextStyle? selectedItemsTextStyle;

  /// Moves the selected items to the top of the list.
  final bool separateSelectedItems;

  /// Style the text that is typed into the search field.
  final TextStyle? searchTextStyle;

  /// Style the search hint.
  final TextStyle? searchHintStyle;

  /// Set the color of the check in the checkbox
  final Color? checkColor;

  /// Show the selected items in the bottom sheet below the field.
  final bool? showBottomSelection;

  /// Set the buttons display on the bottom sheet.
  final bool showButtonsModal;

  /// The validator for the [TextField]
  final FormFieldValidator<String>? validator;

  /// Theme of the field
  final ThemeData? theme;

  @override
  State<MultiSelectBottomSheetField<V>> createState() =>
      _MultiSelectBottomSheetFieldState<V>();
}

class _MultiSelectBottomSheetFieldState<V>
    extends State<MultiSelectBottomSheetField<V>> {
  List<V> _selectedItems = [];
  TextEditingController _searchText = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _selectedItems.addAll(widget.initialValue!);
    }
  }

  _showBottomSheet(BuildContext ctx) async {
    await showModalBottomSheet(
        backgroundColor: widget.backgroundColor,
        barrierColor: widget.barrierColor,
        shape: widget.shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            ),
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        context: context,
        builder: (context) {
          return MultiSelectBottomSheet<V>(
            checkColor: widget.checkColor,
            selectedItemsTextStyle: widget.selectedItemsTextStyle,
            searchTextStyle: widget.searchTextStyle,
            searchHintStyle: widget.searchHintStyle,
            itemsTextStyle: widget.itemsTextStyle,
            searchIcon: widget.searchIcon,
            closeSearchIcon: widget.closeSearchIcon,
            unselectedColor: widget.unselectedColor,
            colorator: widget.colorator,
            searchHint: widget.searchHint,
            selectedColor: widget.selectedColor,
            listType: widget.listType,
            items: widget.items,
            cancelText: widget.cancelText,
            confirmText: widget.confirmText,
            separateSelectedItems: widget.separateSelectedItems,
            initialValue: _selectedItems,
            onConfirm: (selected) {
              _selectedItems = selected;
              if (widget.onConfirm != null)
                widget.onSelectionChanged!(selected);
              List<MultiSelectItem<V>?> chipDisplayItems = [];
              chipDisplayItems = _selectedItems
                  .map((e) => widget.items
                      .firstWhereOrNull((element) => e == element.value))
                  .toList();
              _searchText.value = _searchText.value.copyWith(
                  text: chipDisplayItems.isNotEmpty
                      ? chipDisplayItems.length == 1
                          ? "${chipDisplayItems.first?.label}"
                          : widget.hintText
                      : null);
            },
            onSelectionChanged: (selected) {
              _selectedItems = selected;
              if (widget.onSelectionChanged != null) {
                widget.onSelectionChanged!(selected);
                List<MultiSelectItem<V>?> chipDisplayItems = [];
                chipDisplayItems = _selectedItems
                    .map((e) => widget.items
                        .firstWhereOrNull((element) => e == element.value))
                    .toList();
                _searchText.value = _searchText.value.copyWith(
                    text: chipDisplayItems.isNotEmpty
                        ? chipDisplayItems.length == 1
                            ? "${chipDisplayItems.first?.label}"
                            : widget.hintText
                        : '');
              }
            },
            showButtonsModal: widget.showButtonsModal,
            searchable: widget.searchable,
            title: widget.title,
            initialChildSize: widget.initialChildSize,
            minChildSize: widget.minChildSize,
            maxChildSize: widget.maxChildSize,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.theme ?? Theme.of(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              _showBottomSheet(context);
            },
            child: IgnorePointer(
              ignoring: true,
              child: TextFormField(
                key: widget.keyText,
                maxLines: 1,
                controller: _searchText,
                autovalidateMode: AutovalidateMode.always,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  label: widget.buttonText,
                  suffixIcon: widget.buttonIcon ?? Icon(Icons.arrow_downward),
                ),
                validator: widget.validator,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
