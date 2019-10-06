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


private const val STATE = "state"
private const val STATE_LOADING = "loading"
private const val STATE_SUCCESS = "success"
private const val STATE_ERROR = "error"

private const val FIELD_TITLE = "title"
private const val FIELD_DESC = "description"
private const val FIELD_URL = "url"
private const val FIELD_ROW = "row"
private const val FIELD_HTML_CODE = "html_code"
private const val FIELD_FINAL_URL = "final_url"
private const val FIELD_CANNONICAL_URL = "cannonical_url"
private const val FIELD_IMAGE = "image"

private const val ERROR_TYPE = "Link preview error"

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

        val data = mutableMapOf<String, String>()

        val textCrawler = TextCrawler()

        val linkPreviewCallback = object : LinkPreviewCallback {
            override fun onPre() {
                data[STATE] = STATE_LOADING
                event.success(data)
            }

            override fun onPos(sourceContent: SourceContent, b: Boolean) {
                if (sourceContent.isSuccess) {
                    data[STATE] = STATE_SUCCESS
                    data[FIELD_TITLE] = sourceContent.title
                    data[FIELD_DESC] = sourceContent.description
                    data[FIELD_IMAGE] = sourceContent.images[0]
                    data[FIELD_URL] = sourceContent.url
                    data[FIELD_FINAL_URL] = sourceContent.finalUrl
                    data[FIELD_CANNONICAL_URL] = sourceContent.cannonicalUrl
                    data[FIELD_ROW] = sourceContent.raw

                    event.success(data)
                    event.endOfStream()
                } else {
                    event.error(ERROR_TYPE, "Parsing URL error. Check your URL for typos and/or your connection", "")
                    event.endOfStream()
                }
            }
        }

        val url: String? = arguments.toString()

        if (url.isNullOrBlank()) event.error(ERROR_TYPE, "URL is blank", "")

        textCrawler.makePreview(linkPreviewCallback, url)
    }

    override fun onCancel(p0: Any?) {

    }
}
