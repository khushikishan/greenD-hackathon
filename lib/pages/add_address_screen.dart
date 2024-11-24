import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController streetController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

 
  Future<void> _saveAddress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

   
    String address =
        "${streetController.text}, ${buildingController.text}, Unit ${unitController.text}, ${cityController.text}, ${provinceController.text}, ${postalCodeController.text}";

    List<String>? savedAddresses = prefs.getStringList('savedAddresses') ?? [];
    savedAddresses.add(address);

    await prefs.setStringList('savedAddresses', savedAddresses);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Address Saved Successfully!")),
    );

    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Address"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Street", style: TextStyle(fontSize: 16)),
              TextField(controller: streetController),
              const SizedBox(height: 10),
              const Text("Building", style: TextStyle(fontSize: 16)),
              TextField(controller: buildingController),
              const SizedBox(height: 10),
              const Text("Unit Number", style: TextStyle(fontSize: 16)),
              TextField(controller: unitController),
              const SizedBox(height: 10),
              const Text("City", style: TextStyle(fontSize: 16)),
              TextField(controller: cityController),
              const SizedBox(height: 10),
              const Text("Province", style: TextStyle(fontSize: 16)),
              TextField(controller: provinceController),
              const SizedBox(height: 10),
              const Text("Postal Code", style: TextStyle(fontSize: 16)),
              TextField(controller: postalCodeController),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveAddress,
                  child: const Text("Save Address"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}