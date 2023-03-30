// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:flutter_quicksort/providers/number_list_provider.dart';
import 'package:flutter_quicksort/widgets/number_list_display.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Quick Sort Visualizer'),
        ),
        body: ProviderScope(
          child: Builder(
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Expanded(child: NumberListDisplay()),
                    const SizedBox(
                      height: 16,
                    ),
                    Consumer(builder: (context, ref, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: _formKey,
                              child: SizedBox(
                                width: 300,
                                child: TextFormField(
                                  controller: _controller,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      labelText: 'Enter array size (10-100)'),
                                  validator: (value) {
                                    int? valueAsInt = int.tryParse(value ?? '');
                                    if (valueAsInt == null ||
                                        valueAsInt < 10 ||
                                        valueAsInt > 100) {
                                      return 'Please enter a valid number between 10 and 100';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final newSize = int.parse(_controller.text);
                                ref
                                    .read(numberListProvider.notifier)
                                    .generateNumbers(newSize);
                              }
                            },
                            child: const Text('Generate Numbers'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                ref.read(numberListProvider.notifier).sort();
                              },
                              child: const Text('Sort'),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
