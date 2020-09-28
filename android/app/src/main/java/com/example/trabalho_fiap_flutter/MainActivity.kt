package com.example.trabalho_fiap_flutter

import android.content.Context
import android.net.ConnectivityManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {

    private val CHANNEL = "internet/sign"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)


        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL).setMethodCallHandler{ call, result ->
            if(call.method == "isConnected"){
                result.success(isNetworkConnected())
            }
        }
    }
    private fun isNetworkConnected(): Boolean {
        val cm = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        return cm.activeNetworkInfo != null && cm.activeNetworkInfo.isConnected
    }
}