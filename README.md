# Papara iOS SDK

[![CI Status](http://img.shields.io/travis/paparateam/papara-ios.svg?style=flat)](https://travis-ci.org/paparateam/papara-ios)
[![Version](https://img.shields.io/cocoapods/v/Papara.svg?style=flat)](http://cocoapods.org/pods/Papara)
[![License](https://img.shields.io/cocoapods/l/Papara.svg?style=flat)](http://cocoapods.org/pods/Papara)
[![Platform](https://img.shields.io/cocoapods/p/Papara.svg?style=flat)](http://cocoapods.org/pods/Papara)

You can sign up for a Papara account at http://www.papara.com.

## Requirements

- iOS 9.0+
- Xcode 8.0+
- Swift 4.2+

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

### Swift 4.2

To integrate Papara into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'Papara', '~> 4.2'
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
* **CFBundleURLTypes** For handling returns from Papara App. Should be papara{PaparaAppID}. For example if your AppId is 87826504 so CFBundleURLTypes will be papara87826504


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

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
	...
    Papara.application(application, didFinishLaunchingWithOptions: launchOptions)
    ...
    return true
}

```

### Handlers

Papara returns true if link is handled by sdk

```swift
AppDelegate.swift

import Papara

func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
    let handled = Papara.application(application, handleOpen: url)
    // Add any custom logic here.
    return handled
}

func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
    let handled = Papara.application(app, open: url, options: options)
    // Add any custom logic here.
    return handled
}
```

### Papara Account Number

```swift
UIViewController.swift

import Papara

Papara.getPaparaNumber(self) { (result) in
    switch result {
    case .success(let paparaNumber):
        self.showAlertDialog("Success", message: String(paparaNumber))
    case .fail(let error):
        self.showAlertDialog("Error", message: error.localizedDescription)
    case .cancel:
        self.showAlertDialog("Cancel", message: "Cancel")
    }
}
```

### Papara Send Money

#### Send to Papara Number

```swift
UIViewController.swift

import Papara

Papara.sendMoney(self, to: .paparaNumber(Int64(wallet)!), amount: amount!) { (result) in
    switch result {
    case .success:
        self.showAlertDialog("Success", message: "Success")
    case .fail(let error):
        self.showAlertDialog("Fail", message: error.localizedDescription)
    case .cancel:
        self.showAlertDialog("Cancel", message: "Cancel")
    }
}
```

#### Send to Mobile Phone

```swift
UIViewController.swift

import Papara

Papara.sendMoney(self, to: .mobile(wallet), amount: amount!) { (result) in
    switch result {
    case .success:
        self.showAlertDialog("Success", message: "Success")
    case .fail(let error):
        self.showAlertDialog("Fail", message: error.localizedDescription)
    case .cancel:
        self.showAlertDialog("Cancel", message: "Cancel")
    }
}
```

#### Send to Email Address

```swift
UIViewController.swift

import Papara

Papara.sendMoney(self, to: .email(wallet), amount: amount!) { (result) in
    switch result {
    case .success:
        self.showAlertDialog("Success", message: "Success")
    case .fail(let error):
        self.showAlertDialog("Fail", message: error.localizedDescription)
    case .cancel:
        self.showAlertDialog("Cancel", message: "Cancel")
    }
}
```

### Papara Pay

* Firstly, you need to create a payment using backend.
* SDK needs **paymentId**, **paymentUrl** and **redirectUrl** from backend.

```swift
UIViewController.swift

import Papara

Papara.pay(self, paymentId: payment.id, paymentUrl: payment.paymentUrl, redirectUrl: payment.redirectUrl) { (result) in
    switch result {
    case .success(let paymentId, let referenceId, let status, let amount):
        self.showAlertDialog("Success", message: "Success")
    case .fail(let error):
        self.showAlertDialog("Error", message: error.localizedDescription)
    case .cancel:
        self.showAlertDialog("Cancel", message: "Cancel")
    }
}
```

## License

Papara is available under the MIT license. See the LICENSE file for more info.
