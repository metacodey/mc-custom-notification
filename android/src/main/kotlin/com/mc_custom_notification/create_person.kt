package com.mc_custom_notification

import android.graphics.Bitmap
import androidx.core.app.Person
import androidx.core.graphics.drawable.IconCompat

fun createPerson(userName: String, userProfileBitmap: Bitmap?): Person {
    val personBuilder = Person.Builder().setName(userName)
    if (userProfileBitmap != null) {
        val icon = IconCompat.createWithBitmap(userProfileBitmap)
        personBuilder.setIcon(icon)
    }
    return personBuilder.build()
}
