#import "CrossWallpaperPlugin.h"
#import <cross_wallpaper/cross_wallpaper-Swift.h>

@implementation CrossWallpaperPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCrossWallpaperPlugin registerWithRegistrar:registrar];
}
@end
