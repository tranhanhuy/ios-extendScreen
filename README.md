# ios-extendScreen
## Source
https://github.com/onmyway133/blog/issues/473
## Before iOS 13
Use `UIScreen.didConnectNotification`

```swift
NotificationCenter.default.addObserver(forName: UIScreen.didConnectNotification,
                         object: nil, queue: nil) { (notification) in
        // Get the new screen information.
        let newScreen = notification.object as! UIScreen
        let screenDimensions = newScreen.bounds

        // Configure a window for the screen.
        let newWindow = UIWindow(frame: screenDimensions)
        newWindow.screen = newScreen
        // Install a custom root view controller in the window.
        self.configureAuxilliaryInterface(with: newWindow)

        // You must show the window explicitly.
        newWindow.isHidden = false
        // Save a reference to the window in a local array.
        self.additionalWindows.append(newWindow)}
```

## From iOS 13
Handle `configurationForConnecting`

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

var newWindow: UIWindow!

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.


                        print(UIApplication.shared.connectedScenes)
        let scene = UIWindowScene(session: connectingSceneSession, connectionOptions: options)

                        // Configure a window for the screen.
                        self.newWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: 1000, height: 500))
        //                self.newWindow.backgroundColor = UIColor.yellow
                        // Install a custom root view controller in the window.

                        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "other") as! OtherViewController
                        self.newWindow.rootViewController = viewController
                        self.newWindow.windowScene = scene

                        // You must show the window explicitly.
                        self.newWindow.isHidden = false

        return UISceneConfiguration(name: "External configuration", sessionRole: connectingSceneSession.role)
    }
}
```

Or we can declare in plist

```
<dict>
    <key>UIApplicationSupportsMultipleScenes</key>
    <false/>
    <key>UISceneConfigurations</key>
    <dict>
        <key>UIWindowSceneSessionRoleApplication</key>
        <array>
            <dict>
                <key>UISceneConfigurationName</key>
                <string>Default Configuration</string>
                <key>UISceneDelegateClassName</key>
                <string>$(PRODUCT_MODULE_NAME).SceneDelegate</string>
                <key>UISceneStoryboardFile</key>
                <string>Main</string>
            </dict>
        </array>
        <key>UIWindowSceneSessionRoleExternalDisplay</key>
        <array>
            <dict>
                <key>UISceneConfigurationName</key>
                <string>External configuration</string>
                <key>UISceneDelegateClassName</key>
                <string>$(PRODUCT_MODULE_NAME).OtherSceneDelegate</string>
                <key>UISceneStoryboardFile</key>
                <string>Other</string>
            </dict>
        </array>
    </dict>
</dict>
```

## Read more
* [External Display Support on iOS](https://medium.com/@hacknicity/external-display-support-on-ios-665cd1774511)
* [Supporting External Displays](https://www.swiftjectivec.com/supporting-external-displays/)
* [Building iPad Pro features in Swift](https://www.swiftbysundell.com/articles/building-ipad-pro-features-in-swift/)
* [How can I display different content on different screens in iOS 13?](https://stackoverflow.com/questions/58415368/how-can-i-display-different-content-on-different-screens-in-ios-13)
* [Displaying Content on a Connected Screen](https://developer.apple.com/documentation/uikit/windows_and_screens/displaying_content_on_a_connected_screen)
* [Adding External Display Support To Your iOS App Is Ridiculously Easy](https://www.bignerdranch.com/blog/adding-external-display-support-to-your-ios-app-is-ridiculously-easy/)

