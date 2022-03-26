# Flutter Firebase Recaptcha Widget

**`flutter_firebase_recaptcha`** provides a set of building blocks for creating a reCAPTCHA verifier and using that with your Firebase Phone authentication workflow.

> Firebase phone authentication is not possible out of the box using the Firebase JS SDK. This because an Application Verifier object (reCAPTCHA) is needed as an additional security measure to verify that the user is real and not a bot.

# Installation

### Add the package to your pubspec.yaml file

```
flutter pub add flutter_firebase_recaptcha
```

# Basic usage

To get started, [read the official Firebase phone-auth guide and **ignore all steps** that cover the reCAPTCHA configuration.](https://firebase.google.com/docs/auth/web/phone-auth)

Instead of using the standard `firebase.auth.RecaptchaVerifier` class, we will be using our own verifier which creates a reCAPTCHA widget inside a web-browser.

Add the `FirebaseRecaptchaVerifierModal` widget to your App and pass in the Firebase web configuration using the `firebaseConfig` prop.

> 🚨 Optionally you can turn on **experimental invisible reCAPTCHA** using `attemptInvisibleVerification` prop. This feature is experimental and attempts to complete the verification process without showing any UI to the user. When invisible verification fails, the full reCATPCHA challenge UI is shown.

```dart
const firebaseConfig = {
    'apiKey': 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    'authDomain': 'XXXXXXXXXXXXXXXXXXXXXXXXXXX',
    'projectId': 'XXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    'storageBucket': 'XXXXXXXXXXXXXXXXXXXXXXXX',
    'messagingSenderId': 'XXXXXXXXXXXXXXXXXXXX',
    'appId': 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
};

FirebaseRecaptchaVerifierModal(
      firebaseConfig: firebaseConfig,
      onVerify: (token) => print('token: ' + token),
      onLoad: () => print('onLoad'),
      onError: () => print('onError'),
      onFullChallenge: () => print('onFullChallenge'),
      attemptInvisibleVerification: true,
    );
```
## API

```dart
import 'package:flutter_firebase_recaptcha/flutter_firebase_recaptcha.dart';
```

### `FirebaseRecaptchaVerifierModal`

Modal screen that is automatically shown and displays a reCAPTCHA widget.

#### Props

- **firebaseConfig (IFirebaseOptions)** -- Firebase web configuration.
- **firebaseVersion (string)** -- Optional version of the Firebase JavaScript SDK to load in the web-view. You can use this to load a custom or newer version. For example `version="7.9.0"`.
- **attemptInvisibleVerification (boolean)** -- Attempts to verify without showing the reCAPTCHA workflow. The default is `false`. (Google terms apply - use `FirebaseRecaptchaBanner` to show te Google terms & policy).
- **appVerificationDisabledForTesting (boolean)** -- When set, disables app verification for the purpose of testing phone authentication. When this prop is `true`, a mock reCAPTCHA is rendered. This is useful for manual testing during development or for automated integration tests. See [Firebase Phone Auth](https://firebase.google.com/docs/auth/web/phone-auth#integration-testing) for more info.
- **languageCode (string)** -- Language to display the reCAPTCHA challenge in. For a list of possible languages, see [reCAPTCHA Language Codes](https://developers.google.com/recaptcha/docs/language).

### `FirebaseRecaptcha`

The reCAPTCHA v3 widget displayed inside a web-view.

#### Props

- **firebaseConfig (Map<String, String>)** -- Firebase web configuration.
- **firebaseVersion (string)** -- Optional version of the Firebase JavaScript SDK to load in the web-view. You can use this to load a custom or newer version. For example `firebaseVersion: '7.9.0',`.
- **appVerificationDisabledForTesting (boolean)** -- When set, disables app verification for the purpose of testing phone authentication. When this prop is `true`, a mock reCAPTCHA is rendered. This is useful for manual testing during development or for automated integration tests. See [Firebase Phone Auth](https://firebase.google.com/docs/auth/web/phone-auth#integration-testing) for more info.
- **languageCode (string)** -- Language to display the reCAPTCHA challenge in. For a list of possible languages, see [reCAPTCHA Language Codes](https://developers.google.com/recaptcha/docs/language).
- **onLoad (function)** -- A callback that is invoked when the widget has been loaded.
- **onError (function)** -- A callback that is invoked when the widget failed to load.
- **onVerify (function)** -- A callback that is invoked when reCAPTCHA has verified that the user is not a bot. The callback is provided with the reCAPTCHA token string. Example `onVerify: (token) => setState(() { _token = token; }),`.
- **onFullChallenge (function)** -- A callback that is invoked when reCAPTCHA shows the full challenge experience.
- **invisible (boolean)** -- When `true` renders an `invisible` reCAPTCHA widget. The widget can then be triggered to verify invisibly by setting the `verify` prop to `true`.
