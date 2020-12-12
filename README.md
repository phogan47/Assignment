# Assignment - Latest Movies  

<br/>

# Summary

A simple application to display a list of the latest movies and and a separate screen to view further details about each movie.


# Installation

### CocoaPods

Make sure that cocoapods is installed and open a terminal in root folder of the project and run...

``` SHELL
$ pod update
```

Open the workspace and run the application to see the demo app. 
----------------------------

# The code

The app architecture is based on the VIP cycle which follows the principle of clean architecture, and has features grouped into scenes. There are two scenes here, one for displaying the latest movies and a second for looking up more details on a selected movie. For the first scene there are some unit tests and very simple UI tests to demonstrate how testing can be performed. These are by no means exhaustive. There is basic error handling to cover scenarios - lost connection and any other error. The app uses AlamoFire for data access and TABTestKit for UI Test support
