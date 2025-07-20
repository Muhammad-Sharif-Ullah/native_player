package com.example.native_player

import io.flutter.embedding.android.FlutterActivity
import android.net.Uri;
import androidx.media3.common.MediaItem;
import androidx.media3.exoplayer.ExoPlayer;
import androidx.media3.ui.PlayerView;
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine

/// This is the main activity for the Flutter application.
/// It extends FlutterActivity, which provides the necessary integration with Flutter.

// Method channel for communication between Flutter and native Android code.

/// method's are
/// 1. initializeExoPlayer
/// 2. play
/// 3. pause
/// 4. stop
/// 5. seekTo
class MainActivity : FlutterActivity() {

    // flutter channel name 
    private val CHANNEL = "com.example.native_player/exoplayer"

    private lateinit var methodChannel: MethodChannel

    // ExoPlayer instance
    private var exoPlayer: ExoPlayer? = null

    // Initialize ExoPlayer
    private fun initializeExoPlayer() {
        exoPlayer = ExoPlayer.Builder(this).build()
    }

    // Override the configureFlutterEngine method to set up the method channel
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

           // Initialize ExoPlayer when the Flutter engine is configured
        initializeExoPlayer()

         // Initialize MethodChannel
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        // Set up the method channel for communication with Flutter
       methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "initializeExoPlayer" -> {
                    initializeExoPlayer()
                    result.success(null)
                }
                "play" -> {
                    // exoPlayer?.play()
                    // result.success(null)
                    // Check if the URL is provided
                    val url = call.argument<String>("url")
                    if (url != null) {
                        // Prepare the media source and play
                        val mediaItem = MediaItem.fromUri(url)
                        exoPlayer?.setMediaItem(mediaItem)
                        exoPlayer?.prepare()
                        exoPlayer?.play()
                        result.success(null)
                    } else {
                        result.error("INVALID_ARGUMENT", "URL is required", null)
                        return@setMethodCallHandler
                    }
                }
                "pause" -> {
                    exoPlayer?.pause()
                    result.success(null)
                }
                "stop" -> {
                    exoPlayer?.stop()
                    result.success(null)
                }
                "seekTo" -> {
                    val position = call.argument<Long>("position")
                    if (position != null) {
                        exoPlayer?.seekTo(position)
                        result.success(null)
                    } else {
                        result.error("INVALID_ARGUMENT", "Position is required", null)
                    }
                }
                else -> result.notImplemented()
            }
        }

    }


    // onDestroy method to release ExoPlayer resources
    override fun onDestroy() {
        super.onDestroy()
        // Release ExoPlayer resources when the activity is destroyed
        exoPlayer?.release()
        exoPlayer = null
    }
}
