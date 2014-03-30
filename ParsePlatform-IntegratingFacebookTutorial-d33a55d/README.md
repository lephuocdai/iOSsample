# Integrating Facebook Tutorial

## iOS Setup

The Xcode project teaches you how to create a Facebook profile viewer application using the Parse framework.

### How to Run

1. Clone the repository and open the Xcode project at `IntegratingFacebookTutorial-iOS/IntegratingFacebookTutorial.xcodeproj`.
2. Add your Parse application id and client key in `AppDelegate.m`
3. Set your Facebook application id as a URLType Project > Info > URL Types > Untitled > URL Schemes using the format fbYour_App_id (ex. for 12345, enter fb12345)
4. Set your Facebook application id in the `FacebookAppID` property in `IntegratingFacebookTutorial-Info.plist`.

### Learn More

To learn more, take a look at the [Integrating Facebook in iOS](https://www.parse.com/tutorials/integrating-facebook-in-ios) tutorial.

## Android Setup

The Android project teaches you how to create a Facebook profile viewer application using the Parse framework.

1. Clone the repository and import the Facebook SDK and sample project by navigating to the `IntegratingFacebookTutorial` folder and selecting the `facebook` and `IntegratingFacebookTutorial-Android` projects.
2. Add your Parse application id and client key in `IntegratingFacebookTutorialApplication.java`.
3. Add your Facebook application id in `strings.xml`

### Learn More

To learn more, take a look at the [Integrating Facebook in Android](https://www.parse.com/tutorials/integrating-facebook-in-android) tutorial.
