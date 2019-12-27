package com.n1k3c.link_preview

import com.leocardz.link.preview.library.LinkPreviewCallback
import com.leocardz.link.preview.library.SourceContent
import com.leocardz.link.preview.library.TextCrawler
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


private const val STATE = "state"
private const val STATE_SUCCESS = "success"
private const val STATE_PARSING_ERROR = "parsing_error"
private const val STATE_WRONG_URL = "wrong_url_error"

private const val FIELD_TITLE = "title"
private const val FIELD_DESC = "description"
private const val FIELD_URL = "url"
private const val FIELD_ROW = "row"
private const val FIELD_HTML_CODE = "html_code"
private const val FIELD_FINAL_URL = "final_url"
private const val FIELD_CANNONICAL_URL = "cannonical_url"
private const val FIELD_IMAGE = "image"

private const val ERROR_TYPE = "Link preview error"

class LinkPreviewPlugin : MethodCallHandler {

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "link_preview_channel")
            channel.setMethodCallHandler(LinkPreviewPlugin())
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method.equals("previewLink")) {
            val url: String? = call.argument("url")

            previewLink(url, result)
        } else {
            result.notImplemented()
        }
    }

    private fun previewLink(url: String?, result: Result) {
        val data = mutableMapOf<String, String>()

        val textCrawler = TextCrawler()

        val linkPreviewCallback = object : LinkPreviewCallback {
            override fun onPre() {}

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
                    data[FIELD_HTML_CODE] = sourceContent.htmlCode

                    result.success(data)
                } else {
                    data[STATE] = STATE_PARSING_ERROR
                    result.success(data)
                }
            }
        }

        if (url.isNullOrBlank()) {
            data[STATE] = STATE_WRONG_URL
            result.success(data)
        }

        textCrawler.makePreview(linkPreviewCallback, url)
    }
}
