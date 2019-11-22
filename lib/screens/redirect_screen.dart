import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuttler/providers/auth_state.dart';

/// This screen decides which route to go to when launch the app
class RedirectScreen extends StatefulWidget {
  const RedirectScreen({Key key}) : super(key: key);

  @override
  _RedirectScreenState createState() => _RedirectScreenState();
}

class _RedirectScreenState extends State<RedirectScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  /// Navigate to appropriate route
  _navigate() async {
    final authState = Provider.of<AuthState>(context, listen: false);

    if (await authState.isSignedInAsDriver()) {
      Navigator.pushNamedAndRemoveUntil(context, '/driver', (route) => false);
      return;
    } else if (await authState.isSignedIn()) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white);
  }
}
