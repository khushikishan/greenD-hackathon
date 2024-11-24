import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:greend/themes/theme_provider.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF183C24), // Set emerald green consistently
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 60), // Adjust to start below the dynamic island
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text(
                "Home",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.white),
              title: const Text(
                "Account",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/account');
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment, color: Colors.white),
              title: const Text(
                "Payment",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/payment');
              },
            ),
            const Divider(color: Colors.white54, thickness: 1),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.white),
              title: const Text(
                "AI Assistant",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/aiChat');
              },
            ),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return ListTile(
                  leading: const Icon(Icons.brightness_6, color: Colors.white),
                  title: const Text(
                    "Switch Theme",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                    activeColor: Colors.white,
                  ),
                );
              },
            ),
            const Divider(color: Colors.white54, thickness: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text(
                "Log Out",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}