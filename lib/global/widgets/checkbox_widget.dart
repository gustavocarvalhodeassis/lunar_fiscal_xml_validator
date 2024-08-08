import 'package:flutter/material.dart';

class CheckboxWidget extends StatelessWidget {
  const CheckboxWidget({super.key, this.label, required this.value, required this.onChanged});

  final String? label;
  final bool value;
  final Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged!(value);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 15, 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
            ),
            if (label != null)
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(label!)
                ],
              )
          ],
        ),
      ),
    );
  }
}
