package com.dilios.lehiboo

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterFragmentActivity() {
    private val channelName = "com.lehiboo.app/file_saver"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "saveToDownloads" -> {
                        val filename = call.argument<String>("filename")
                        val bytes = call.argument<ByteArray>("bytes")
                        val mimeType = call.argument<String>("mimeType")
                            ?: "application/octet-stream"
                        if (filename == null || bytes == null) {
                            result.error("INVALID_ARGS", "filename and bytes required", null)
                            return@setMethodCallHandler
                        }
                        try {
                            Log.i(
                                "Lehiboo/Saver",
                                "saveToDownloads filename=$filename size=${bytes.size}",
                            )
                            val path = saveToDownloads(filename, bytes, mimeType)
                            Log.i("Lehiboo/Saver", "saved to $path")
                            result.success(path)
                        } catch (e: Exception) {
                            Log.e("Lehiboo/Saver", "save failed", e)
                            result.error("SAVE_FAILED", e.localizedMessage, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    /**
     * Writes [bytes] to the public Downloads folder under a "Lehiboo" subfolder.
     * Uses MediaStore on API 29+ (scoped storage compatible) and direct file
     * I/O on older versions. Returns the resulting absolute path or
     * content URI string.
     */
    private fun saveToDownloads(
        filename: String,
        bytes: ByteArray,
        mimeType: String,
    ): String {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val resolver = applicationContext.contentResolver
            val values = ContentValues().apply {
                put(MediaStore.Downloads.DISPLAY_NAME, filename)
                put(MediaStore.Downloads.MIME_TYPE, mimeType)
                put(
                    MediaStore.Downloads.RELATIVE_PATH,
                    "${Environment.DIRECTORY_DOWNLOADS}/Lehiboo",
                )
                put(MediaStore.Downloads.IS_PENDING, 1)
            }
            val collection = MediaStore.Downloads.getContentUri(
                MediaStore.VOLUME_EXTERNAL_PRIMARY
            )
            val itemUri = resolver.insert(collection, values)
                ?: throw IllegalStateException("MediaStore insert returned null")
            resolver.openOutputStream(itemUri).use { out ->
                out?.write(bytes) ?: throw IllegalStateException("openOutputStream null")
            }
            values.clear()
            values.put(MediaStore.Downloads.IS_PENDING, 0)
            resolver.update(itemUri, values, null, null)
            return itemUri.toString()
        }

        // API < 29: direct file write to /storage/emulated/0/Download/Lehiboo/
        val downloadsDir = File(
            Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_DOWNLOADS
            ),
            "Lehiboo",
        )
        if (!downloadsDir.exists()) downloadsDir.mkdirs()
        val file = File(downloadsDir, filename)
        FileOutputStream(file).use { it.write(bytes) }
        return file.absolutePath
    }
}
