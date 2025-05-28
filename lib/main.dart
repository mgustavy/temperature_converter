import 'package:flutter/material.dart';

void main() {
  runApp(const TemperatureConverterApp());
}

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TemperatureConverterScreen(),
    );
  }
}

class TemperatureConverterScreen extends StatefulWidget {
  const TemperatureConverterScreen({super.key});

  @override
  State<TemperatureConverterScreen> createState() => _TemperatureConverterScreenState();
}

class _TemperatureConverterScreenState extends State<TemperatureConverterScreen> {
  bool isCelsiusToFahrenheit = true;
  final TextEditingController _controller = TextEditingController();
  double? _result;
  final List<String> _history = [];

  void _convertTemperature() {
    final input = double.tryParse(_controller.text);
    if (input == null) return;

    double output;
    String record;

    if (isCelsiusToFahrenheit) {
      output = (input * 9 / 5) + 32;
      record = '℃ to ℉: $input → ${output.toStringAsFixed(2)}';
    } else {
      output = (input - 32) * 5 / 9;
      record = '℉ to ℃: $input → ${output.toStringAsFixed(2)}';
    }

    setState(() {
      _result = output;
      _history.insert(0, record);
    });
  }

  Widget _buildConversionCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('°C to °F'),
                    selected: isCelsiusToFahrenheit,
                    onSelected: (selected) {
                      setState(() {
                        isCelsiusToFahrenheit = true;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 2),
                SizedBox(
                  width: 40,
                  child: IconButton(
                    icon: const Icon(Icons.swap_horiz),
                    onPressed: () {
                      setState(() {
                        isCelsiusToFahrenheit = !isCelsiusToFahrenheit;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('°F to °C'),
                    selected: !isCelsiusToFahrenheit,
                    onSelected: (selected) {
                      setState(() {
                        isCelsiusToFahrenheit = false;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter temperature',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _convertTemperature,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF51A5FA),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text(
                'Convert',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            if (_result != null)
              Text(
                'Result: ${_result!.toStringAsFixed(2)} ${isCelsiusToFahrenheit ? '℉' : '℃'}',
                style: const TextStyle(fontSize: 20),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.history),
                const SizedBox(width: 8),
                const Text('History', style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Clear history',
                  onPressed: () {
                    setState(() {
                      _history.clear();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_history.isEmpty)
              const Text('No history yet.')
            else
              ..._history.map((entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(entry),
                  )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text('Temperature Converter'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: ListView(
        children: [
          _buildConversionCard(),
          _buildHistoryCard(),
        ],
      ),
    );
  }
}
