# Shuttler

Shuttler is a mobile application, Android and iOS, to help students track the shuttler at SUNY Plattsburgh Users can see the shuttle position in real time displayed on a map.

## Getting Started

#### 1. [Setup Flutter](https://flutter.io/setup/)

#### 2. Clone the repo

```sh
$ git clone https://github.com/coding-hub-org/shuttler-flutter.git
$ cd shuttler-flutter/
```

#### 3. Setup the Firebase

Contact project owner to get the Firebase config files for Android and iOS.

- Android: `google-services.json` - place the file in `.\android\app`

- iOS: `GoogleService-Info.plist` - place the file in `.\ios\Runner`

#### 4. Setup build config for Android

- Create a file name `key.properties` within `.\android` directory with following content:

```
storePassword=foo
keyPassword=foo
keyAlias=foo
storeFile=foo
```

- It is required to have a value for build the app (even for debug).

- When ready for release build, contact the project owner to get correct values for release build.
