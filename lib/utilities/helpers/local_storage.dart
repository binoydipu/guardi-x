import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // Save multiple user details
  static Future<void> saveUserData(String userPhone, String userName,
      bool emergencyEnable, List<String> trustedContacts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userPhone', userPhone);
    await prefs.setString('userName', userName);
    await prefs.setBool('emergencyEnable', emergencyEnable);
    await prefs.setStringList('trustedContacts', trustedContacts);
  }

  // Get user phone
  static Future<String?> getUserPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userPhone');
  }

  // Get user name
  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  // Get emergency status
  static Future<bool?> getEmergencyStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('emergencyEnable');
  }

  // Update emergency status
  static Future<void> updateEmergencyStatus(bool emergencyEnable) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('emergencyEnable', emergencyEnable);
  }

  // **Store a List of Strings**
  static Future<void> saveTrustedContacts(List<String> contacts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('trustedContacts', contacts);
  }

  // **Retrieve a List of Strings**
  static Future<List<String>> getTrustedContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('trustedContacts') ?? [];
  }

  // **Add a Single Contact to List**
  static Future<void> addTrustedContact(String contact) async {
    List<String> contacts = await getTrustedContacts();
    if (!contacts.contains(contact)) {
      contacts.add(contact);
      await saveTrustedContacts(contacts);
    }
  }

  // **Remove a Specific Contact**
  static Future<void> removeTrustedContact(String contact) async {
    List<String> contacts = await getTrustedContacts();
    contacts.remove(contact);
    await saveTrustedContacts(contacts);
  }

  // **Clear all stored data (Logout)**
  static Future<void> removeUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userPhone');
    await prefs.remove('userName');
    await prefs.remove('emergencyEnable');
    await prefs.remove('trustedContacts'); // Clear stored contacts
  }
}
