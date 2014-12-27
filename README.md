# There Where iOS App
 

## authors:
 

### Job van der Voort <jobvandervoort@gmail.com>


### Marcelo van der Lebre <marcelo.lebre@gmail.com>

## iOS Project Documentation
* On tw_ios you can find the ios project for therewere
* This project uses cocoapods, hence, to open it with XCode, select .workspace instead of .xcodeproj so that libs can be correctly loaded
* Don't forget to perform "pod install" on the project's root folder

## Project Structure

### REST API

The rest api uses restkit pod to consume and populate the twapi
* Rest API Folder has two folders
** Controller - Object related controllers (Location, User, etc.)
** Classes - Objects to which controllers map rest requests and responses
