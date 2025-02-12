import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveUserData(
      String userPhone,
      String userName,
      bool emergencyEnable,
      List<String> trustedContacts,
      List<String> trustedContactNames) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userPhone', userPhone);
    await prefs.setString('userName', userName);
    await prefs.setBool('emergencyEnable', emergencyEnable);
    await prefs.setStringList('trustedContacts', trustedContacts);
    await prefs.setStringList('trustedContactNames', trustedContactNames);
  }

  static Future<String?> getUserPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userPhone');
  }

  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  static Future<bool?> getEmergencyStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('emergencyEnable');
  }

  static Future<void> updateEmergencyStatus(bool emergencyEnable) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('emergencyEnable', emergencyEnable);
  }

  static Future<void> saveTrustedContacts(List<String> contacts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('trustedContacts', contacts);
  }

  static Future<List<String>> getTrustedContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('trustedContacts') ?? [];
  }

  static Future<void> saveTrustedContactNames(List<String> names) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('trustedContactNames', names);
  }

  static Future<List<String>> getTrustedContactNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('trustedContactNames') ?? [];
  }

  static Future<void> addTrustedContact(
      String contact, String contactName) async {
    List<String> contacts = await getTrustedContacts();
    List<String> contactNames = await getTrustedContactNames();

    if (!contacts.contains(contact)) {
      contacts.add(contact);
      contactNames.add(contactName);
      await saveTrustedContacts(contacts);
      await saveTrustedContactNames(contactNames);
    }
  }

  static Future<void> removeUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userPhone');
    await prefs.remove('userName');
    await prefs.remove('emergencyEnable');
    await prefs.remove('trustedContacts');
    await prefs.remove('trustedContactNames');
  }
}
