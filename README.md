# R3PI Grossery Store
## Programming test for R3PI


### Main ViewControllers
- ShopViewController
- CartViewController


### Theme Classes
- Easy to change UI attributes for the whole app
- Can be adjusted to be changed by a configuration on a server

### AppConfigurationManager:
- This class loads a confurationJSON containing basic app properties
- AppConfig.json could be stored on a server to be changed without having to update the App.

### CoreDataStack
- Managing CoreData operations for Products and CartItems

### CurrencyManager + Currency:
- Managing loading of currency exchange rates and currency conversion

### AlertManager
- Easy present AlertViews with callbacks
- Alert Style could be changed here while having the same style throughout the app

### Extensions
- Several extensions of baseClasses for easier and faster development
Examples:
- UIColor+Shop (defined default colors)
- UIImageView+LoadAndCache (asynchronous image loading)
- NavigationController+Animation (Animate view from location to location)
- UIDevice+Helpers (Easy access to differentiate different device models)
- etc.

# ToDo
- DetailViewController for products
- Localisation for different languages with capability to load translation from a configuration on a webserver
- UnitTests


# Suggestions for improvement
### CocoaPods
Some libraries could be included to speedup development and have a cleaner and easier maintainable code

- PromiseKit (beautiful and structured API calls)
- KingFisher (Image loading and caching)
- ObjectMapper (easy and clean object parsing from JSON)
- PureLayout (easy and dynamic adding and manipulating constraints for AutoLayout)

For Monitoring:
- Fabric/Crashlytics
- NewRelicAgent
- Google analytics
- SonarQube

Additional:
- Continous integration (Jenkins/Bamboo in combination with Fastlane or Gradle)