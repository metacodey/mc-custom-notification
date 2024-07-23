package com.mc_custom_notification

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.content.IntentFilter
import android.media.AudioManager
import androidx.lifecycle.LifecycleObserver
import android.app.Application
import android.os.Bundle

class CostumNotificationCallPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, LifecycleObserver {
    private lateinit var channel: MethodChannel
    private lateinit var channelCall: MethodChannel
    private lateinit var channelMessage: MethodChannel
    private lateinit var channelCalling: MethodChannel
    private var context: Context? = null
    private var idNoti: Int = 0
    private var tagNoti: String = ""
    private var isSpeaker: Boolean = false
    private var isMicMute: Boolean = false

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "costum_notification")
        channel.setMethodCallHandler(this)
        channelCall = MethodChannel(flutterPluginBinding.binaryMessenger, "costum_notification_call")
        channelCall.setMethodCallHandler(this)
        channelCalling = MethodChannel(flutterPluginBinding.binaryMessenger, "costum_notification_calling")
        channelCalling.setMethodCallHandler(this)
        channelMessage = MethodChannel(flutterPluginBinding.binaryMessenger, "costum_notification_message")
        channelMessage.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        // Register the broadcast receivers
        registerReceivers(context)
        // Register the activity lifecycle callbacks
        (context as? Application)?.registerActivityLifecycleCallbacks(activityLifecycleCallbacks)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        channelCall.setMethodCallHandler(null)
        channelCalling.setMethodCallHandler(null)
        channelCalling.setMethodCallHandler(null)
        unregisterReceivers(context)
        // Unregister the activity lifecycle callbacks
        (context as? Application)?.unregisterActivityLifecycleCallbacks(activityLifecycleCallbacks)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        context = binding.activity.applicationContext
    }

    override fun onDetachedFromActivityForConfigChanges() {
        context = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        context = binding.activity.applicationContext
    }

    override fun onDetachedFromActivity() {
        context = null
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "showNotificationCall" -> {
                val notificationModel = NotificationModel(
                    id = call.argument("id") ?: 0,
                    tag = call.argument("tag"),
                    title = call.argument("title"),
                    body = call.argument("body"),
                    imageBase64 = call.argument("base64Image"),
                    payload = call.argument("payload"),
                    groupKey = call.argument("groupKey")
                )
                notificationModel.showNotificationCall(context!!)
                result.success(null)
            }
            "showNotificationCalling" -> {
                tagNoti = call.argument("tag") ?: ""
                idNoti = call.argument("id") ?: 0
                val notificationModel = NotificationModel(
                    id = call.argument("id") ?: 0,
                    tag = call.argument("tag"),
                    title = call.argument("title"),
                    body = call.argument("body"),
                    imageBase64 = call.argument("base64Image"),
                    payload = call.argument("payload"),
                    groupKey = call.argument("groupKey")
                )
                notificationModel.showNotificationCalling(context!!)
                result.success(null)
            }
            "showNotificationMessage" -> {
                val notificationModel = NotificationModel(
                    id = call.argument("id") ?: 0,
                    tag = call.argument("tag"),
                    title = call.argument("title"),
                    body = call.argument("body"),
                    imageBase64 = call.argument("base64Image"),
                    payload = call.argument("payload"),
                    groupKey = call.argument("groupKey")
                )
                notificationModel.showNotificationMessage(context!!)
                result.success(null)
            }
            "showNotificationNormal" -> {
                val notificationModel = NotificationModel(
                    id = call.argument("id") ?: 0,
                    tag = call.argument("tag"),
                    title = call.argument("title"),
                    body = call.argument("body"),
                    imageBase64 = call.argument("base64Image"),
                    payload = call.argument("payload"),
                    groupKey = call.argument("groupKey")
                )
                notificationModel.showNotificationNormal(context!!)
                result.success(null)
            }
            "cancelNotification" -> {
                val id = call.argument<Int>("id") ?: 0
                val tag = call.argument<String>("tag")
                val notificationModel = NotificationModel(id, tag, null, null, null, null, null)
                notificationModel.cancel(context!!)
                result.success(null)
            }
            "cancelAllNotification" -> {
                val notificationModel = NotificationModel(0, "", null, null, null, null, null)
                notificationModel.cancelAll(context!!)
                result.success(null)
            }
            "getAllNotifications" -> {
                val notifications = NotificationModel.getAll(context!!)
                result.success(notifications)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun registerReceivers(context: Context?) {
        context?.registerReceiver(declineReceiver, IntentFilter("com.mc_custom_notification.DECLINE_ACTION"))
        context?.registerReceiver(acceptReceiver, IntentFilter("com.mc_custom_notification.ACCEPT_ACTION"))
        context?.registerReceiver(clickReceiver, IntentFilter("com.mc_custom_notification.CLICK_ACTION"))
        context?.registerReceiver(readReceiver, IntentFilter("com.mc_custom_notification.READ_ACTION"))
        context?.registerReceiver(replyReceiver, IntentFilter("com.mc_custom_notification.REPLY_ACTION"))
        context?.registerReceiver(switchMicReceiver, IntentFilter("com.mc_custom_notification.MIC_CALL_ACTION"))
        context?.registerReceiver(switchSpeakerReceiver, IntentFilter("com.mc_custom_notification.SPEAKER_ACTION"))
        context?.registerReceiver(endCallingReceiver, IntentFilter("com.mc_custom_notification.END_CALLING_ACTION"))
    }

    private fun unregisterReceivers(context: Context?) {
        context?.unregisterReceiver(declineReceiver)
        context?.unregisterReceiver(acceptReceiver)
        context?.unregisterReceiver(clickReceiver)
        context?.unregisterReceiver(readReceiver)
        context?.unregisterReceiver(replyReceiver)
        context?.unregisterReceiver(switchMicReceiver)
        context?.unregisterReceiver(switchSpeakerReceiver)
        context?.unregisterReceiver(endCallingReceiver)
    }

    private val activityLifecycleCallbacks = object : Application.ActivityLifecycleCallbacks {
        override fun onActivityCreated(activity: android.app.Activity, savedInstanceState: Bundle?) {}
        override fun onActivityStarted(activity: android.app.Activity) {}
        override fun onActivityResumed(activity: android.app.Activity) {}
        override fun onActivityPaused(activity: android.app.Activity) {}
        override fun onActivityStopped(activity: android.app.Activity) {}
        override fun onActivitySaveInstanceState(activity: android.app.Activity, outState: Bundle) {}
        override fun onActivityDestroyed(activity: android.app.Activity) {
            // Cancel all notifications when the activity is destroyed
            if (context != null) {
                NotificationModel(idNoti, tagNoti, null, null, null, null, null).cancel(context!!)
            }
        }
    }

    private val declineReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            val notificationId = intent?.getIntExtra("notification_id", 0) ?: return
            val tag = intent.getStringExtra("tag")
            val payload = intent.getSerializableExtra("payload") as? HashMap<String, Any>
           // channel.invokeMethod("onDecline", mapOf("notification_id" to notificationId, "tag" to tag, "payload" to payload))
            channelCall.invokeMethod("onDecline", mapOf("notification_id" to notificationId, "tag" to tag, "payload" to payload))
        }
    }

    private val acceptReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            val notificationId = intent?.getIntExtra("notification_id", 0) ?: return
            val tag = intent.getStringExtra("tag")
            val payload = intent.getSerializableExtra("payload") as? HashMap<String, Any>
           // channel.invokeMethod("onAccept", mapOf("notification_id" to notificationId, "tag" to tag, "payload" to payload))
            channelCall.invokeMethod("onAccept", mapOf("notification_id" to notificationId, "tag" to tag, "payload" to payload))
        }
    }

    private val clickReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            val notificationId = intent?.getIntExtra("notification_id", 0) ?: return
            val tag = intent.getStringExtra("tag")
            val payload = intent.getSerializableExtra("payload") as? HashMap<String, Any>
            channel.invokeMethod("onClick", mapOf("notification_id" to notificationId, "tag" to tag, "payload" to payload))
        }
    }

    private val readReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            val notificationId = intent?.getIntExtra("notification_id", 0) ?: return
            val tag = intent.getStringExtra("tag")
            val payload = intent.getSerializableExtra("payload") as? HashMap<String, Any>
            channelMessage.invokeMethod("onRead", mapOf("notification_id" to notificationId, "tag" to tag, "payload" to payload))
        }
    }

    private val replyReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            val notificationId = intent?.getIntExtra("notification_id", 0) ?: return
            val tag = intent.getStringExtra("tag")
            val payload = intent.getSerializableExtra("payload") as? HashMap<String, Any>
            channelMessage.invokeMethod("onReply", mapOf("notification_id" to notificationId, "tag" to tag, "payload" to payload))
        }
    }

    private val switchMicReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (context != null) {
                val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
                audioManager.requestAudioFocus(null, AudioManager.STREAM_VOICE_CALL, AudioManager.AUDIOFOCUS_GAIN_TRANSIENT)
                audioManager.mode = AudioManager.MODE_IN_COMMUNICATION
                val speakerIcon = getIconSpeaker()
                if (isMicMute) {
                    isMicMute = false
                    audioManager.isMicrophoneMute = false
                    updateNotification(context, intent, speakerIcon, R.drawable.mic)
                } else {
                    isMicMute = true
                    audioManager.isMicrophoneMute = true
                    updateNotification(context, intent, speakerIcon, R.drawable.mic_green)
                }
            }
            channel.invokeMethod("onMic", isMicMute)
        }
    }

    private val switchSpeakerReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (context != null) {
                val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
                audioManager.requestAudioFocus(null, AudioManager.STREAM_VOICE_CALL, AudioManager.AUDIOFOCUS_GAIN_TRANSIENT)
                audioManager.mode = AudioManager.MODE_IN_COMMUNICATION
                val micIcon = getIconMic()
                if (isSpeaker) {
                    isSpeaker = false
                    audioManager.isSpeakerphoneOn = false
                    updateNotification(context, intent, R.drawable.speaker, micIcon)
                } else {
                    isSpeaker = true
                    audioManager.isSpeakerphoneOn = true
                    updateNotification(context, intent, R.drawable.speaker_green, micIcon)
                }
                channel.invokeMethod("onSpeaker", isSpeaker)
            }
        }
    }

    private fun getIconSpeaker(): Int {
        return if (isSpeaker) {
            R.drawable.speaker_green
        } else {
            R.drawable.speaker
        }
    }

    private fun getIconMic(): Int {
        return if (isMicMute) {
            R.drawable.mic_green
        } else {
            R.drawable.mic
        }
    }

    private val endCallingReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (context != null) {
                val notificationId = intent?.getIntExtra("notification_id", 0) ?: return
                val tag = intent.getStringExtra("tag")
                val payload = intent.getSerializableExtra("payload") as? HashMap<String, Any>
                val notificationModel = NotificationModel(notificationId, tag, null, null, null, null, null)
                notificationModel.cancel(context!!)
                channelCalling.invokeMethod("onEndCall", mapOf("notification_id" to notificationId, "tag" to tag, "payload" to payload))
                //channelTest.invokeMethod("onEndCall", mapOf("notification_id" to notificationId, "tag" to tag, "payload" to payload))
            }
        }
    }

    private fun updateNotification(context: Context?, intent: Intent?, iconSpeaker: Int, iconMic: Int) {
        val notificationId = intent?.getIntExtra("notification_id", 0) ?: return
        val tag = intent.getStringExtra("tag")
        val groupKey = intent.getStringExtra("groupKey")
        val body = intent.getStringExtra("body")
        val title = intent.getStringExtra("title")
        val payload = intent.getSerializableExtra("payload") as? HashMap<String, Any>
        val notificationModel = NotificationModel(
            notificationId,
            tag,
            title,
            body,
            null,
            payload,
            groupKey,
            iconSpeaker,
            iconMic
        )
        notificationModel.showNotificationCalling(context!!)
    }
}
