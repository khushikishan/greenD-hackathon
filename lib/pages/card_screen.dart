import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();

  String cardNumber = "#### #### #### ####";
  String expiryDate = "MM/YY";
  String cvv = "***";
  String ownerName = "CARDHOLDER NAME";

  Future<void> _saveCard() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> cardDetails = {
      "cardNumber": cardNumber,
      "expiryDate": expiryDate,
      "cvv": cvv,
      "ownerName": ownerName,
    };

    List<String> cardData = prefs.getStringList("savedCards") ?? [];
    cardData.add(cardDetails.toString());
    await prefs.setStringList("savedCards", cardData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Card Saved Successfully!")),
    );

    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Card"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.blueGrey[900],
              child: Container(
                width: double.infinity,
                height: 250,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Virtual Bank",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[300],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      cardNumber,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          expiryDate,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          cvv,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      ownerName,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            TextField(
              controller: cardNumberController,
              keyboardType: TextInputType.number,
              maxLength: 16,
              decoration: const InputDecoration(labelText: "Card Number"),
              onChanged: (value) {
                setState(() {
                  cardNumber = value.padRight(16, '#');
                  cardNumber = cardNumber.replaceAllMapped(
                      RegExp(r".{1,4}"), (match) => "${match.group(0)} ").trim();
                });
              },
            ),
            const SizedBox(height: 10),
          
            TextField(
              controller: expiryDateController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: const InputDecoration(labelText: "Expiry Date (MMYY)"),
              onChanged: (value) {
                if (value.length == 4) {
                  setState(() {
                    expiryDate = "${value.substring(0, 2)}/${value.substring(2)}";
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            
            TextField(
              controller: cvvController,
              keyboardType: TextInputType.number,
              maxLength: 3,
              decoration: const InputDecoration(labelText: "CVV"),
              onChanged: (value) {
                setState(() {
                  cvv = value;
                });
              },
            ),
            const SizedBox(height: 10),
            
            TextField(
              controller: ownerNameController,
              decoration: const InputDecoration(labelText: "Cardholder Name"),
              onChanged: (value) {
                setState(() {
                  ownerName = value.toUpperCase();
                });
              },
            ),
            const SizedBox(height: 20),
          
            ElevatedButton(
              onPressed: _saveCard,
              child: const Text("Save Card"),
            ),
          ],
        ),
      ),
    );
  }
}