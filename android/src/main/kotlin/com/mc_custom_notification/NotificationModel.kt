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
import androidx.core.app.RemoteInput
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Rect
import android.graphics.RectF
import android.os.Handler
import android.os.Looper

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

    fun makeCircularBitmap(bitmap: Bitmap): Bitmap {
        val size = Math.min(bitmap.width, bitmap.height)
        val output = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(output)

        val paint = Paint()
        val rect = Rect(0, 0, size, size)
        val rectF = RectF(rect)

        paint.isAntiAlias = true
        canvas.drawARGB(0, 0, 0, 0)
        paint.color = Color.parseColor("#BAB399") // Optional: Add a border color
        canvas.drawOval(rectF, paint)

        paint.xfermode = android.graphics.PorterDuffXfermode(android.graphics.PorterDuff.Mode.SRC_IN)
        canvas.drawBitmap(bitmap, rect, rect, paint)

        return output
    }
    fun decodeBase64ToBitmap(base64Str: String?): Bitmap? {
        return try {
            val decodedBytes =Base64.decode(base64Str, Base64.DEFAULT)
            BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.size)
        } catch (e: IllegalArgumentException) {
            null
        }
    }
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
         Log.d( "createPendingIntent: ","e:$groupKey---------------------------------33")
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
                    val circularBitmap = makeCircularBitmap(bitmap)
                    setImageViewBitmap(R.id.notify_alert_caller_image, circularBitmap)
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
        removeNotificationByTag(tag+id.toString())
    }


    fun cancelAll(context: Context) {
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancelAll()
        clearMessages();
    }
    fun removeNoit(idNoti: String,groupKeyMsg: String?=null,context: Context?=null) {
        removeNotificationByTag(idNoti)
        cancelNotificationSummary(groupKeyMsg,context)

    }
    companion object {
        ///start group
        private val messagesByGroup = mutableMapOf<String, MutableList<NotificationCompat.MessagingStyle.Message>>()
        fun createPresonMessage(notificationModel: NotificationModel):  NotificationCompat.MessagingStyle.Message {
            // تحويل الصورة من Base64 إلى Bitmap
            val bitmap = notificationModel.decodeBase64ToBitmap(notificationModel.imageBase64 ?: "")
            // إذا كانت الصورة موجودة، قم بتطبيق التدوير الدائري عليها
            val circularBitmap = bitmap?.let { notificationModel.makeCircularBitmap(it) }

            // إنشاء الشخص باستخدام عنوان الرسالة وبيانات أخرى مع تعيين مفتاح فريد (key)
            val person = createPerson(notificationModel.title ?: "", circularBitmap, notificationModel.tag + notificationModel.id.toString()+"-"+notificationModel.title)

            // إنشاء الرسالة باستخدام MessagingStyle
            val message = NotificationCompat.MessagingStyle.Message(notificationModel.body, System.currentTimeMillis(), person)
//
//            // إضافة الرسالة إلى قائمة الرسائل
            val groupMessages = messagesByGroup.getOrPut(notificationModel.groupKey ?: "default_group") { mutableListOf() }
            groupMessages.add(message)

            return message

        }
        fun addChatMessage(context: Context, notificationModel: NotificationModel) {

            // إنشاء القناة للإشعارات
            notificationModel.createChannelNotification(context, "message_notification_channel${notificationModel.isVibration}", "Message Channel Notification", RingtoneManager.TYPE_NOTIFICATION, false)
            createPresonMessage(notificationModel)
            // عرض الإشعار
            displayNotification(context, notificationModel)

        }
        fun clearMessages(groupKey: String? = null) {
            if (groupKey != null) {
                messagesByGroup.remove(groupKey)
                Log.d("NotificationClear", "Messages for group $groupKey have been cleared.")
            } else {
                messagesByGroup.clear()
                Log.d("NotificationClear", "All messages have been cleared.")
            }
        }
        fun cancelNotificationSummary(groupKey: String? = null, context: Context? = null) {
            if (groupKey != null && context != null) {
                val summaryNotificationId = groupKey.hashCode()
                Log.d("NotificationDelete", "Summary notification for group $groupKey removed as no messages are left. $summaryNotificationId")
                if (messagesByGroup[groupKey].isNullOrEmpty()) {
                    messagesByGroup.remove(groupKey)
                    NotificationManagerCompat.from(context).cancel(summaryNotificationId)
                    Log.d("NotificationDelete", "Summary notification for group $groupKey removed as no messages are left.")
               }
            }
        }
        fun removeNotificationByTag(id: String) {
            messagesByGroup.forEach { (groupKey, messages) ->
                messages.removeAll { message ->
                    val key = message.person?.key ?: ""
                    val firstPart = key.split("-").firstOrNull()
                    firstPart == id
                }
            }
            Log.d("NotificationDelete", "Removed messages with title: $id")
            Log.d("NotificationDelete", "Remaining messages: $messagesByGroup")
        }
        private fun displayNotification(context: Context, notificationModel: NotificationModel) {
            val keyPerson = notificationModel.tag + notificationModel.id.toString()
            val groupKey = notificationModel.groupKey ?: "default_group" // استخدام قيمة افتراضية إذا كانت groupKey فارغة
            val groupMessages = messagesByGroup[groupKey] ?: mutableListOf()

            // إنشاء MessagingStyle للإشعار
            val messagingStyle = NotificationCompat.MessagingStyle("Me")
             //   .setConversationTitle("Chat with ${notificationModel.title ?: "Unknown"}")
            val currentKey = notificationModel.tag + notificationModel.id.toString() + "-" + (notificationModel.title ?: "")

            // تصفية الرسائل التي تخص هذا الشخص فقط
            val filteredMessages = groupMessages.filter { message ->
                val personKey = message.person?.key?.split("-")?.firstOrNull()
                personKey == keyPerson
            }

            // إضافة الرسائل الخاصة بهذا الشخص فقط
            filteredMessages.forEach { message ->
                messagingStyle.addMessage(message)
            }

            // التحقق إذا كان المستخدم الحالي جديدًا
            val userExists = filteredMessages.any { it.person?.key == currentKey }

            if (!userExists) {
                // إذا لم يكن المستخدم موجودًا، إنشاء رسالة جديدة وإضافتها إلى الإشعار
                val newMessage = createPresonMessage(notificationModel)
                messagingStyle.addMessage(newMessage)
            }
            // Get unique person count for the group
            val uniquePersonsCount = groupMessages.mapNotNull { it.person?.key }.toSet().size
            val messageCount = groupMessages.size

            // تحديد PendingIntents للأفعال المختلفة
            val deletePendingIntent = notificationModel.createPendingIntent(context, "DELETE_NOTI", notificationModel.useInbox)
            val clickPendingIntent = notificationModel.createPendingIntent(context, "CLICK", notificationModel.useInbox)
            val readPendingIntent = notificationModel.createPendingIntent(context, "READ", notificationModel.useInbox)
            val replyPendingIntent = notificationModel.createPendingIntent(context, "REPLY", notificationModel.useInbox)
            val hidePendingIntent = notificationModel.createPendingIntent(context, "DECLINE")

            val replyLabel = "Enter your reply"
            val remoteInput = RemoteInput.Builder("key_text_reply")
                .setLabel(replyLabel)
                .build()

            val smallIconResId = getAppIconResourceId(context)

            val replyAction = NotificationCompat.Action.Builder(smallIconResId, "Reply", replyPendingIntent)
                .addRemoteInput(remoteInput)
                .build()

            val readAction = NotificationCompat.Action.Builder(smallIconResId, "Read", readPendingIntent)
                .build()

            val hideAction = NotificationCompat.Action.Builder(smallIconResId, "Hide", hidePendingIntent)
                .build()

            val builder = NotificationCompat.Builder(context, "message_notification_channel${notificationModel.isVibration}")
                .setSmallIcon(smallIconResId)
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setStyle(messagingStyle)
                .setGroupAlertBehavior(NotificationCompat.GROUP_ALERT_SUMMARY)
                .setContentIntent(clickPendingIntent)
                .setGroup(groupKey) // استخدام groupKey الافتراضي أو القيمة الفعلية
                .setDeleteIntent(deletePendingIntent)
                .addAction(replyAction)
                .addAction(readAction)
                .addAction(hideAction)

            if (notificationModel.isVibration) {
                builder.setVibrate(longArrayOf(0L, 500L, 200L))
            }

            val summaryNotificationId = groupKey.hashCode()

            val summaryNotification = NotificationCompat.Builder(context, "message_notification_channel${notificationModel.isVibration}")
                .setSmallIcon(smallIconResId)
                .setSubText("$messageCount Messages From $uniquePersonsCount Chat ")
                .setGroup(groupKey)
                .setGroupSummary(true)
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setContentIntent(clickPendingIntent)
                .setGroupAlertBehavior(NotificationCompat.GROUP_ALERT_SUMMARY)
                .addAction(replyAction)
                .addAction(readAction)
                .addAction(hideAction)
                .setDeleteIntent(deletePendingIntent)

            NotificationManagerCompat.from(context).apply {
                builder.build().let { notification ->
                    notify(notificationModel.tag, notificationModel.id, notification)
                }
                notify(summaryNotificationId, summaryNotification.build())
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
