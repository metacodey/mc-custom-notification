package com.mc_custom_notification

import android.app.ActivityManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.RemoteInput


class NotificationReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        val notificationId = intent?.getIntExtra("notification_id", 0) ?: return
        val tag = intent.getStringExtra("tag")
        val groupKey = intent.getStringExtra("groupKey")
        val body = intent.getStringExtra("body")
        val title = intent.getStringExtra("title")
        val payload = intent.getSerializableExtra("payload") as? HashMap<String, Any>
        val useInbox=intent.getBooleanExtra("useInbox",false)
//        val image = intent.getParcelableExtra("BitmapImage") as Bitmap?;

        //Log.d("useInbox", "useInbox: $useInbox, image:$image---------------------------------1")
       
        when (intent?.action) {
            "com.mc_custom_notification.FULL_SCREEN" -> {
                // Handle full-screen intent action
            }
            "com.mc_custom_notification.DELETE_NOTI" -> {
                Log.d("NotificationReceiver", "DELETE_ACTION button clicked for notification ID: $notificationId")
                sendActionBroadcast(context!!, notificationId, tag, payload,title,body,groupKey, "DELETE_ACTION",false,useInbox)

            }
            "com.mc_custom_notification.END_CALLING" -> {
                Log.d("NotificationReceiver", "END_CALLING_ACTION button clicked for notification ID: $notificationId, tag: $tag, payload: $payload")
                sendActionBroadcast(context!!, notificationId, tag, payload,title,body,groupKey, "END_CALLING_ACTION",false)

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
                    sendActionBroadcast(context!!, notificationId, tag, payload, title, body, groupKey, "REPLY_ACTION", true,useInbox)

                } ?: run {
                    Log.d("NotificationReceiver", "No remote input found")
                }

               }
            "com.mc_custom_notification.READ" -> {
                sendActionBroadcast(context!!, notificationId, tag, payload,title,body,groupKey, "READ_ACTION",false,useInbox)
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
                Log.d("NotificationClickReceiver", "Notification clicked for notification ID: $notificationId, tag: $tag,GroupKey:$groupKey , payload: $payload")
                handleNotificationAction(context!!, notificationId, tag, payload,title,body,groupKey, "CLICK_ACTION",false,useInbox)
            }
            else -> {
                Log.d("NotificationReceiver", "Unknown action received: ${intent?.action}")
            }
        }
    }

    private fun handleNotificationAction(context: Context, notificationId: Int, tag: String?, payload: HashMap<String, Any>?,title:String?,body:String?,groupKey:String?, action: String,isCalling:Boolean,useInbox:Boolean=false) {
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
                putExtra("useInbox", useInbox)
            }
            context.startActivity(launchIntent)

            // Delay the broadcast until the app is opened
            Handler(Looper.getMainLooper()).postDelayed({
                sendActionBroadcast(context, notificationId, tag, payload,title,body,groupKey, action,false,useInbox)
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
                putExtra("useInbox", useInbox)
            }
            context.startActivity(launchIntent)

            // Send the broadcast immediately
            sendActionBroadcast(context, notificationId, tag, payload,title,body,groupKey, action,isCalling,useInbox)
        }
    }

    private fun sendActionBroadcast(context: Context, notificationId: Int, tag: String?, payload: HashMap<String, Any>?,title:String?,body:String?,groupKey:String?, action: String,isCalling:Boolean,useInbox:Boolean=false,image:Bitmap?=null) {
        val actionIntent = Intent("com.mc_custom_notification.$action").apply {
            putExtra("notification_id", notificationId)
                putExtra("tag", tag)
                putExtra("title", title)
                putExtra("body", body)
                putExtra("groupKey", groupKey)
                putExtra("payload", payload)
            putExtra("useInbox", useInbox)
            if(image!=null){
                putExtra("image", image)
            }
        }
        context.sendBroadcast(actionIntent)
        //Log.d("useInbox", "useInbox: $useInbox,Image:$image tag:---------------------------------")
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
