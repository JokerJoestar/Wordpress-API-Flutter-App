# wp_flutter_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Known Bugs
- Black screen when app is on background (not on all devices)... flutter has this problem for some reason (admob shows tho, cause its internally android view), no available fix https://www.reddit.com/r/Flutter/comments/fztzj7/apps_turn_black_in_android_app_switcher/
- When you open 2 notifcations and close the last article, ad mob closes cause it gets disposed (Ads.hideBannerAd()). Tried to use navigator stack to find out the type of widgets before the last article, but flutter doesn't have a variable to get stack elements. (bypassed by not showing ad on article view coming from notification)
