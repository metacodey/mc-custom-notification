package com.example.costum_notification_call_example

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.chat_notification_app/chat"

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "sendChatMessage") {
                val text = call.argument<String>("text") ?: ""
                val sender = call.argument<String>("sender") ?: "User"
                val id = call.argument<Int>("id") ?: 0
                val tag = call.argument<String>("tag") ?: "tag"
                addChatMessage(this,id,tag, text, System.currentTimeMillis(), sender)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    companion object {
        private val messages = mutableListOf<NotificationCompat.MessagingStyle.Message>()

        fun createNotificationChannel(context: Context) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val name = "ChatChannel"
                val descriptionText = "Channel for chat messages"
                val importance = NotificationManager.IMPORTANCE_HIGH
                val channel = NotificationChannel("CHAT_CHANNEL_ID", name, importance).apply {
                    description = descriptionText
                }
                val notificationManager: NotificationManager =
                    context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                notificationManager.createNotificationChannel(channel)
            }
        }

        fun addChatMessage(context: Context, id:Int,tag:String?, text: String, timestamp: Long, sender: String) {
            val message = NotificationCompat.MessagingStyle.Message(text, timestamp, sender)
            messages.add(message)
            displayNotification(context,id,tag!!)
        }

        private fun displayNotification(context: Context,id:Int,tag:String) {
            val messagingStyle = NotificationCompat.MessagingStyle("Me")
                .setConversationTitle("Chat")
            messages.forEach { message ->
                messagingStyle.addMessage(message)
            }

            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            }
            val pendingIntent: PendingIntent = PendingIntent.getActivity(context, 0, intent, 0)

            val builder = NotificationCompat.Builder(context, "CHAT_CHANNEL_ID")
                .setSmallIcon(R.drawable.ic_launcher)
                .setStyle(messagingStyle)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setContentIntent(pendingIntent)
                .setAutoCancel(true)

            with(NotificationManagerCompat.from(context)) {
                notify(tag,id,builder.build())
            }
        }
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createNotificationChannel(this)
    }
    
}
