# Weather iOS App Using Clean Architecture + MVVM

## Description
Weather app is an iOS application built to highlight the Clean Architecture concepts with MVVM in the UI layers
##  Run Requirements

Xcode 13
Swift 5

##  High Level Layers

MVVM Concepts

Presentation Logic

###  View - delegates user interaction events to the ViewModel and displays data passed by the ViewModel
 - All UIViewController, UIView, UITableViewCell subclasses belong to the View layer
 - Usually the view is passive / dumb - it shouldn't contain any complex logic 
    
###  View Model - contains the presentation logic and tells the View what to present
 - Usually we have one View Model per scene (view controller)
 - It doesn't reference the concrete type of the View, but rather it references the View protocol that is implemented usually by a UIViewController subclass
 - It is a Swift class and not reference any iOS framework classes - this makes it easier to reuse it maybe in a macOS application
 - It should be covered by Unit Tests
 
 ###  UI Composer - injects the dependency object graph into the scene (view controller)
 - Usually it contains very simple logic
 
 ###  Coordinator - contains navigation / flow logic from one scene (view controller) to another
 - In some communities / blog posts it might be referred to as a FlowControlleror/ Router/ Coordinator

## Clean Architecture Concepts

###  Usecases - contains the application / business logic for a specific use case in the application
- It is referenced by the View Model. The Presenter can reference multiple Usecases since it's common to have multiple use cases on the same screen
 - It manipulates Entities and communicates with Gateways/Router to retrieve / persist the entities

The separation described above ensures that the Application Logic depends on abstractions and not on concrete frameworks / implementations
It should be covered by Unit Tests

###  Model - plain Swift classes / structs
Models objects used by your application such as Post, Comment etc

## CI/CD - 
 - Github Actions

## Future Improvement - 
 - Integration tests for view controllers
 - Unit test for viemodel
 - Make the UseCase Generic so that it can be reused for both current weather and five weather forecast, by injecting their respective mappers
 - Refactor hard coded ui string, assets names and colour values into a dedicated composble types so that it is maintainable and scalable
 - Unit CoreLocationAdapter

## Design Patterns Used -
 
 - Adapter Pattern
 - Decorator
 - MVVM 
 - Factory

## Tools-
 
 - CodeCov
 - SwiftLint
 - Githuub Action - for CI 

##  BDD Specs

### Narrative #1

    As as a customer
    I want the app to automatically request for access to my location data if access has not been granted
    So I can have access my present day and five days forecast to enable me plan adequately based on weather conditions

### Scenerios (Acceptance Criteria)

    Given the app has requested access to fetch location data
    When the customer authoized the requests
    Then the app should have access to the customers current location data

###  Narrative #2

    As an online customer
    I want the app to automatically use my current location to load my present day and five days weather forcast
    So I can have access my present day and five days forecast to enable me plan adequately based on weather conditions

### Scenerios (Acceptance Criteria)

    GIven the customer has connectivity
    When the customer request to see the present and five days forecast
    Then the app should access the users current location and use it to fetch the forcast and display the present day and five days forecast from remote and replace the cache with the new forcast as well as date and time it was saved

### Scenerios (Acceptance Criteria)

    Given the customer does not have connectivity
    When the customer requests to see weather forecast
    Then the app should display the latest saved weather forecast as well as time last updated

    Given the customer does not have connectivity and the cache is empty
    When the customer requests to see weather forecast
    Then the app should display an error message

###  Use Cases

###  Retrieve Current Location Usecase

    Primary Course (happy path):
    Execute “Retrieve Current Location” command” 
    System checks for Location permission access
    System fetches current location item
    System delivers current location item

    Invalid data error course (sad path):
    System delivers error

###  Load Forcast Usecase

    Data:
    URL
    CurrentLocationItem

    Primary Course (happy path):
    Execute the“Load Forcast Item” command with above data
    System download data from the url
    System validates downloaded data
    System create forecast item from the data
    System delivers forecast items

    Invalid data error course (sad path):
    System delivers error
