#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
@import GoogleMaps
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  [GMSServices provideAPIKey:@"AIzaSyDeGHreLijVyxGBcSz-l19qh3N6biJEV-U"];
  [GMSPlacesClient provideAPIKey:@"AIzaSyAoih3-6DvYmtyJjS_o20yJkdJxbHJZ9KQ"];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
