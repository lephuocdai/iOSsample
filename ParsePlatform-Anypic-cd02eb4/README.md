# Anypic

Anypic is the easiest way to share photos with your friends. Get the app and share your fun photos with the world. [Anypic](https://anypic.org) is fully powered by [Parse](https://parse.com). 

You can get the [source code](https://github.com/ParsePlatform/Anypic) and create your own Anypic with this [tutorial](https://parse.com/tutorials/anypic).


## iOS Setup

Anypic requires Xcode 4.5+. It runs on iOS 5.0 and newer. The [tutorial](https://parse.com/tutorials/anypic) provides additional setup instructions.

#### Setting up your Xcode project

1. Open the Xcode project at `Anypic-iOS/Anypic.xcodeproj`.

2. Create your Anypic App on [Parse](https://parse.com/apps).

3. Copy your new app's application id and client key into `AppDelegate.m`:

```objective-c
[Parse setApplicationId:@"APPLICATION_ID" clientKey:@"CLIENT_KEY];"
```

#### Configuring Anypic's Facebook integration

1. Set up a Facebook app at http://developers.facebook.com/apps

2. Set up a URL scheme for fbFACEBOOK_APP_ID, where FACEBOOK_APP_ID is your Facebook app's id. 

3. Add your Facebook app id to `Info.plist` in the `FacebookAppId` key.

## Web Setup 

The main Anypic site is at Anypic-web/index.html. The site will show the last eight photos uploaded to your Anypic app by default. You can click any of these photos to display a bigger version.


#### Parse JavaScript SDK

Anypic is built on top of the [Parse JavaScript SDK](https://parse.com/docs/js_guide). The main JavaScript file is at `Anypic-web/js/anypic.js`.

To get started, copy your app's id and JavaScript key into `anypic.js`:

```javascript
Parse.initialize("APPLICATION_ID", "JAVASCRIPT_KEY");
```

You'll notice that there is only one index.html, however Anypic's website displays different content for the homepage and for a single photo's landing page. This is accomplished using [Backbone.js](http://backbonejs.org/)'s `Backbone.Router`. The following lines set up the two routes:

```javascript
routes: {
  "pic/:object_id": "getPic",
  "*actions": "defaultRoute"
}
``` 

Whenever `/#pic/<object_id>` is visited, the Router will call the `getPic` function and pass along the object id for the photo that should be presented. The `getPic` function loads the photo landing page into the DOM, then obtains the photo from Parse using `Parse.Query`.

Any other URL will call the defaultRoute function, which should load the homepage into the DOM.

#### CSS

Anypic uses [Sass](http://sass-lang.com/) and [Compass](http://compass-style.org/) to generate its CSS. You will find the main SCSS file at `sass/screen.scss`. To get started, run `compass watch` from the Anypic-web folder.

Any changes made to the `.scss` files in `sass/` will be picked up by Compass and used to generate the final CSS files at `stylesheets/`.

Anypic uses media queries to present different layouts on iPad, iOS and various desktop resolutions. These media queries will apply different CSS properties, as defined by `_320.scss`, `_480.scss`, `_768.scss`, `_1024.scss`, and `_1024.scss` depending on the device's horizontal resolution. You can modify these in `sass/screen.scss`. The following media query applies the CSS rules laid out in `_320.scss` when your website is visited from an iPhone, for example:

```sass
@media only screen and (max-width : 320px) { @import "320" }
```

## Cloud Code

Add your Parse app id and master key to `Anypic-iOS/CloudCode/config/global.json`, then type `parse deploy` from the command line at `Anypic-iOS/CloudCode`. See the [Cloud Code Guide](https://parse.com/docs/cloud_code_guide#clt) for more information about the `parse` CLI.