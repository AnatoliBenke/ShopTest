# ShopTest
Programming test


## H2 Main ViewControllers:
- ShopViewController
- CartViewController


Theme Classes:
- Easy to change UI attributes for the whole app
- Can be adjusted to be changed by a configuration on a server

AppConfigurationManager:
- This class loads a confurationJSON containing basic app properties
- AppConfig.json could be stored on a server to be changed without having to update the App.

CoreDataStack:
- Managing CoreData operations for Products and CartItems

CurrencyManager + Currency:
- Managing loading of currency exchange rates and currency conversion

AlertManager:
- Easy present AlertViews with callbacks
- Alert Style could be changed here while having the same style throughout the app