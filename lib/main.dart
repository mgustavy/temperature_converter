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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 4),
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
                  ),
                  Center(
                    child: IconButton(
                      icon: const Icon(Icons.swap_horiz),
                      onPressed: () {
                        setState(() {
                          isCelsiusToFahrenheit = !isCelsiusToFahrenheit;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 4),
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
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter temperature',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _convertTemperature,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 66, 21, 179),
                minimumSize: const Size(double.infinity, 48),
                elevation: 0,
              ),
              child: const Text(
                'Convert',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            if (_result != null)
  Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Result',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${_result!.toStringAsFixed(2)} ${isCelsiusToFahrenheit ? '℉' : '℃'}',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
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
                const Text('History', style: TextStyle(fontWeight: FontWeight.w600)),
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
            const SizedBox(height: 16),
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
