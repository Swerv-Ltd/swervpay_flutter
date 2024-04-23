import 'dart:convert';

import 'package:swervpay_widget/swervpay_widget.dart';

String buildWidgetHtml(String? key, String? businessId, String? checkoutId,
        [SwervpayCheckoutScope scope = SwervpayCheckoutScope.deposit,
        SwervpayCheckoutDataModel? data,
        bool sandbox = false]) =>
    '''
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swervpay Widget</title>
</head>

<body onload="setupSwervCheckoutWidget()" style="background-color:#fff;height:100vh;overflow: scroll;">
    <script type="text/javascript" src="https://cdn.swervpay.co/v1/widget.js"></script>
    <script type="text/javascript">
        window.onload = setupSwervCheckoutWidget;
        function setupSwervCheckoutWidget() {

            const data = JSON.parse(`${jsonEncode({...?data?.toMap()})}`)

            let checkoutId = undefined;
            let tempCheckoutId = "${checkoutId ?? ""}";
            let sandbox = $sandbox;

            if (tempCheckoutId !== "") {
                checkoutId = tempCheckoutId;
            }
            
            var config = {
              checkoutId: checkoutId,
              key: "$key",
              sandbox: sandbox,
              businessId: "$businessId",
              scope: "${scope.name}",
              data: data,
              onSuccess: function (response) {
                 sendMessage({ type: "onSuccess", data: response})
              },
              onClose: function () {
                sendMessage({ type: "onClose" })
              },
            };

            const checkout = new Swervpay.Checkout(config);
            checkout.setup();
            checkout.open();
            function sendMessage(message) {
              if (window.SwervpayJavascriptInterface && window.SwervpayJavascriptInterface.postMessage) {
                  window.SwervpayJavascriptInterface.postMessage(JSON.stringify(message));
              }
            } 
        }
    </script>
</body>

</html>
''';
