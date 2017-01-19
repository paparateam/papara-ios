# Papara iOS SDK

[![CI Status](http://img.shields.io/travis/paparateam/papara-ios.svg?style=flat)](https://travis-ci.org/paparateam/papara-ios)
[![Version](https://img.shields.io/cocoapods/v/Papara.svg?style=flat)](http://cocoapods.org/pods/Papara)
[![License](https://img.shields.io/cocoapods/l/Papara.svg?style=flat)](http://cocoapods.org/pods/Papara)
[![Platform](https://img.shields.io/cocoapods/p/Papara.svg?style=flat)](http://cocoapods.org/pods/Papara)

You can sign up for a Papara account at http://www.papara.com.

## Requirements

- iOS 8.0+
- Xcode 8.0+
- Swift 2.3

## Example

You need to have **Papara Sandbox iOS App** to try Example

1. Install **Papara Sandbox iOS App** from Testflight 
2. Change Example App **Bundle Identifier** to your real app bundle identifier 
3. Change Example App **PaparaAppId** from config to your Papara App Id
4. Run **Example App** in a device which have **Papara Sandbox iOS App** pre installed.



## Installation

### CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Papara into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'Papara', '~> 1.0'
end
```

Then, run the following command:

```bash
$ pod install
```

### 

### App Id

You need to get app id for your application [Papara](http://www.papara.com)

## Usage

### Configuration

* **PaparaAppID** Will be provided by Papara
* **PaparaSandbox** true if you want to test in sandbox environment
* **LSApplicationQueriesSchemes** Remove papara-sandbox in production release
* **CFBundleURLTypes** For handling returns from Papara App. Should be papara{PaparaAppID}. For example app our AppId 87826504 so CFBundleURLTypes is papara87826504


In Xcode, secondary-click your project's .plist file and select Open As -> Source Code.

Insert the following XML snippet into the body of your file just before the final </dict> element.

If you already have same keys you need to merge them

```xml
<dict>
	...
	<key>PaparaAppID</key>
	<string>87826504</string>
	<key>PaparaSandbox</key>
	<true/>
	<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>papara</string>
		<string>papara-sandbox</string>
	</array>
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>papara87826504</string>
			</array>
		</dict>
	</array>
</dict
```

### Initialize

```swift
AppDelegate.swift

import Papara

func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
	...
    Papara.application(application, didFinishLaunchingWithOptions: launchOptions)
    ....
    return true
}

```

### Handlers

Papara returns true if link is handled by sdk

```swift
AppDelegate.swift

import Papara

func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
    let handled = Papara.application(application, handleOpenURL: url)
    // Add any custom logic here.
    return handled
}

func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
    let handled = Papara.application(app, openURL: url, options: options)
    // Add any custom logic here.
    return handled
}
```

### Papara Send Money

```swift
UIViewController.swift

import Papara

Papara.sendMoney(self, wallet: wallet!, amount: amount!, description: description) { (result, code, message) in
    switch result {
    case .success:
        // Success
    case .fail:
		// Fail
    case .cancel:
        // Cancel
    }
}
```

## License

Papara is available under the MIT license. See the LICENSE file for more info.