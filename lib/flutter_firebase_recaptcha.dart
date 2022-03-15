library flutter_firebase_recaptcha;

import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class FirebaseRecaptcha extends StatelessWidget {
  Map<String, String> firebaseConfig;
  String firebaseVersion;
  bool appVerificationDisabledForTesting;
  String? languageCode;
  Function? onLoad;
  Function? onError;
  Function(String token) onVerify;
  Function? onFullChallenge;
  bool invisible;

  final InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(javaScriptEnabled: true),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
  );

  FirebaseRecaptcha({
    required this.firebaseConfig,
    this.firebaseVersion = '8.0.0',
    this.appVerificationDisabledForTesting = false,
    this.languageCode,
    this.onLoad,
    this.onError,
    required this.onVerify,
    this.onFullChallenge,
    this.invisible = false,
  });

  String? get authDomain {
    return firebaseConfig['authDomain'];
  }

  String get html {
    return """
<!DOCTYPE html><html>
<head>
  <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="HandheldFriendly" content="true">
  <script src="https://www.gstatic.com/firebasejs/${firebaseVersion}/firebase-app.js"></script>
  <script src="https://www.gstatic.com/firebasejs/${firebaseVersion}/firebase-auth.js"></script>
  <script type="text/javascript">firebase.initializeApp(${jsonEncode(firebaseConfig)});</script>
  <style>
    html, body {
      height: 100%;
      ${invisible ? 'padding: 0; margin: 0;' : ''}
    }
    #recaptcha-btn {
      width: 100%;
      height: 100%;
      padding: 0;
      margin: 0;
      border: 0;
      user-select: none;
      -webkit-user-select: none;
    }
  </style>
</head>
<body>
  ${invisible ? '<button id="recaptcha-btn" type="button" onclick="onClickButton()">Confirm reCAPTCHA</button>' : '<div id="recaptcha-cont" class="g-recaptcha"></div>'}
  <script>
    var fullChallengeTimer;
    function onVerify(token) {
      if (fullChallengeTimer) {
        clearInterval(fullChallengeTimer);
        fullChallengeTimer = undefined;
      }
      window.flutter_inappwebview.callHandler('verifyHandler', token);
    }
    function onLoad() {
      window.flutter_inappwebview.callHandler('loadHandler');
      firebase.auth().settings.appVerificationDisabledForTesting = ${appVerificationDisabledForTesting};
      ${languageCode != null ? 'firebase.auth().languageCode = \'${languageCode}\';' : ''}
      window.recaptchaVerifier = new firebase.auth.RecaptchaVerifier("${invisible ? 'recaptcha-btn' : 'recaptcha-cont'}", {
        size: "${invisible ? 'invisible' : 'normal'}",
        callback: onVerify
      });
      window.recaptchaVerifier.render();
    }
    function onError() {
      window.flutter_inappwebview.callHandler('errorHandler');
    }
    function onClickButton() {
      if (!fullChallengeTimer) {
        fullChallengeTimer = setInterval(function() {
          var iframes = document.getElementsByTagName("iframe");
          var isFullChallenge = false;
          for (i = 0; i < iframes.length; i++) {
            var parentWindow = iframes[i].parentNode ? iframes[i].parentNode.parentNode : undefined;
            var isHidden = parentWindow && parentWindow.style.opacity == 0;
            isFullChallenge = isFullChallenge || (
              !isHidden && 
              ((iframes[i].title === 'recaptcha challenge') ||
               (iframes[i].src.indexOf('google.com/recaptcha/api2/bframe') >= 0)));
          }
          if (isFullChallenge) {
            clearInterval(fullChallengeTimer);
            fullChallengeTimer = undefined;
            window.flutter_inappwebview.callHandler('fullChallengeHandler');
          }
        }, 100);
      }
    }
    ${invisible ? """
    window.addEventListener('message', function(event) {
      if (event.data === 'recaptcha-setup')
      {
        document.getElementById('recaptcha-btn').click();
      }
    });""" : ''}
  </script>
  <script src="https://www.google.com/recaptcha/api.js?onload=onLoad&render=explicit&hl=${languageCode ?? ''}" onerror="onError()"></script>
</body></html>""";
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialData: InAppWebViewInitialData(
        baseUrl: Uri.tryParse("https://${authDomain}"),
        data: html,
      ),
      initialOptions: options,
      onWebViewCreated: (controller) {
        controller.addJavaScriptHandler(
            handlerName: 'verifyHandler',
            callback: (args) => onVerify(args[0]));
        controller.addJavaScriptHandler(
            handlerName: 'loadHandler',
            callback: (args) {
              if (onLoad != null) {
                onLoad!();
              }
            });
        controller.addJavaScriptHandler(
            handlerName: 'errorHandler',
            callback: (args) {
              if (onError != null) {
                onError!();
              }
            });
        controller.addJavaScriptHandler(
            handlerName: 'fullChallengeHandler',
            callback: (args) {
              if (onFullChallenge != null) {
                onFullChallenge!();
              }
            });
      },
    );
  }
}
