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

```// === SET YOUR ID ===  
var userProfile = UserProfile.sharedInstance  
userProfile.userID = 1  
// ===================```  