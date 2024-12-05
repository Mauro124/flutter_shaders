import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/filter.dart';

class FiltersWidget extends StatefulWidget {
  final Function(FilterType) onFilterSelected;

  const FiltersWidget({super.key, required this.onFilterSelected});

  @override
  State<FiltersWidget> createState() => _FiltersWidgetState();
}

class _FiltersWidgetState extends State<FiltersWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 20, bottom: 100),
        width: MediaQuery.sizeOf(context).width,
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: [
            for (final filter in FilterType.values)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ElevatedButton(
                  onPressed: () => widget.onFilterSelected(filter),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(filter.name),
                      filter.isInteractive ? const Icon(Icons.touch_app) : const SizedBox(),
                    ],
                  ),
                ),
              ),
          ],
        ));
  }
}
