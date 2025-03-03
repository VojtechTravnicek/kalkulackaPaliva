import 'package:flutter/material.dart';

void main() {
  runApp(FuelTrackerApp());
}

class FuelTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evidence tankování',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FuelTrackerScreen(),
    );
  }
}

class FuelTrackerScreen extends StatefulWidget {
  @override
  _FuelTrackerScreenState createState() => _FuelTrackerScreenState();
}

class _FuelTrackerScreenState extends State<FuelTrackerScreen> {
  final List<Map<String, String>> _entries = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _odoController = TextEditingController();
  final TextEditingController _fuelController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  void _addEntry() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _entries.add({
          'date': _dateController.text,
          'odo': _odoController.text,
          'fuel': _fuelController.text,
          'price': _priceController.text,
          'notes': _notesController.text,
        });
      });
      _dateController.clear();
      _odoController.clear();
      _fuelController.clear();
      _priceController.clear();
      _notesController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Evidence tankování')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(_dateController, 'Datum', 'Zadejte datum'),
                  _buildTextField(
                      _odoController, 'Stav tachometru', 'Zadejte stav tachometru'),
                  _buildTextField(
                      _fuelController, 'Množství paliva (litry)', 'Zadejte množství paliva'),
                  _buildTextField(
                      _priceController, 'Cena za litr', 'Zadejte cenu za litr'),
                  _buildTextField(_notesController, 'Poznámky', '', required: false),
                  SizedBox(height: 10),
                  ElevatedButton(onPressed: _addEntry, child: Text('Přidat záznam')),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  final entry = _entries[index];
                  return Card(
                    child: ListTile(
                      title: Text('${entry['date']} - ${entry['odo']} km'),
                      subtitle: Text(
                          '${entry['fuel']} L - ${entry['price']} Kč/L\nPoznámky: ${entry['notes']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint,
      {bool required = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, hintText: hint, border: OutlineInputBorder()),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return 'Pole nesmí být prázdné';
          }
          return null;
        },
      ),
    );
  }
}
