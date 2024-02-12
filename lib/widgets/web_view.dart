import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:os_simulation/models/icons.dart';
import 'package:os_simulation/providers/desktop_provider.dart';
import 'package:provider/provider.dart';

class WebBrowserWindow extends StatefulWidget {
  final DesktopIcon icon;

  const WebBrowserWindow({Key? key, required this.icon}) : super(key: key);

  @override
  _WebBrowserWindowState createState() => _WebBrowserWindowState();
}

class _WebBrowserWindowState extends State<WebBrowserWindow> {
  bool isMaximized = false;
  bool isMinimized = false;
  Offset position = const Offset(100, 100);
  late InAppWebViewController webViewController;
  final TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final width = isMaximized ? screenWidth : 400;
    final height = isMaximized ? screenHeight : 500;

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Visibility(
        visible: !isMinimized,
        child: Material(
          elevation: 4,
          child: Container(
            width: width.toDouble(),
            height: height.toDouble(),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black.withOpacity(0.2),
                )
              ],
            ),
            child: Column(
              children: [
                GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      position = Offset(
                        position.dx + details.delta.dx,
                        position.dy + details.delta.dy,
                      );
                    });
                  },
                  child: Container(
                    color: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () async {
                            if (await webViewController.canGoBack()) {
                              webViewController.goBack();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () async {
                            if (await webViewController.canGoForward()) {
                              webViewController.goForward();
                            }
                          },
                        ),
                        Expanded(
                          child: TextField(
                            controller: urlController,
                            decoration: const InputDecoration(
                              hintText: 'URL',
                              border: InputBorder.none,
                            ),
                            onSubmitted: (url) {
                              webViewController.loadUrl(
                                  urlRequest: URLRequest(url: WebUri(url)));
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            webViewController.reload();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            isMaximized
                                ? Icons.crop_square_rounded
                                : Icons.close_fullscreen_rounded,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              isMaximized = !isMaximized;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () {
                            Provider.of<DesktopProvider>(context, listen: false)
                                .removeWindow(widget, widget.icon, context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InAppWebView(
                    initialUrlRequest:
                        URLRequest(url: WebUri("https://www.google.com")),
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      urlController.text = url.toString();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
