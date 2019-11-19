package com.social_sagga

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Bundle
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import android.content.Intent.FLAG_ACTIVITY_NEW_TASK
import android.net.Uri
import android.widget.Toast


class MainActivity: FlutterActivity() {
    private val CHANNEL = "flutter.native/helper"
//    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        GeneratedPluginRegistrant.registerWith(flutterEngine)
//    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
//        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { methodCall, result ->
//            val args = methodCall.arguments as List<*>

            val sharedPreferences: SharedPreferences = getSharedPreferences("social-saga", Context.MODE_PRIVATE)

            when {
                methodCall.method == "openWhatsApp" -> {
                    val greetings = openWhatsApp()
                    result.success(greetings)
                }
                methodCall.method == "openFacebook" -> {
                    val greetings = openFacebook()
                    result.success(greetings)
                }
                methodCall.method == "openMessenger" -> {
                    val greetings = openMessenger()
                    result.success(greetings)
                }
                methodCall.method == "openTwitter" -> {
                    val greetings = openTwitter()
                    result.success(greetings)
                }
                methodCall.method == "openInstagram" -> {
                    val greetings = openInstagram()
                    result.success(greetings)
                }
                methodCall.method == "openTelegram" -> {
                    val greetings = openTelegram()
                    result.success(greetings)
                }
                methodCall.method == "saveSharedPreference" -> {
                    var isLoggedIn: Boolean? = methodCall.argument("isLoggedIn")

                    if (!isLoggedIn!!) {
                        isLoggedIn = false
                    }

                    print(isLoggedIn)

                    val isSaved = saveSharedPreference(isLoggedIn)
                    result.success(isSaved)
                }
                methodCall.method == "getIsLoggedIn" -> {
                    val editor: Boolean = sharedPreferences.getBoolean("isLoggedIn", false)

                    result.success(editor)
                }
                methodCall.method == "incrementLoggedInCount" -> {
                    val number: String? = methodCall.argument("number")

                    var ed: Int = sharedPreferences.getInt("loggedInCount-$number", 0)
                    ed += 1

                    val editor: SharedPreferences.Editor = sharedPreferences.edit()
                    editor.putInt("loggedInCount-$number", ed)

                    editor.apply()

                    if (ed >= 10) {
                        editor.putInt("loggedInCount-$number", 1)
                    }
                    result.success(ed)
                }
            }
        }
    }

    fun openWhatsApp(): Boolean {
        val url = "https://api.whatsapp.com/send?phone=%s"
        val whatsappIntent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
        whatsappIntent.setPackage("com.whatsapp")
        whatsappIntent.data = Uri.parse(String.format(url, "+256779104144"))

        whatsappIntent.flags = FLAG_ACTIVITY_NEW_TASK
        try {
            startActivity(whatsappIntent)
        } catch (ex: android.content.ActivityNotFoundException) {
            Toast.makeText(this, "Please install whatsApp", Toast.LENGTH_LONG).show()
            return false
        }

//        val sendIntent = Intent("android.intent.action.MAIN")
//        sendIntent.component = ComponentName("com.whatsapp", "com.whatsapp.Conversation")
//        sendIntent.putExtra("jid", PhoneNumberUtils.stripSeparators("0706732381") + "@s.whatsapp.net")
//
//        startActivity(Intent.createChooser(sendIntent, "Compartir en")
//                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
        return true
    }

    fun openFacebook(): Boolean {
        val url = "https://www.facebook.com/"
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
        intent.flags = FLAG_ACTIVITY_NEW_TASK
        try {
            startActivity(intent)
        } catch (ex: android.content.ActivityNotFoundException) {
            Toast.makeText(this, "Please install Facebook", Toast.LENGTH_LONG).show()
            return false
        }
        return true
    }

    fun openMessenger(): Boolean {
        val url = "fb://messaging/"
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
        intent.data = Uri.parse(url)
        intent.setPackage("com.facebook.orca")
        intent.flags = FLAG_ACTIVITY_NEW_TASK
        try {
            startActivity(intent)
        } catch (ex: android.content.ActivityNotFoundException) {
            Toast.makeText(this, "Please install Facebook", Toast.LENGTH_LONG).show()
            return false
        }
        return true
    }

    fun openTwitter(): Boolean{
        Toast.makeText(this, "Please install Twitter", Toast.LENGTH_LONG).show()
        return false
    }

    fun openInstagram(): Boolean{
        Toast.makeText(this, "Please install Instagram", Toast.LENGTH_LONG).show()
        return false
    }

    fun openTelegram(): Boolean{
        Toast.makeText(this, "Please install Telegram", Toast.LENGTH_LONG).show()
        return false
    }

    fun saveSharedPreference(value: Boolean): Boolean {
        val sharedPreferences: SharedPreferences = getSharedPreferences("social-saga", Context.MODE_PRIVATE)
        val editor: SharedPreferences.Editor = sharedPreferences.edit()

        editor.putBoolean("isLoggedIn", value)
        editor.apply()
        return true
    }
}
