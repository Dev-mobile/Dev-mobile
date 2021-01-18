import 'package:animations/animations.dart';
import 'package:dev_mobile/config/palette.dart';
import 'package:dev_mobile/screens/auth/Sign_in.dart';
import 'package:dev_mobile/screens/auth/register.dart';
import 'package:dev_mobile/screens/background_painter.dart';
import 'package:dev_mobile/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';

class Authscreen extends StatefulWidget {
  const Authscreen({Key key}) : super(key: key);

  static MaterialPageRoute get route => MaterialPageRoute(
        builder: (context) => const Authscreen(),
      );

  @override
  _AuthscreenState createState() => _AuthscreenState();
}

class _AuthscreenState extends State<Authscreen>
    with SingleTickerProviderStateMixin {
  //animation controller with single.. for the vsync
  AnimationController _controller;

  ValueNotifier<bool> showSignInPage = ValueNotifier<bool>(true);

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
                2)); //initialize controller vsynch listen to when the frame changes (koulma tbedel katchoufe ou katdir update)
    super.initState();
  }

//rembre to dispose of the controller memory leaks bache n9tasdou
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LitAuth.custom(
        // buils costume auth form
        errorNotification: const NotificationConfig(
          backgroundColor: Palette.darkBlue,
          icon: Icon(
            Icons.error_outline,
            color: Colors.deepOrange,
            size: 32,
          ),
        ),
        onAuthSuccess: () {
          Navigator.of(context).pushReplacement(HomeScreen.route);
        },
        child: Stack(
          children: [
            SizedBox.expand(
              child: CustomPaint(
                painter: BackgroundPainter(
                  animation: _controller.view,
                ),
              ),
            ),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800),
                child: ValueListenableBuilder<bool>(
                  valueListenable: showSignInPage,
                  builder: (context, value, child) {
                    return PageTransitionSwitcher(
                      reverse: !value,
                      duration: Duration(milliseconds: 800),
                      transitionBuilder:
                          (child, animation, secondaryAnimation) {
                        return SharedAxisTransition(
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          transitionType: SharedAxisTransitionType.vertical,
                          fillColor: Colors.transparent,
                          child: child,
                        );
                      },
                      child: value
                          ? SignIn(
                              key: ValueKey('SignIn'),
                              onRegisterClicked: () {
                                context.resetSignInForm();
                                showSignInPage.value = false;
                                _controller.forward();
                              },
                            )
                          : Register(
                              key: const ValueKey('Register'),
                              onSignInPressed: () {
                                context.resetSignInForm();
                                showSignInPage.value = true;
                                _controller.reverse();
                              },
                            ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
