package com.mc_custom_notification

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.net.Uri
import android.util.Log
import android.os.Build
import android.os.Parcelable
import android.util.Base64
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import kotlinx.parcelize.Parcelize
import kotlinx.parcelize.RawValue
import android.app.PendingIntent
import android.content.Intent
import java.io.ByteArrayOutputStream
import androidx.core.app.RemoteInput

@Parcelize
data class NotificationModel(
    val id: Int,
    val tag: String?,
    val title: String?,
    val body: String?,
    val imageBase64: String?,
    val payload: @RawValue Map<String, Any>?,
    val groupKey: String?,
    val iconCallingSpeaker:Int=R.drawable.speaker,
    val iconCallingMic:Int=R.drawable.mic,
    val isReplay:Boolean=false,
    val useInbox:Boolean=false,
    val isVibration:Boolean=true
) : Parcelable {

    fun decodeBase64ToBitmap(base64Str: String?): Bitmap? {
        return try {
            val decodedBytes =Base64.decode(base64Str, Base64.DEFAULT)
            BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.size)
        } catch (e: IllegalArgumentException) {
            null
        }
    }

//    fun decodeBase64ToBitmap(): Bitmap? {
//        return imageBase64?.let {
//            val decodedBytes = Base64.decode(it, Base64.DEFAULT)
//            BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.size)
//        }
//    }

    fun showNotificationCall(context: Context) {
        showNotification(context, R.layout.notification_layout_call, RingtoneManager.TYPE_RINGTONE, false, true,false)
    }

    fun showNotificationMessage(context: Context) {
        if(useInbox){
            addChatMessage(context,this)
        }else {
            showNotification(
                context,
                R.layout.notification_layout_message,
                RingtoneManager.TYPE_NOTIFICATION,
                true,
                false,
                true
            )
        }
    }
    fun showNotificationNormal(context: Context) {
        showNotification(context, R.layout.notification_layout_normal, RingtoneManager.TYPE_NOTIFICATION, true, false,false)
    }
    
    fun showNotificationCalling(context: Context) {
        notificationCalling(context)
    }


private fun createChannelNotification(context: Context,channelId:String,channelName:String,ringtoneType: Int,isCalling:Boolean){
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {   
        val soundUri: Uri = RingtoneManager.getDefaultUri(ringtoneType)
        if(isCalling){
       
              val channel = NotificationChannel(
                  channelId,
                  channelName,
                  NotificationManager.IMPORTANCE_DEFAULT
              ).apply {
                  description = "Channel for $channelName"
                  setSound(soundUri,null)
              }
              val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
              notificationManager.createNotificationChannel(channel)
          
        }else{
              val channel = NotificationChannel(
                  channelId,
                  channelName,
                  NotificationManager.IMPORTANCE_HIGH
              ).apply {
                  description = "Channel for $channelName"
                  enableVibration(isVibration)
                  enableLights(true)
                  vibrationPattern = if(isVibration)  longArrayOf(0, 1000, 500, 1000) else   longArrayOf(0L)
                  setSound(soundUri, AudioAttributes.Builder()
                      .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                      .setUsage(if (ringtoneType == RingtoneManager.TYPE_RINGTONE) AudioAttributes.USAGE_NOTIFICATION_RINGTONE else AudioAttributes.USAGE_NOTIFICATION)
                      .build())
              }
              val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
              notificationManager.createNotificationChannel(channel)
            
      }
    }
    }

    private fun showNotification(context: Context, layoutId: Int, ringtoneType: Int, autoCancel: Boolean, fullScreen: Boolean,isChat: Boolean) {
        val channelId = if (ringtoneType == RingtoneManager.TYPE_RINGTONE) {
            "ringtone_notification_channel_id"
        } else {
            "message_notification_channel_id"
        }
        
        val channelName = if (ringtoneType == RingtoneManager.TYPE_RINGTONE) {
            "Ringtone Channel"
        } else {
            "Message Channel"
        }
        createChannelNotification(context,channelId,channelName,ringtoneType,false)
        val soundUri: Uri = RingtoneManager.getDefaultUri(ringtoneType)
    
        // Create intents for "Decline", "Accept", and notification click actions
        val declinePendingIntent = createPendingIntent(context, "DECLINE")
        val acceptPendingIntent = createPendingIntent(context, "ACCEPT")
        val clickPendingIntent = createPendingIntent(context, "CLICK")
        val readPendingIntent = createPendingIntent(context, "READ")
        val replyPendingIntent = createPendingIntent(context, "REPLY",useInbox)
        val hidePendingIntent = createPendingIntent(context, "DECLINE")
      
         val replyLabel = "Enter your reply"
         val remoteInput = RemoteInput.Builder("key_text_reply")
             .setLabel(replyLabel)
             .build()
 
         val smallIconResId = getAppIconResourceId(context)
 
         val replyAction = NotificationCompat.Action.Builder(
            smallIconResId, "Reply", replyPendingIntent)
             .addRemoteInput(remoteInput)
             .build()

             val readAction = NotificationCompat.Action.Builder(
                smallIconResId, "Read", readPendingIntent)
                .build()
    
            val hideAction = NotificationCompat.Action.Builder(
                smallIconResId, "Hide", hidePendingIntent)
                .build()
       

        val builder = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(smallIconResId)
            .setContentTitle(title ?: "Notification Title")
            .setContentText(body ?: "Notification Body")
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setSound(soundUri)
            .setOngoing(!autoCancel)
            .setAutoCancel(autoCancel)
            .setNumber(5)
            .setTicker("ticker")
            .setVibrate(longArrayOf(0, 1000, 500, 1000))
            .setStyle(NotificationCompat.DecoratedCustomViewStyle())
            .setCustomContentView(createCustomContentView(context, layoutId, declinePendingIntent, acceptPendingIntent,))
            .setContentIntent(clickPendingIntent)
            .setGroup(groupKey)
        if(isChat){
            builder.addAction(replyAction)
            .addAction(readAction)
            .addAction(hideAction)
            }

        if (fullScreen) {
            builder.setFullScreenIntent(clickPendingIntent, true)
        }

        NotificationManagerCompat.from(context).apply {
            builder.build().let { notification ->
                notify(tag, id, notification)
            }
        }
    }

    
    private fun notificationCalling(context: Context) {
        val channelId ="calilng_notification_channel_id"  
        val channelName = "calling Channel"
        createChannelNotification(context,channelId,channelName,RingtoneManager.TYPE_NOTIFICATION,true)
        // Create intents for "Decline", "Accept", and notification click actions
        val endCallPendingIntent = createPendingIntent(context, "END_CALLING")
        val speakerPendingIntent = createPendingIntent(context, "SPEAKER")
        val clickPendingIntent = createPendingIntent(context, "CLICK_CALLING")
        val micPendingIntent = createPendingIntent(context, "MIC_CALL")
        val smallIconResId = getAppIconResourceId(context)

        val builder = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(smallIconResId)
            .setContentTitle(title ?: "Notification Title")
            .setContentText("Calling ...")
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .setOngoing(true)
            .setAutoCancel(false)
            .setNumber(5)
            .setTicker("ticker")
            .setVibrate(longArrayOf(0, 1000, 500, 1000))
            .setCustomContentView(RemoteViews(context.packageName, R.layout.notification_layout_calling).apply {
                setTextViewText(R.id.txtTitle, title)
                setTextViewText(R.id.incoming_call, "Calling ...")
                setImageViewResource(R.id.btnSpeaker,iconCallingSpeaker) // Change icon
                setImageViewResource(R.id.btnMic,iconCallingMic)
                setOnClickPendingIntent(R.id.btnEndCall, endCallPendingIntent)
                setOnClickPendingIntent(R.id.btnMic, micPendingIntent)
                setOnClickPendingIntent(R.id.btnSpeaker, speakerPendingIntent)
            })
            .setContentIntent(clickPendingIntent)
            .setGroup(groupKey)
        NotificationManagerCompat.from(context).apply {
            builder.build().let { notification ->
                notify(tag, id, notification)
            }
        }
    }

    private fun createPendingIntent(context: Context, action: String,isReplayMSG:Boolean=false): PendingIntent {
       // Log.d( "useInbox: ","e:$useInbox---------------------------------33")
        val intent = Intent(context, NotificationReceiver::class.java).apply {
            this.action = "com.mc_custom_notification.$action"
            putExtra("notification_id", id)
            putExtra("tag", tag)
            putExtra("title", title)
            putExtra("body", body)
            putExtra("groupKey", groupKey)
            putExtra("payload", HashMap(payload))
            putExtra("useInbox", useInbox)
//            if(isReplayMSG) {
              //  Log.d( "useInbox: ","e:$useInbox---------------------------------1")
//                putExtra("imageBase64", decodeBase64ToBitmap(imageBase64))
//            }
        }
        return PendingIntent.getBroadcast(context, id, intent,if(isReplayMSG) 0 else PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
    }

    private fun createCustomContentView(context: Context, layoutId: Int, declinePendingIntent: PendingIntent, acceptPendingIntent: PendingIntent): RemoteViews {
        return RemoteViews(context.packageName, layoutId).apply {
            setTextViewText(R.id.txtTitle, title)
            setTextViewText(R.id.incoming_call, body)
            if(imageBase64!=null){
            decodeBase64ToBitmap(imageBase64)?.let { bitmap ->
                setImageViewBitmap(R.id.notify_alert_caller_image, bitmap)
            }
            }
            setOnClickPendingIntent(R.id.btnDecline, declinePendingIntent)
            setOnClickPendingIntent(R.id.btnAccept, acceptPendingIntent)
           
       
        }
    }

    fun cancel(context: Context) {
        NotificationManagerCompat.from(context).apply {
            if (tag != null) {
                cancel(tag, id)
            } else {
                cancel(id)
            }
        }
    }
    
  
    fun cancelAll(context: Context) {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancelAll()
    }
 companion object {
     ///start group
     private val messages = mutableListOf<NotificationCompat.MessagingStyle.Message>()
     fun addChatMessage(context: Context, notificationModel: NotificationModel) {
         val bitmap = notificationModel.decodeBase64ToBitmap(notificationModel.imageBase64 ?: "")
         val person = createPerson(notificationModel.title?:"", bitmap)
         notificationModel.createChannelNotification(context,"message_notification_channel_id","Message Channel",RingtoneManager.TYPE_NOTIFICATION,false)
         val message = NotificationCompat.MessagingStyle.Message(notificationModel.body, System.currentTimeMillis(), person)
         messages.add(message)
         displayNotification(context,notificationModel)
     }

     private fun displayNotification(context: Context,notificationModel: NotificationModel) {

         val messagingStyle = NotificationCompat.MessagingStyle("Me")
             .setConversationTitle("Chat")
         messages.forEach { message ->
             messagingStyle.addMessage(message)
         }


         val clickPendingIntent = notificationModel.createPendingIntent(context, "CLICK",notificationModel.useInbox)
         val readPendingIntent = notificationModel.createPendingIntent(context, "READ",notificationModel.useInbox)
         val replyPendingIntent = notificationModel.createPendingIntent(context, "REPLY",notificationModel.useInbox)
         val hidePendingIntent = notificationModel.createPendingIntent(context, "DECLINE")

         val replyLabel = "Enter your reply"
         val remoteInput = RemoteInput.Builder("key_text_reply")
             .setLabel(replyLabel)
             .build()

         val smallIconResId = getAppIconResourceId(context)

         val replyAction = NotificationCompat.Action.Builder(
             smallIconResId, "Reply", replyPendingIntent)
             .addRemoteInput(remoteInput)
             .build()

         val readAction = NotificationCompat.Action.Builder(
             smallIconResId, "Read", readPendingIntent)
             .build()

         val hideAction = NotificationCompat.Action.Builder(
             smallIconResId, "Hide", hidePendingIntent)
             .build()


         val builder = NotificationCompat.Builder(context, "message_notification_channel_id")
             .setSmallIcon(smallIconResId)
             .setPriority(NotificationCompat.PRIORITY_MAX)
             .setStyle(messagingStyle)
             .setContentIntent(clickPendingIntent)
             .setGroup(notificationModel.groupKey)
             .addAction(replyAction)
                 .addAction(readAction)
                 .addAction(hideAction)
         if(notificationModel.isVibration){
             builder.setVibrate(longArrayOf(0L))
         }



         NotificationManagerCompat.from(context).apply {
             builder.build().let { notification ->
                 notify(notificationModel.tag, notificationModel.id, notification)
             }
         }
     }
     //end group
        fun getAll(context: Context): List<Map<String, Any>> {
            val notifications = mutableListOf<Map<String, Any>>()
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                val activeNotifications = notificationManager.activeNotifications
                for (notification in activeNotifications) {

                    val notificationMap = mapOf(
                        "id" to notification.id,
                        "packageName" to notification.packageName,
                        "tag" to notification.tag,

                        "title" to notification.notification.extras.getString(NotificationCompat.EXTRA_TITLE, ""),
                        "text" to notification.notification.extras.getString(NotificationCompat.EXTRA_TEXT, "")
                    )
                    notifications.add(notificationMap)
                }
            }
            return notifications
        }

        
        private fun getAppIconResourceId(context: Context): Int {
            return try {
                val packageManager = context.packageManager
                val appInfo = context.applicationInfo
                appInfo.icon ?: R.drawable.ic_launcher
            } catch (e: Exception) {
                R.drawable.ic_launcher
            }
        }
    }
}
