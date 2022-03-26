import 'package:flutter/material.dart';

import 'firebase_recaptcha.dart';

class FirebaseRecaptchaVerifierModal extends StatefulWidget {
  Map<String, String> firebaseConfig;
  String firebaseVersion;
  bool appVerificationDisabledForTesting;
  String? languageCode;
  Function? onLoad;
  Function? onError;
  Function(String token) onVerify;
  Function? onFullChallenge;
  bool attemptInvisibleVerification;

  FirebaseRecaptchaVerifierModal({
    required this.firebaseConfig,
    this.firebaseVersion = '8.0.0',
    this.appVerificationDisabledForTesting = false,
    this.languageCode,
    this.onLoad,
    this.onError,
    required this.onVerify,
    this.onFullChallenge,
    this.attemptInvisibleVerification = false,
  });

  @override
  State<FirebaseRecaptchaVerifierModal> createState() =>
      _FirebaseRecaptchaVerifierModalState(attemptInvisibleVerification);
}

class _FirebaseRecaptchaVerifierModalState
    extends State<FirebaseRecaptchaVerifierModal> {
  bool attemptInvisibleVerification;

  _FirebaseRecaptchaVerifierModalState(this.attemptInvisibleVerification);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: attemptInvisibleVerification ? 0 : 1,
      child: FirebaseRecaptcha(
        firebaseConfig: widget.firebaseConfig,
        firebaseVersion: widget.firebaseVersion,
        appVerificationDisabledForTesting:
            widget.appVerificationDisabledForTesting,
        languageCode: widget.languageCode,
        onLoad: () {
          _resetAttemptInvisibleVerification();
          widget.onLoad?.call();
        },
        onError: () {
          _resetAttemptInvisibleVerification();
          widget.onError?.call();
        },
        onVerify: (token) {
          _resetAttemptInvisibleVerification();
          widget.onVerify.call(token);
        },
        onFullChallenge: () {
          if (attemptInvisibleVerification) {
            setState(() {
              attemptInvisibleVerification = false;
            });
          }
          widget.onFullChallenge?.call();
        },
        invisible: attemptInvisibleVerification,
      ),
    );
  }

  void _resetAttemptInvisibleVerification() {
    if (widget.attemptInvisibleVerification != attemptInvisibleVerification) {
      setState(() {
        attemptInvisibleVerification = widget.attemptInvisibleVerification;
      });
    }
  }
}
