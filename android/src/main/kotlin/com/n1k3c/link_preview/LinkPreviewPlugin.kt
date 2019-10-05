package com.n1k3c.link_preview

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import com.leocardz.link.preview.library.SourceContent
import com.leocardz.link.preview.library.LinkPreviewCallback
import com.leocardz.link.preview.library.TextCrawler


class LinkPreviewPlugin : MethodCallHandler {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "link_preview")
            channel.setMethodCallHandler(LinkPreviewPlugin())
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getPlatformVersion") {

            val textCrawler = TextCrawler()

            val linkPreviewCallback = object : LinkPreviewCallback {
                override fun onPre() {

                }

                override fun onPos(sourceContent: SourceContent, b: Boolean) {
                    result.success("Android ${android.os.Build.VERSION.RELEASE} - " + sourceContent.title)
                }
            }

            textCrawler.makePreview(linkPreviewCallback, "https://www.coolinarika.com/recept/1094861/")
        } else {
            result.notImplemented()
        }
    }
}
