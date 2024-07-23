package com.example.costum_notification_call_example

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.core.app.RemoteInput

class NotificationReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val remoteInput = RemoteInput.getResultsFromIntent(intent)

        if (remoteInput != null) {
            val title = remoteInput.getCharSequence(
                    NotificationHelper.KEY_TEXT_REPLY).toString()
            Log.d("NotificationReceiver", title)
            NotificationHelper.showNotification(context) // call NotificationHelper to show the same notification again
        }
    }
}