import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async'; // This provides the Timer class

class NewReadingPage extends StatefulWidget {
  const NewReadingPage({super.key});

  @override
  State<NewReadingPage> createState() => _NewReadingPageState();
}

class _NewReadingPageState extends State<NewReadingPage> {
  final TextEditingController readingNameController = TextEditingController(text: "Morning Reading");
  final TextEditingController notesController = TextEditingController();
  final TextEditingController durationController = TextEditingController(text: "60");
  DateTime selectedDate = DateTime.now();
  bool isReading = false;
  bool isCompleted = false;
  double currentRate = 0.0;
  Timer? _readingTimer;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _startReading() {
    if (isReading) return;
    
    setState(() {
      isReading = true;
      isCompleted = false;
      currentRate = 12.0; // Initial rate
    });

    // Simulate reading respiratory rate
    int elapsedSeconds = 0;
    _readingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedSeconds++;
      setState(() {
        // Simulate realistic respiratory rate changes
        currentRate = 12 + (elapsedSeconds % 8);
      });

      if (elapsedSeconds >= int.parse(durationController.text)) {
        _completeReading();
      }
    });
  }

  void _completeReading() {
    _readingTimer?.cancel();
    setState(() {
      isReading = false;
      isCompleted = true;
    });
  }

  void _saveReading() {
    // In a real app, you would save to database here
    final readingData = {
      'name': readingNameController.text,
      'date': selectedDate,
      'duration': durationController.text,
      'rate': currentRate,
      'notes': notesController.text,
    };
    
    Navigator.pop(context, readingData);
  }

  @override
  void dispose() {
    _readingTimer?.cancel();
    readingNameController.dispose();
    notesController.dispose();
    durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.shield, color: Colors.white),
            SizedBox(width: 8),
            Text('Respiratory Belt'),
          ],
        ),
        actions: const [
          Icon(Icons.menu),
          SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "New Respiratory Reading",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Reading Details", 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: readingNameController,
                      decoration: const InputDecoration(
                        labelText: "Reading Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: TextEditingController(
                        text: DateFormat('dd-MM-yyyy').format(selectedDate),
                      ),
                      decoration: const InputDecoration(
                        labelText: "Date",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        labelText: "Notes (Optional)",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: durationController,
                      decoration: const InputDecoration(
                        labelText: "Duration (seconds)",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: isReading ? null : _startReading,
                          icon: const Icon(Icons.play_circle_fill),
                          label: const Text("Start Reading"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton.icon(
                          onPressed: isCompleted ? _saveReading : null,
                          icon: const Icon(Icons.save),
                          label: const Text("Save Reading"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Respiratory Graph",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isReading ? "Measuring..." : 
                          isCompleted ? "Completed" : "Ready to begin",
                          style: TextStyle(
                            color: isReading ? Colors.blue : 
                                  isCompleted ? Colors.green : Colors.grey
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: isReading || isCompleted
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${currentRate.toStringAsFixed(1)} breaths/min",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (isReading) 
                                    const CircularProgressIndicator(),
                                  if (isCompleted)
                                    const Icon(Icons.check_circle, 
                                      color: Colors.green, size: 48),
                                ],
                              )
                            : const Text(
                                "Start reading to see data",
                                style: TextStyle(color: Colors.grey),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}