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
                debugMode: true,
                publicKey: const String.fromEnvironment('SWERV_PUBLIC_KEY',
                    defaultValue: 'pk_dev_123'),
                businessId: const String.fromEnvironment('SWERV_BUSINESS_ID',
                    defaultValue: 'bsn_123'),
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
                onEvent: (value) => print(value),
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
              debugMode: true,
              key: const String.fromEnvironment('SWERV_PUBLIC_KEY',
                  defaultValue: 'pk_dev_123'),
              businessId: const String.fromEnvironment('SWERV_BUSINESS_ID',
                  defaultValue: 'bsn_123'),
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
              onEvent: (value) => print(value),
            );
          },
          child: const Text('Open Swervpay Widget'),
        ),
      ),
    );
  }
}
