
import 'package:UPEI_NEWSAPP/news/model/fetcher/internet_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


// ConnectionAlert widget to display an alert when there's no internet connection
class ConnectionAlert extends StatelessWidget {
  const ConnectionAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetConnectivityProvider>(
      builder: (context, internetProvider, _) {
        // Check if the device is connected to the internet
        if (internetProvider.isConnected) {
          return SizedBox(); // Return an empty SizedBox if connected
        } else {
          // Display a Scaffold with an offline message if not connected
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.signal_wifi_off, size: 100), // Offline Wi-Fi icon
                  SizedBox(height: 20),
                  Text(
                    'Looks like you\'re offline Check out your offline reads', // Offline message
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10), // Spacer
                  // Additional widgets can be added here for further customization
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
