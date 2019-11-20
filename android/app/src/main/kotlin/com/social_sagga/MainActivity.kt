package com.social_sagga

import android.content.Context
import android.content.SharedPreferences
import android.os.Bundle
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import android.content.Intent.FLAG_ACTIVITY_NEW_TASK
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

                    if (ed >= 5) {
                        editor.putInt("loggedInCount-$number", 0)
                    }
                    editor.apply()
                    result.success(ed)
                }
            }
        }
    }

    fun openWhatsApp(): Boolean {
        try {
            val intent = packageManager.getLaunchIntentForPackage("com.whatsapp")
            intent.addFlags(FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        } catch (ex: android.content.ActivityNotFoundException) {
            Toast.makeText(this, "Please install whatsApp", Toast.LENGTH_LONG).show()
            return false
        }
        return true
    }

    fun openFacebook(): Boolean {
        try {
            val intent = packageManager.getLaunchIntentForPackage("com.facebook.katana")
            intent.addFlags(FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        } catch (ex: Exception) {
            try{
                val intent = packageManager.getLaunchIntentForPackage("com.facebook.lite")
                intent.addFlags(FLAG_ACTIVITY_NEW_TASK)
                startActivity(intent)
            } catch (e: Exception) {
                Toast.makeText(this, "Please install Facebook", Toast.LENGTH_LONG).show()
                return false
            }
        }
        return true
    }

    fun openMessenger(): Boolean {
        try {
            val intent = packageManager.getLaunchIntentForPackage("com.facebook.orca")
            intent.addFlags(FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        } catch (ex: Exception) {
            Toast.makeText(this, "Please install Facebook Messenger", Toast.LENGTH_LONG).show()
            return false
        }
        return true
    }

    fun openTwitter(): Boolean{
        try {
            val intent = packageManager.getLaunchIntentForPackage("com.twitter.android")
            intent.addFlags(FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        } catch (ex: Exception) {
            Toast.makeText(this, "Please install Twitter", Toast.LENGTH_LONG).show()
            return false
        }
        return true
    }

    fun openInstagram(): Boolean{
        try {
            val intent = packageManager.getLaunchIntentForPackage("com.instagram.android")
            intent.addFlags(FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        } catch (ex: Exception) {
            Toast.makeText(this, "Please install Instagram", Toast.LENGTH_LONG).show()
            return false
        }
        return true
    }

    fun openTelegram(): Boolean{
        try {
            val intent = packageManager.getLaunchIntentForPackage("org.telegram.messenger")
            intent.addFlags(FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        } catch (ex: Exception) {
            Toast.makeText(this, "Please install Telegram", Toast.LENGTH_LONG).show()
            return false
        }
        return true
    }

    fun saveSharedPreference(value: Boolean): Boolean {
        val sharedPreferences: SharedPreferences = getSharedPreferences("social-saga", Context.MODE_PRIVATE)
        val editor: SharedPreferences.Editor = sharedPreferences.edit()

        editor.putBoolean("isLoggedIn", value)
        editor.apply()
        return true
    }
}
