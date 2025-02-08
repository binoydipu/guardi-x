import 'dart:convert';
import 'package:http/http.dart' as http;

class TwilioService {
  final String accountSid = 'AC78a5c85374c1995a97018a8f76ea8d2b';
  final String authToken = '03044b1d22962d8cfea66dc2b463ce86';
  final String twilioNumber = '+15644641403';
  final String verifyServiceSid = 'VAd4516cd2afb63ee804a829271bd1e315';

  Future<bool> verifyCode(String phoneNumber, String code) async {
    final url = Uri.parse(
        'https://verify.twilio.com/v2/Services/$verifyServiceSid/VerificationCheck');

    final response = await http.post(
      url,
      headers: {
        'Authorization':
            'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken')),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'To': phoneNumber,
        'Code': code,
      },
    );

    final jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status'] == 'approved') {
      print('Verification successful!');
      return true;
    } else {
      print('Invalid code: ${response.body}');
      return false;
    }
  }

  Future<void> sendVerificationCode(String phoneNumber) async {
    final url = Uri.parse(
        'https://verify.twilio.com/v2/Services/$verifyServiceSid/Verifications');

    final response = await http.post(
      url,
      headers: {
        'Authorization':
            'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken')),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'To': phoneNumber,
        'Channel': 'sms', // Use "call" for voice verification
      },
    );

    if (response.statusCode == 201) {
      print('Verification code sent!');
    } else {
      print('Failed to send verification code: ${response.body}');
    }
  }

  Future<void> sendSms(String to, String message) async {
    final url = Uri.parse(
        'https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json');
    final response = await http.post(
      url,
      headers: {
        'Authorization':
            'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken')),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'From': twilioNumber,
        'To': to, // Must be a verified number in free tier
        'Body': message,
      },
    );

    if (response.statusCode == 201) {
      print('Message sent successfully!');
    } else {
      print('Failed to send message: ${response.body}');
    }
  }
}
