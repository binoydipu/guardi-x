import 'package:flutter/material.dart';
import 'package:guardix/utilities/helpers/local_storage.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _emergencyModeEnabled = false; // State variable for toggle

  @override
  void initState() {
    checkEmergency();

    super.initState();
  }

  Future<void> checkEmergency() async {
    final status = await LocalStorage.getEmergencyStatus() ?? true;
    setState(() {
      _emergencyModeEnabled = status; // Update state with fetched value
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          // Vertically center content
          children: [
            const SizedBox(height: 30),
            const Text(
              'Emergency Mode',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40), // Spacing

            // Description Text (Centered)
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20), // Add horizontal padding
              child: Text(
                'If you feel unsafe in this environment, enable the \'Emergency Mode\'.',
                textAlign: TextAlign
                    .center, // Center the text within the available space
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 40), // Spacing

            // Big Emergency Icon
            const Icon(
              Icons.emergency,
              size: 100,
              color: Colors.red,
            ),
            const SizedBox(height: 40), // Spacing

            // Toggle Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enable Emergency Mode',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 10), // Spacing
                Switch(
                  value: _emergencyModeEnabled, // Use the state variable
                  onChanged: (bool value) async {
                    setState(() {
                      _emergencyModeEnabled = value; // Update the state
                    });
                    try {
                      await LocalStorage.updateEmergencyStatus(
                          _emergencyModeEnabled);
                    } catch (_) {}
                  },
                  activeColor: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
