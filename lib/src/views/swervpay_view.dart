import 'dart:convert';
import 'dart:developer';

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
    this.onError,
    this.sandbox = false,
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
  final ValueChanged<String>? onError;

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
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            isLoading = true;
            log('page started');
          },
          onPageFinished: (String url) {
            isLoading = false;
            log('page finished');

            setState(() {});
          },
          onWebResourceError: (WebResourceError error) {
            hasError = true;
            log('page error');
            setState(() {});
          },
          onNavigationRequest: (NavigationRequest request) {
            log('navigate request');
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

    // setState(() {});

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

//   void handleResponse(String body) async {
//     try {
//       final Map<String, dynamic> bodyMap = json.decode(body);
//       String? key = bodyMap['type'] as String?;
//       if (key != null) {
//         switch (key) {
//           case 'onClose':
//           case 'swervpay.widget.closed':
//             if (mounted && widget.onClose != null) widget.onClose!();
//             break;
//           case 'onSuccess':
//           case 'swervpay.widget.checkout_complete':
//             var successModel = SwervpayCheckoutResponseModel.fromJson(body);
//             if (mounted && widget.onSuccess != null) {
//               widget.onSuccess!(successModel);
//             }
//             break;
//           case 'onLoad':
//             if (mounted && widget.onLoad != null) widget.onLoad!();
//             break;
//           default:
//         }
//       }
//     } catch (e) {
//       if (mounted && widget.onError != null) {
//         widget.onError!('SwervpayClient, ${e.toString()}');
//       }
//     }
//   }
//  onSuccess: function (response) {
//                  sendMessage({ type: "onSuccess", data: response})
//               },
// }

  void handleResponse(String body) async {
    log('Received raw message: $body');
    try {
      final Map<String, dynamic> bodyMap = json.decode(body);

      String? messageType = bodyMap['type'] as String?;
      log('This is the message Type: ${messageType.toString()}');

      if (messageType != null) {
        switch (messageType) {
          case 'onClose':
          case 'swervpay.widget.closed':
            if (mounted && widget.onClose != null) {
              widget.onClose!();
              break;
            }
          // break;
          case 'onSuccess':
          case 'swervpay.widget.checkout_complete':
            SwervpayCheckoutResponseModel successModel =
                SwervpayCheckoutResponseModel.fromJson(body);
            if (mounted && widget.onSuccess != null) {
              log('got here');
              widget.onSuccess!(successModel);
            }
            break;
          case 'onLoad':
            if (mounted && widget.onLoad != null) {
              widget.onLoad!();
            }
            break;
          default:
            if (mounted && widget.onError != null) {
              widget.onError!('Unexpected message type received: $messageType');
            }
            break;
        }
      } else {
        if (mounted && widget.onError != null) {
          widget.onError!('Received null message type from the WebView');
        }
      }
    } catch (e) {
      if (mounted && widget.onError != null) {
        widget
            .onError!('Error processing message from WebView: ${e.toString()}');
      }
    }
  }
}

// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:swervpay_widget/src/raw/swervpay_html.dart';
// import 'package:swervpay_widget/swervpay_widget.dart';

// class SwervpayView extends StatefulWidget {
//   const SwervpayView({
//     this.checkoutId,
//     this.businessId,
//     this.data,
//     this.publicKey,
//     this.onClose,
//     this.onLoad,
//     this.onSuccess,
//     this.onError,
//     this.sandbox = false,
//     this.scope = SwervpayCheckoutScope.deposit,
//     super.key,
//   });

//   final String? publicKey;
//   final String? businessId;
//   final SwervpayCheckoutScope scope;
//   final SwervpayCheckoutDataModel? data;
//   final String? checkoutId;
//   final bool sandbox;
//   final void Function(SwervpayCheckoutResponseModel response)? onSuccess;
//   final VoidCallback? onClose;
//   final VoidCallback? onLoad;
//   final ValueChanged<String>? onError;

//   @override
//   State<SwervpayView> createState() => _SwervpayViewState();
// }

// class _SwervpayViewState extends State<SwervpayView> {
//   late InAppWebViewController webViewController;
//   bool _isLoading = true;
//   bool _hasError = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: true,
//       child: Scaffold(
//         appBar: AppBar(title: const Text("Payment")),
//         body: SafeArea(
//           child: Stack(
//             children: [
//               InAppWebView(
//                 initialData: InAppWebViewInitialData(
//                   data: buildWidgetHtml(
//                     widget.publicKey,
//                     widget.businessId,
//                     widget.checkoutId,
//                     widget.scope,
//                     widget.data,
//                     widget.sandbox,
//                   ),
//                 ),
//                 initialSettings: InAppWebViewSettings(
//                   isTextInteractionEnabled: true,
//                   javaScriptEnabled: true,
//                   javaScriptCanOpenWindowsAutomatically: true,
//                   supportZoom: false,
//                   mediaPlaybackRequiresUserGesture: false,
//                   useHybridComposition: true,
//                 ),
//                 onWebViewCreated: (controller) {
//                   webViewController = controller;
//                   // controller.addJavaScriptHandler(
//                   //     handlerName: 'copyText',
//                   //     callback: (args) {
//                   //       Clipboard.setData(ClipboardData(text: args[0]));
//                   //       // Optionally, show a toast or feedback that the text has been copied
//                   //     });
//                 },
//                 onLoadStart: (controller, url) {
//                   setState(() {
//                     _isLoading = true;
//                   });
//                 },
//                 onLoadStop: (controller, url) {
//                   setState(() {
//                     _isLoading = false;
//                   });
//                 },
//                 onConsoleMessage: (controller, consoleMessage) {
//                   log("Console message: ${consoleMessage.message}");
//                 },
//                 onJsAlert: (controller, jsAlertRequest) async {
//                   return JsAlertResponse(handledByClient: true);
//                 },
//                 onLoadError: (controller, url, code, message) {
//                   setState(() {
//                     _hasError = true;
//                   });
//                 },
//                 onJsConfirm: (controller, jsConfirmRequest) async {
//                   return JsConfirmResponse(
//                       handledByClient: true, confirmButtonTitle: "OK");
//                 },
//                 onJsPrompt: (controller, jsPromptRequest) async {
//                   return JsPromptResponse(
//                       handledByClient: true, value: "Result");
//                 },
//               ),
//               if (_isLoading) const Center(child: CircularProgressIndicator()),
//               if (_hasError)
//                 const Center(
//                   child: Text(
//                     "Error loading payment page",
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
