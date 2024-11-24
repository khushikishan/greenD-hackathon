import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:greend/pages/card_screen.dart';
import 'package:greend/pages/menu_screen.dart'; 

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<Map<String, String>> savedCards = [];

  final Color emeraldGreen = const Color(0xFF183C24); 

  
  Future<void> saveCard(String cardNumber, String expiryDate, String ownerName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, String> cardDetails = {
      "cardNumber": cardNumber,
      "expiryDate": expiryDate,
      "ownerName": ownerName,
    };

    savedCards.add(cardDetails);
    List<String> cardData = savedCards.map((card) => card.toString()).toList();
    await prefs.setStringList("savedCards", cardData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Card Saved Successfully!")),
    );

    setState(() {});
  }


  Future<void> _loadSavedCards() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cardData = prefs.getStringList("savedCards");

    if (cardData != null) {
      savedCards = cardData.map((cardString) {
        try {
          final cardMap = cardString
              .replaceAll(RegExp(r"[{}]"), "") 
              .split(", ") 
              .map((entry) => entry.split(": ")) 
              .map((pair) => MapEntry(pair[0].trim(), pair[1].trim())) // Clean up
              .fold<Map<String, String>>({}, (map, entry) {
            map[entry.key.replaceAll("'", "")] =
                entry.value.replaceAll("'", ""); 
            return map;
          });

          return {
            "cardNumber": cardMap["cardNumber"] ?? "N/A",
            "expiryDate": cardMap["expiryDate"] ?? "N/A",
            "ownerName": cardMap["ownerName"] ?? "N/A",
          };
        } catch (e) {
          return {
            "cardNumber": "Invalid",
            "expiryDate": "Invalid",
            "ownerName": "Invalid",
          };
        }
      }).toList();
    }

    setState(() {});
  }

  // Delete a card
  Future<void> _deleteCard(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    savedCards.removeAt(index);
    List<String> cardData = savedCards.map((card) => card.toString()).toList();
    await prefs.setStringList("savedCards", cardData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Card Deleted Successfully!")),
    );

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadSavedCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0), 
        child: AppBar(
          backgroundColor: emeraldGreen,
          elevation: 0,
        ),
      ),
      drawer: const MenuScreen(), 
      body: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Saved Cards",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: emeraldGreen,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: savedCards.isEmpty
                      ? const Center(
                          child: Text(
                            "No saved cards available.",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: savedCards.length,
                          itemBuilder: (context, index) {
                            final card = savedCards[index];
                            final cardNumber = card['cardNumber'] ?? "N/A";

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(
                                  cardNumber.length >= 12
                                      ? "**** **** **** ${cardNumber.substring(cardNumber.length - 4)}"
                                      : "Invalid Card Number",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: emeraldGreen, 
                                  ),
                                ),
                                subtitle: Text(
                                  "${card['ownerName']} - ${card['expiryDate']}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                onLongPress: () {
                                
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Delete Card"),
                                      content: const Text(
                                          "Are you sure you want to delete this card?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context); 
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context); 
                                            _deleteCard(index); 
                                          },
                                          child: const Text("Delete"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CardScreen(),
                        ),
                      ).then((_) {
                        
                        _loadSavedCards();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: emeraldGreen, 
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: const Text(
                      "Add New Card",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}