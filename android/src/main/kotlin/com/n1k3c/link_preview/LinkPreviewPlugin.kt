package com.n1k3c.link_preview

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import com.leocardz.link.preview.library.SourceContent
import com.leocardz.link.preview.library.LinkPreviewCallback
import com.leocardz.link.preview.library.TextCrawler
import io.flutter.plugin.common.EventChannel
import java.util.*


class LinkPreviewPlugin : MethodCallHandler, EventChannel.StreamHandler {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val methodChannel = MethodChannel(registrar.messenger(), "link_preview")
            methodChannel.setMethodCallHandler(LinkPreviewPlugin())

            val eventChannel = EventChannel(registrar.messenger(), "link_preview_events")
            eventChannel.setStreamHandler(LinkPreviewPlugin())
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE} - ")
        } else {
            result.notImplemented()
        }
    }

    override fun onListen(arguments: Any, event: EventChannel.EventSink) {
        val textCrawler = TextCrawler()


        val linkPreviewCallback = object : LinkPreviewCallback {
            override fun onPre() {
                event.success("loading")
            }

            override fun onPos(sourceContent: SourceContent, b: Boolean) {
                event.success("working")
                if (sourceContent.isSuccess) {
                    event.success("done = " + sourceContent.title)
                    event.success("done2 = " + sourceContent.description)
                    event.endOfStream()
                }
            }
        }

        val url: String = arguments.toString()

        textCrawler.makePreview(linkPreviewCallback, url)
    }

    override fun onCancel(p0: Any?) {

    }

}
