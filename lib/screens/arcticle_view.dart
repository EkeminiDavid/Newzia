import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleScreen extends StatefulWidget {
  static const id = 'article screen';

  const ArticleScreen({super.key, this.articleUrl});

  final String? articleUrl;

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  WebViewController? _controller;
  bool _isLoading = true;

  @override
  void initState() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
          },
          onProgress: (int progress) {
            const LinearProgressIndicator();
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.articleUrl!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/newzia_header_logo1.png'),
        elevation: 0.0,
      ),
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              WebViewWidget(
                controller: _controller!,
              ),
              Visibility(
                visible: _isLoading,
                child: const Center(child: CircularProgressIndicator()),
              )
            ],
          )),
    );
  }
}
