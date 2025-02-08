package com.guardix.guardix

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.telephony.SmsManager
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "smsChannel"  // Define a communication channel with Flutter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Set up a MethodChannel to allow Flutter to call this native Android code
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "sendSMS") {
                val phone: String? = call.argument("phone")  // Get phone number from Flutter
                val message: String? = call.argument("message")  // Get message from Flutter
                if (phone != null && message != null) {
                    sendSMS(phone, message)  // Call the function to send SMS
                    result.success("SMS Sent")  // Return success to Flutter
                } else {
                    result.error("ERROR", "Invalid phone or message", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun sendSMS(phone: String, message: String) {
        // Check if SMS sending permission is granted
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.SEND_SMS) == PackageManager.PERMISSION_GRANTED) {
            val smsManager = SmsManager.getDefault()  // Get SMS manager
            smsManager.sendTextMessage(phone, null, message, null, null)  // Send SMS
            Toast.makeText(this, "SMS Sent!", Toast.LENGTH_SHORT).show()
        } else {
            // Request SMS permission if not granted
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.SEND_SMS), 1)
        }
    }
}


/*
package com.example.yourapp;

import android.Manifest;
import android.content.pm.PackageManager;
import android.telephony.SmsManager;
import android.widget.Toast;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "smsChannel";

    @Override
    public void configureFlutterEngine(@NonNull io.flutter.embedding.engine.FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("sendSMS")) {
                        String phone = call.argument("phone");
                        String message = call.argument("message");
                        sendSMS(phone, message);
                        result.success("SMS Sent");
                    } else {
                        result.notImplemented();
                    }
                }
            );
    }

    private void sendSMS(String phone, String message) {
        if (checkSelfPermission(Manifest.permission.SEND_SMS) == PackageManager.PERMISSION_GRANTED) {
            SmsManager smsManager = SmsManager.getDefault();
            smsManager.sendTextMessage(phone, null, message, null, null);
            Toast.makeText(this, "SMS Sent!", Toast.LENGTH_SHORT).show();
        } else {
            requestPermissions(new String[]{Manifest.permission.SEND_SMS}, 1);
        }
    }
}

*/