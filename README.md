# Flutter Firebase Recaptcha Widget

flutter_firebase_recaptcha provides a FirebaseRecaptcha widget for creating a reCAPTCHA verifier and using that with your Firebase Phone authentication workflow.

# flutter_firebase_recaptcha

reCAPTCHA widget for Firebase phone authentication 📱

# Installation

### Add the package to your pubspec.yaml file

```
flutter pub add flutter_inappwebview
```
# Basic usage

To get started, [read the official Firebase phone-auth guide and **ignore all steps** that cover the reCAPTCHA configuration.](https://firebase.google.com/docs/auth/web/phone-auth)

Instead of using the standard `firebase.auth.RecaptchaVerifier` class, we will be using our own verifier which creates a reCAPTCHA widget inside a web-browser.

Add the `FirebaseRecaptcha` widget to your app. Also pass in the Firebase web configuration using the `firebaseConfig` prop.

> 🚨 Optionally you can turn on **experimental invisible reCAPTCHA** using `invisible` prop. This feature is experimental and attempts to complete the verification process without showing any UI to the user. When invisible verification fails, the full reCATPCHA challenge UI is shown.

```dart
const firebaseConfig = {
    'apiKey': 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    'authDomain': 'XXXXXXXXXXXXXXXXXXXXXXXXXXX',
    'projectId': 'XXXXXXXXXXXXXXXXXXXXXXXXXXXX',
    'storageBucket': 'XXXXXXXXXXXXXXXXXXXXXXXX',
    'messagingSenderId': 'XXXXXXXXXXXXXXXXXXXX',
    'appId': 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',
};

FirebaseRecaptcha(
      firebaseConfig: firebaseConfig,
      invisible: true,
      onVerify: (token) => print('token: ' + token),
      onLoad: () => print('onLoad'),
      onError: () => print('onError'),
      onFullChallenge: () => print('onFullChallenge'),
    );
```
## API

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