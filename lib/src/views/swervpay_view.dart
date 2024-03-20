import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swervpay_widget/src/const.dart';
import 'package:swervpay_widget/src/raw/swervpay_html.dart';
import 'package:swervpay_widget/swervpay_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SwervpayView extends StatefulWidget {
  const SwervpayView({
    this.checkoutId,
    this.businessId,
    this.data,
    this.publicKey,
    this.onClose,
    this.onLoad,
    this.onSuccess,
    this.scope = SwervpayCheckoutScope.deposit,
    super.key,
  });

  final String? publicKey;
  final String? businessId;
  final SwervpayCheckoutScope scope;
  final SwervpayCheckoutDataModel? data;
  final String? checkoutId;
  final void Function(SwervpayCheckoutResponseModel response)? onSuccess;
  final VoidCallback? onClose;
  final VoidCallback? onLoad;

  @override
  State<SwervpayView> createState() => _SwervpayViewState();
}

class _SwervpayViewState extends State<SwervpayView> {
  @override
  void initState() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        swervpayJavascriptInterface,
        onMessageReceived: (data) {
          print(swervpayJavascriptInterface);
          print('${(json.decode(data.message))}');

          handleResponse(data.message);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            print(progress);
          },
          onPageStarted: (String url) {
            isLoading = true;
          },
          onPageFinished: (String url) {
            isLoading = false;
          },
          onWebResourceError: (WebResourceError error) {
            print(error.description);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.toLowerCase().contains('swervpay')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      // ..loadRequest(Uri.parse('https://swyftpay.io'));
      ..loadRequest(
        Uri.dataFromString(
          buildWidgetHtml(widget.publicKey, widget.businessId,
              widget.checkoutId, widget.scope, widget.data),
          mimeType: 'text/html',
        ),
      );

    setState(() {});

    super.initState();
  }

  WebViewController? _controller;

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    setState(() {});
  }

  bool _hasError = false;
  bool get hasError => _hasError;
  set hasError(bool val) {
    _hasError = val;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller == null
          ? const Center(child: CupertinoActivityIndicator())
          : WebViewWidget(
              controller: _controller!,
            ),
    );
  }

  /// parse event from javascript channel
  void handleResponse(String body) async {
    try {
      final Map<String, dynamic> bodyMap = json.decode(body);
      String? key = bodyMap['type'] as String?;
      if (key != null) {
        switch (key) {
          case 'onClose':
          case 'swervpay.widget.closed':
            if (mounted && widget.onClose != null) widget.onClose!();
            break;
          case 'onSuccess':
          case 'swervpay.widget.checkout_complete':
            var successModel = SwervpayCheckoutResponseModel.fromJson(body);
            if (mounted && widget.onSuccess != null) {
              widget.onSuccess!(successModel);
            }
            break;
          case 'onLoad':
            if (mounted && widget.onLoad != null) widget.onLoad!();
            break;
          default:
        }
      }
    } catch (e) {
      print('SwervpayClient, ${e.toString()}');
    }
  }

  // void _handleInit() async {
  //   SystemChannels.textInput.invokeMethod('TextInput.hide');
  //   if (Platform.isAndroid)
  //     WebViewController.platform = SurfaceAndroidWebView();
  // }
}
