import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PageNumberInputDialog extends StatefulWidget {
  const PageNumberInputDialog({super.key});

  @override
  State<StatefulWidget> createState() => _PageNumberInputDialogState();
}

class _PageNumberInputDialogState extends State<PageNumberInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter page number'),
      content: TextField(
        controller: _controller,
        onSubmitted: (value) {
          if (_controller.text.isNotEmpty) {
            Navigator.of(context).pop(int.parse(_controller.text));
          }
        },
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[1-9]([0-9])*'))
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
          label: const Text('Cancel'),
        )
      ],
    );
  }
}