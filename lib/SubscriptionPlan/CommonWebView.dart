import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonWebView extends StatefulWidget {
  final String url;
  final String title;
  const CommonWebView({Key? key,required this.url, required this.title    }) : super(key: key);

  @override
  State<CommonWebView> createState() => _CommonWebViewState();
}

class _CommonWebViewState extends State<CommonWebView> {
  WebViewController? _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: WebView(
          zoomEnabled: true ,
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController){
            _controller = webViewController;
          },
        )
    );
  }
}
