import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swervpay_widget/swervpay_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Swervpay Widget Example'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (c) => SwervpayView(
                sandbox: true,
                publicKey: 'pk_dev_AZSvUkytFmpxTKEGkHgM',
                //  const String.fromEnvironment('SWERV_PUBLIC_KEY',
                //     defaultValue: 'pk_dev_123')

                businessId: 'bsn_Ni1B1z3dzMy4o7y2tVPw',
                // const String.fromEnvironment('SWERV_BUSINESS_ID',
                //     defaultValue: 'bsn_123'),
                //checkoutId: 'hbnbbbbbb',
                data: SwervpayCheckoutDataModel(
                  customer: SwervpayCustomerDataModel(
                      email: 'emmanuelolajubu90@gmail.com',
                      firstname: 'EMMANUEL',
                      lastname: 'OLAJUBU',
                      phoneNumber: '09034332785'),
                  reference: DateTime.now().toString(),
                  amount: 10000,
                  description: 'description',
                  currency: 'NGN',
                ),
                onSuccess: (response) {
                  Navigator.of(context).pop();
                  log('Example success works ${response.toString()}');
                },
                onClose: () {
                  Navigator.of(context).pop();
                  log('closed');
                },
                onLoad: () => log('loaded'),
              ),
            ),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), //
      body: Center(
        child: GestureDetector(
          onTap: () async {
            // Using showDialog
            await SwervpayWidget.launchWidget(
              context,
              sandbox: true,
              key: 'pk_dev_AZSvUkytFmpxTKEGkHgM',
              // key: const String.fromEnvironment('SWERV_PUBLIC_KEY',
              //     defaultValue: 'pk_dev_123'),
              businessId: 'bsn_Ni1B1z3dzMy4o7y2tVPw',
              // businessId: const String.fromEnvironment('SWERV_BUSINESS_ID',
              //     defaultValue: 'bsn_123'),
              //checkoutId: 'hbnbbbbbb',
              data: SwervpayCheckoutDataModel(
                customer: SwervpayCustomerDataModel(
                    email: 'emmanuelolajubu90@gmail.com',
                    firstname: 'EMMANUEL',
                    lastname: 'OLAJUBU',
                    phoneNumber: '09034332785'),
                reference: DateTime.now().toString(),
                amount: 100,
                description: 'description',
                currency: 'NGN',
              ),
              onSuccess: (response) {
                log(response.toString());
              },
              onClose: () => log('closed'),
              onLoad: () => log('loaded'),
            );
          },
          child: const Text('Open Swervpay Widget'),
        ),
      ),
    );
  }
}
