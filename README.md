<div align="center">
  <a href="https://swervpay.co" target="_blank">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://avatars.githubusercontent.com/u/108650375?s=200&v=4">
    <img src="https://avatars.githubusercontent.com/u/108650375?s=200&v=4" width="60" alt="Logo"/>
  </picture>
  </a>
</div>

<h1 align="center">Flutter Widget for Swervpay</h1>

[![pub package][pub_badge]][pub_badge_link]
[![License: MIT][license_badge]][license_badge_link]

<p align="center">
    <br />
    <a href="https://docs.swervpay.co" rel="dofollow"><strong>Explore the docs »</strong></a>
    <br />
 </p>
  
<p align="center">  
    <a href="https://twitter.com/swyftpay_io">X (Twitter)</a>
    ·
    <a href="https://www.linkedin.com/company/swervltd">Linkedin</a>
    ·
    <a href="https://docs.swervpay.co/changelog">Changelog</a>
</p>

# Installation

```bash
$ flutter pub add swervpay_widget
```

# Configuration

Create a new instance of Swervpay with your secret_key and business_id:

```dart
import "package:swervpay_widget/swervpay_widget.dart";

Navigator.of(context).push(
    CupertinoPageRoute(
        builder: (c) => SwervpayView(
            sandbox: true,
            publicKey: const String.fromEnvironment('SWERV_PUBLIC_KEY', defaultValue: 'pk_dev_123'),
            businessId: const String.fromEnvironment('SWERV_BUSINESS_ID', defaultValue: 'bsn_123'),
            //checkoutId: 'hbnbbbbbb',
            data: SwervpayCheckoutDataModel(
                reference: DateTime.now().toString(),
                amount: 10000,
                description: 'description',
                currency: 'NGN',
            ),
            onSuccess: (response) {
                print(response);
            },
            onClose: () => print('closed'),
            onLoad: () => print('loaded'),
        ),
    ),
);


// OR

await SwervpayWidget.launchWidget(
    context,
    sandbox: true,
    key: const String.fromEnvironment('SWERV_PUBLIC_KEY', defaultValue: 'pk_dev_123'),
    businessId: const String.fromEnvironment('SWERV_BUSINESS_ID', defaultValue: 'bsn_123'),
    //checkoutId: 'hbnbbbbbb',
    data: SwervpayCheckoutDataModel(
        reference: DateTime.now().toString(),
        amount: 100,
        description: 'description',
        currency: 'NGN',
    ),
    onSuccess: (response) {
        print(response);
    },
    onClose: () => print('closed'),
    onLoad: () => print('loaded'),
);
```

Replace <SWERV_PUBLIC_KEY> and <SWERV_BUSINESS_ID> with your actual secret key and business ID.

## Documentation

See [docs for widget here][doc_link]

[pub_badge]: https://img.shields.io/pub/v/swervpay_widget.svg
[pub_badge_link]: https://pub.dartlang.org/packages/swervpay_widget
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_badge_link]: https://opensource.org/licenses/MIT
[doc_link]: https://docs.swervpay.co/sdks/widget
