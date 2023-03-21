import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleSelectDialogItem<V> {
  const SingleSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

class SingleSelectDialog<V> extends StatefulWidget {
  SingleSelectDialog(
      {Key key,
      this.items,
      this.initialSelectedValues,
      this.title,
      this.submitText,
      this.cancelText})
      : super(key: key);

  final List<SingleSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;
  final String title;
  final String submitText;
  final String cancelText;

  @override
  State<StatefulWidget> createState() => _SingleSelectDialogState<V>();
}

class _SingleSelectDialogState<V> extends State<SingleSelectDialog<V>> {
  var _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.clear();
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title ?? ""),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          elevation: 0,
          child: Text(widget.cancelText ?? ""),
          onPressed: _onCancelTap,
        ),
        MaterialButton(
          elevation: 0,
          child: Text(widget.submitText ?? ""),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(SingleSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      activeColor: Get.theme.colorScheme.secondary,
      title: Text(item.label, style: Theme.of(context).textTheme.bodyText2),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}
