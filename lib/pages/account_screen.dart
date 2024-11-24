import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:greend/pages/change_password_screen.dart';
import 'package:greend/pages/add_address_screen.dart';
import 'package:greend/authentication/login_or_register.dart';
import 'package:greend/pages/menu_screen.dart'; 

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? username;
  String? password;
  bool showSuccessBanner = false;
  List<String> savedAddresses = [];

  @override
  void initState() {
    super.initState();
    _loadCredentials();
    _loadAddresses();
  }

  Future<void> _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? "N/A";
      password = prefs.getString('password') ?? "N/A";
    });

    final success = prefs.getBool('passwordChanged') ?? false;
    if (success) {
      setState(() {
        showSuccessBanner = true;
      });

      await prefs.setBool('passwordChanged', false);

      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          showSuccessBanner = false;
        });
      });
    }
  }

  Future<void> _loadAddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? addresses = prefs.getStringList('savedAddresses');

    if (addresses != null) {
      setState(() {
        savedAddresses = addresses;
      });
    }
  }

  Future<void> _deleteAddress(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    savedAddresses.removeAt(index);

    await prefs.setStringList('savedAddresses', savedAddresses);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Address deleted successfully!")),
    );

    setState(() {});
  }

  Future<void> _deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginOrRegister()),
      (route) => false,
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
            "Are you sure you want to delete your account? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuScreen(), // Use the new MenuScreen
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16), // Spacing below dynamic island
                    const Text(
                      "Account Information",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Username",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      username ?? "N/A",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Password",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "********",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ChangePasswordScreen(),
                            ),
                          ).then((_) {
                            _loadCredentials();
                          });
                        },
                        child: const Text("Change Password"),
                      ),
                    ),
                    const SizedBox(height: 30),

                    const Text(
                      "Address Information",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Saved Addresses",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    if (savedAddresses.isEmpty)
                      const Text(
                        "No saved addresses available.",
                        style: TextStyle(fontSize: 16),
                      )
                    else
                      ...savedAddresses.asMap().entries.map(
                        (entry) {
                          int index = entry.key;
                          String address = entry.value;

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(address),
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Delete Address"),
                                      content: const Text(
                                          "Are you sure you want to delete this address?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _deleteAddress(index);
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ).toList(),

                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AddAddressScreen()),
                          ).then((_) {
                            _loadAddresses();
                          });
                        },
                        child: const Text("Add New Address"),
                      ),
                    ),
                    const SizedBox(height: 30),

                    const Text(
                      "Delete My Account",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "This action cannot be undone. Deleting your account will permanently erase all your data.",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                        ),
                        onPressed: _showDeleteConfirmation,
                        child: const Text(
                          "Delete Account",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (showSuccessBanner)
              Positioned(
                top: 0,
                left: 16,
                right: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Password successfully changed!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            showSuccessBanner = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}