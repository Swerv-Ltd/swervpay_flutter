import 'package:flutter/material.dart';
import 'package:swervpay_widget/swervpay_widget.dart';

class SwervpayWidget {
  static Future launchWidget(BuildContext ctx,
      {String? key,
      bool sandbox = false,
      bool debugMode = false,
      String? businessId,
      SwervpayCheckoutScope scope = SwervpayCheckoutScope.deposit,
      SwervpayCheckoutDataModel? data,
      String? checkoutId,
      void Function(SwervpayCheckoutResponseModel response)? onSuccess,
      VoidCallback? onClose,
      VoidCallback? onLoad,
      ValueChanged<String>? onEvent}) async {
    // Launch the Swervpay widget

    return showDialog(
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(ctx).size.width * .9,
              height: MediaQuery.of(ctx).size.height * .8,
              child: SwervpayView(
                publicKey: key,
                scope: scope,
                data: data,
                sandbox: sandbox,
                onEvent: onEvent,
                debugMode: debugMode,
                businessId: businessId,
                checkoutId: checkoutId,
                onSuccess: onSuccess,
                onClose: onClose,
                onLoad: onLoad,
              ),
            ),
          ),
        ],
      ),
      context: ctx,
    );
  }
}
