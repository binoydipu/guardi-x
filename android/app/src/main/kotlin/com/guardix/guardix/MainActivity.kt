package com.guardix.guardix

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.telephony.SmsManager
import android.telephony.SubscriptionManager
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "smsChannel"
    private val SMS_PERMISSION_REQUEST_CODE = 101

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        requestSMSPermission()

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "sendSMS") {
                val phone: String? = call.argument("phone")
                val message: String? = call.argument("message")
                val simSlot: Int? = call.argument("simSlot")

                if (phone != null && message != null) {
                    sendSMS(phone, message, simSlot ?: 0, result)
                } else {
                    result.error("ERROR", "Invalid phone or message", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun requestSMSPermission() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.SEND_SMS) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.SEND_SMS), SMS_PERMISSION_REQUEST_CODE)
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode == SMS_PERMISSION_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                Toast.makeText(this, "SMS Permission Granted", Toast.LENGTH_SHORT).show()
            } else {
                Toast.makeText(this, "SMS Permission Denied", Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun sendSMS(phone: String, message: String, simSlot: Int, result: MethodChannel.Result) {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.SEND_SMS) == PackageManager.PERMISSION_GRANTED) {
            try {
                val smsManager = getSmsManager(simSlot)
                smsManager?.sendTextMessage(phone, null, message, null, null)
                Toast.makeText(this, "SMS Sent Successfully!", Toast.LENGTH_SHORT).show()
                result.success("SMS Sent")
            } catch (e: Exception) {
                result.error("SMS_FAILED", "Failed to send SMS: ${e.message}", null)
            }
        } else {
            result.error("PERMISSION_DENIED", "SMS permission is required", null)
        }
    }

    // Ensure safe handling of null values in Dual SIM selection
    private fun getSmsManager(simSlot: Int): SmsManager? {
        val subscriptionManager = getSystemService(SubscriptionManager::class.java)
        val activeSubscriptions = subscriptionManager?.activeSubscriptionInfoList

        return if (!activeSubscriptions.isNullOrEmpty() && simSlot < activeSubscriptions.size) {
            val selectedSubscriptionId = activeSubscriptions[simSlot].subscriptionId
            SmsManager.getSmsManagerForSubscriptionId(selectedSubscriptionId)
        } else {
            SmsManager.getDefault()
        }
    }
}
