# PixFinder
An photo searching app made with ❤️ to demonstrate some examples of **clean architecture**, **code organisation**, **loose coupling**, unit testing (coming up) and some of the best practices used in modern iOS programming using latest `Swift 5.0.1` and its latest power tools like `Combine` and some of the `SwiftUI` magic.

### MVVM with Clean architecture
- Loose coupling of layers
- For unit testing of all layers (pending, work in progress)
### 3 Layer App architecture
- **Data Layer**
    - Network related tasks
    - Service & HTTP clients
- **Domain Layer**
    - UseCase & business logic
- **Presentation Layer**
    - The UI layer code using UIKit & MVVM - VCs & VMs
    - **Custom Error Handling**
        -  At network layer error is mapped in custom way
        - Offline / Network disconnected error is shown separately ○ Any other generic errors are also mapped
    - **Adaptive layout**
        -  Designed for both iPhone & iPad
        -  Size Class detection and custom collection view layout
    - **Custom Theme** & **Dark mode** support
        - Custom fonts
        -   Custom colours
        -   Defined globally in `Theme` to use consistently
    - **Custom Accessibility** & **Dynamic Type**
        - Custom Font `Avenir` used
        - Dynamic Type Supported to scale font up/down as needed for
        - Accessibility Ids are attached for future UI testing
        - Correct labels are attached to elements for Voice over
    -   **Localisations/Internationalisations**
        -  strings file based localisation
        -  `English`, `French`, `Spanish` are supported
        -  Keywords are searched to `Pixabay API` based on device locale to get
 the photo results localised
    -   Use of **Combine**
    -   Use of **SwiftUI** 

## Demos:

![](/Screenshots/demo-giphy.gif "")

### Light Mode
![](/Screenshots/light-shimmer.png "")
![](/Screenshots/light-list.png "")
![](/Screenshots/light-detail.png "")

### Dark Mode
![](/Screenshots/dark-list.png "")
![](/Screenshots/dark-detail.png "")


## Installation

- **Xcode 11.4**(required) with Swift 5.0.1
- Clean and build the project in Xcode or `/DerivedData` folder if needed
- No 3rd Party Libraries used at this stage

# TODOs:
 - **Unit testing at each layer** (via `Quick / Nimble`)
 

