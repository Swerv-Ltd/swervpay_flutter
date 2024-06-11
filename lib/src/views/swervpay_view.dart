import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    this.onEvent,
    this.sandbox = false,
    this.debugMode = false,
    this.scope = SwervpayCheckoutScope.deposit,
    super.key,
  });

  final String? publicKey;
  final String? businessId;
  final SwervpayCheckoutScope scope;
  final SwervpayCheckoutDataModel? data;
  final String? checkoutId;
  final bool sandbox;
  final void Function(SwervpayCheckoutResponseModel response)? onSuccess;
  final VoidCallback? onClose;
  final VoidCallback? onLoad;

  final ValueChanged<String>? onEvent;
  final bool debugMode;

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
          handleResponse(data.message);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            isLoading = true;
          },
          onPageFinished: (String url) {
            isLoading = false;
          },
          onWebResourceError: (WebResourceError error) {
            hasError = true;
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString(
        buildWidgetHtml(
          widget.publicKey,
          widget.businessId,
          widget.checkoutId,
          widget.scope,
          widget.data,
          widget.sandbox,
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
    return PopScope(
      canPop: true,
      child: Material(
        child: GestureDetector(
          onTap: () {
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          },
          child: SafeArea(
            child: Stack(
              children: [
                if (_controller == null || isLoading == true)
                  const Center(child: CupertinoActivityIndicator())
                else
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent)),
                    child: WebViewWidget(
                      controller: _controller!,
                      gestureRecognizers:
                          <Factory<OneSequenceGestureRecognizer>>{}..add(
                              Factory<TapGestureRecognizer>(
                                () => TapGestureRecognizer()
                                  ..onTapDown = (tap) {
                                    SystemChannels.textInput
                                        .invokeMethod('TextInput.hide');
                                  },
                              ),
                            ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleResponse(String body) async {
    try {
      final Map<String, dynamic> bodyMap = json.decode(body);
      if (widget.debugMode) {
        // ignore: avoid_print
        print('SwervpayWidget: $bodyMap');
      }
      String? key = bodyMap['type'] as String?;
      if (key != null) {
        switch (key) {
          case 'onClose':
            if (mounted && widget.onClose != null) widget.onClose!();
            break;
          case 'onSuccess':
            var successModel = SwervpayCheckoutResponseModel.fromJson(body);
            if (mounted && widget.onSuccess != null) {
              widget.onSuccess!(successModel);
            }
            break;
          case 'onLoad':
            if (mounted && widget.onLoad != null) widget.onLoad!();
            break;
          case 'onEvent':
            if (mounted && widget.onLoad != null) widget.onEvent!(body);
            break;
          default:
        }
      }
    } catch (e) {
      if (mounted && widget.onEvent != null) {
        widget.onEvent!('SwervpayClientException, ${e.toString()}');
      }
    }
  }
}
