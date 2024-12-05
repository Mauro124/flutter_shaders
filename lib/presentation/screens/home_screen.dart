import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/filter.dart';
import 'package:flutter_application_1/presentation/widgets/filters_widget.dart';
import 'package:flutter_application_1/presentation/widgets/image_preview.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FilterType _selectedFilter = FilterType.none;
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: ImagePreview(path: _image?.path, filter: _selectedFilter)),
            FiltersWidget(onFilterSelected: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            }),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _addPhoto,
        tooltip: 'Add photo',
        child: const Icon(Icons.camera),
      ),
    );
  }

  Future<void> _addPhoto() async {
    final ImagePicker picker = ImagePicker();
    _image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {});
  }
}
