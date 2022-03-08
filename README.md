# Keychain
This respository is a simple project for saving password in keychain using import Security framework.
- Keychain is storage of small, sensitive data such as passwords, bank account numbers, or some other personal information that we want to keep confidential for your users. Like OS X, iOS also provides a keychain for your application to be able to store all of the above sensitive data types. Normally, we can only use these types of information in the same application and cannot be used in other apps. So, have you ever heard about Facebook and Messenger? Just kidding. The coolest thing about two apps is that once you logged into Facebook with a registered account successfully, you can also log with the same account into Messenger. But you may wonder if we can do it, that means the account information was not secured. The app has to know the user’s email and password in order to login to Messenger – a chat application. Well, actually we can use Keychain Sharing to do that while ensuring the security. We can share the stored Keychain between many different applications on the same device which has the same Apple Developer Account. At iOS App Templates, we also have some projects with chat features like that such as iOS Dating App Template or Free Swift iOS Chat with Firebase, where we leverage this Keychain sharing feature.

## Sources
 - https://developer.apple.com/videos/play/wwdc2017/206/
 - https://www.youtube.com/watch?v=ojFQWbcITnw
 - https://www.youtube.com/watch?v=x1nl_osxqlU
 - https://stackoverflow.com/questions/33590842/is-there-any-way-could-save-username-and-password-in-device-using-swift-in-ios-t
 - https://stackoverflow.com/questions/30719638/save-and-retrieve-value-via-keychain
 - https://iosapptemplates.com/blog/ios-programming/keychain-swift-ios

### Test Project by Lee McCormick
Learning Switf and Xcode is my passion. This project was built by following the tutorial and source code online.
