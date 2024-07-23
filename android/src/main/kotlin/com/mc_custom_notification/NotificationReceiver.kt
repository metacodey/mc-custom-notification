package com.mc_custom_notification

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.core.app.NotificationManagerCompat
import android.app.ActivityManager
import android.os.Handler
import android.os.Looper
import androidx.core.app.RemoteInput

class NotificationReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        val notificationId = intent?.getIntExtra("notification_id", 0) ?: return
        val tag = intent.getStringExtra("tag")
        val groupKey = intent.getStringExtra("groupKey")
        val body = intent.getStringExtra("body")
        val image = intent.getStringExtra("image")
        val title = intent.getStringExtra("title")
        val payload = intent.getSerializableExtra("payload") as? HashMap<String, Any>
       
        when (intent?.action) {
            "com.mc_custom_notification.FULL_SCREEN" -> {
                // Handle full-screen intent action
            }
            "com.mc_custom_notification.END_CALLING" -> {
                Log.d("NotificationReceiver", "END_CALLING_ACTION button clicked for notification ID: $notificationId, tag: $tag, payload: $payload")
                sendActionBroadcast(context!!, notificationId, tag, payload,title,body,groupKey, "END_CALLING_ACTION",true)

            }
            "com.mc_custom_notification.SPEAKER" -> {
                Log.d("NotificationReceiver", "SPEAKER_ACTION button clicked for notification ID: $notificationId, tag: $tag, payload: $payload")
                sendActionBroadcast(context!!, notificationId, tag, payload,title,body,groupKey, "SPEAKER_ACTION",true)
            }
            "com.mc_custom_notification.MIC_CALL" -> {
                Log.d("NotificationReceiver", "MIC_CALL_ACTION button clicked for notification ID: $notificationId, tag: $tag, payload: $payload")
                sendActionBroadcast(context!!, notificationId, tag, payload,title,body,groupKey, "MIC_CALL_ACTION",true)
            }
            "com.mc_custom_notification.CLICK_CALLING" -> {
                Log.d("NotificationClickReceiver", "Notification CLICK_ACTION for notification ID: $notificationId, tag: $tag, payload: $payload")
                handleNotificationAction(context!!, notificationId, tag, payload,title,body,groupKey, "CLICK_ACTION",true)
            }
            "com.mc_custom_notification.REPLY" -> {
                val remoteInput = RemoteInput.getResultsFromIntent(intent)
                remoteInput?.getCharSequence("key_text_reply")?.let { inputText ->
                    payload?.put("msg", inputText.toString())                  
                    sendActionBroadcast(context!!, notificationId, tag, payload, title, body, groupKey, "REPLY_ACTION", false)

                } ?: run {
                    Log.d("NotificationReceiver", "No remote input found")
                }
            //     val remoteInput = RemoteInput.getResultsFromIntent(intent)
            //     if (remoteInput != null) {
            //         val inputText = remoteInput.getCharSequence("key_text_reply")
            //         payload["msg"]=inputText
            //         Log.d("NotificationReceiver", "Reply text: $inputText------------------------------------------------")
            //         sendActionBroadcast(context!!, notificationId, tag, payload,title,body,groupKey, "REPLY_ACTION",false)
            //         Log.d("NotificationReceiver", "Accept button clicked for notification ID: $notificationId, payload: $inputText-------------------------------")
            // NotificationModel(
            //     notificationId,
            //     tag,
            //     title,
            //     body,
            //     image,
            //     payload,
            //     groupKey
            // ).showNotificationMessage(context!!)
            //     } else {
            //         Log.d("NotificationReceiver", "No remote input found")
            //     }

               }
            "com.mc_custom_notification.READ" -> {
                sendActionBroadcast(context!!, notificationId, tag, payload,title,body,groupKey, "READ_ACTION",false)
            }
            "com.mc_custom_notification.ACCEPT" -> {
                Log.d("NotificationReceiver", "Accept button clicked for notification ID: $notificationId, tag: $tag, payload: $payload")
                handleNotificationAction(context!!, notificationId, tag, payload,title,body,groupKey, "ACCEPT_ACTION",false)
            }
            "com.mc_custom_notification.DECLINE" -> {
                Log.d("NotificationReceiver", "Reject button clicked for notification ID: $notificationId, tag: $tag, payload: $payload")
                sendActionBroadcast(context!!, notificationId, tag, payload,title,body,groupKey, "DECLINE_ACTION",false)
            }
            "com.mc_custom_notification.CLICK" -> {
                Log.d("NotificationClickReceiver", "Notification clicked for notification ID: $notificationId, tag: $tag, payload: $payload")
                handleNotificationAction(context!!, notificationId, tag, payload,title,body,groupKey, "CLICK_ACTION",false)
            }
            else -> {
                Log.d("NotificationReceiver", "Unknown action received: ${intent?.action}")
            }
        }
    }

    private fun handleNotificationAction(context: Context, notificationId: Int, tag: String?, payload: HashMap<String, Any>?,title:String?,body:String?,groupKey:String?, action: String,isCalling:Boolean) {
        if (!isAppRunning(context, context.packageName)) {
            // If the app is not running, start it
            val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)?.apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
                putExtra("notification_id", notificationId)
                putExtra("tag", tag)
                putExtra("title", title)
                putExtra("body", body)
                putExtra("groupKey", groupKey)
                putExtra("payload", payload)
            }
            context.startActivity(launchIntent)

            // Delay the broadcast until the app is opened
            Handler(Looper.getMainLooper()).postDelayed({
                sendActionBroadcast(context, notificationId, tag, payload,title,body,groupKey, action,false)
            }, 3000) // Adjust the delay as needed
        } else {
            // If the app is running but in the background, bring it to the foreground
            val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)?.apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                putExtra("notification_id", notificationId)
                putExtra("tag", tag)
                putExtra("title", title)
                putExtra("body", body)
                putExtra("groupKey", groupKey)
                putExtra("payload", payload)
            }
            context.startActivity(launchIntent)

            // Send the broadcast immediately
            sendActionBroadcast(context, notificationId, tag, payload,title,body,groupKey, action,isCalling)
        }
    }

    private fun sendActionBroadcast(context: Context, notificationId: Int, tag: String?, payload: HashMap<String, Any>?,title:String?,body:String?,groupKey:String?, action: String,isCalling:Boolean) {
        val actionIntent = Intent("com.mc_custom_notification.$action").apply {
            putExtra("notification_id", notificationId)
                putExtra("tag", tag)
                putExtra("title", title)
                putExtra("body", body)
                putExtra("groupKey", groupKey)
                putExtra("payload", payload)
        }
        context.sendBroadcast(actionIntent)
        if(!isCalling){
        context.let {
            with(NotificationManagerCompat.from(it)) {
                cancel(tag, notificationId)
                }
            }
        }
    }

    private fun isAppRunning(context: Context, packageName: String): Boolean {
        val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val runningTasks = activityManager.getRunningTasks(Int.MAX_VALUE)

        for (task in runningTasks) {
            if (packageName.equals(task.baseActivity?.packageName, ignoreCase = true)) {
                return true
            }
        }
        return false
    }
}
