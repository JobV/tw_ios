## Instructions

- `pod install` before starting to work
- start working from `.workspace`, rather than `.xcodeproj`.

## REST API

The rest api uses restkit pod to consume and populate the twapi.

Rest API Folder has two folders.

* Controller - Object related controllers (Location, User, etc.)
* Classes - Objects to which controllers map rest requests and responses

## SET YOUR ID MANUALLY
- at LoginViewController change the user you want to impersonate by setting manually the userID var:

```swift
// === SET YOUR ID ===    
var userProfile = UserProfile.sharedInstance    
userProfile.userID = 1    
// ===================
```

## SET YOUR APP SERVER ADDRESS
- APIConnectionManager.swift is where the address is being hardcoded, to change server addresses simply change the ip
- 
```swift
import Foundation    
class APIConnectionManager: NSObject {    
    class var serverAddress: String { return "http://192.168.1.68:3000" }    
}    
```
