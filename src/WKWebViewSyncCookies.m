#import "WKWebViewSyncCookies.h"
#import <Cordova/CDV.h>

@implementation WKWebViewSyncCookies

- (void)sync:(CDVInvokedUrlCommand *)command {
  @try {
    NSString *urlString = command.arguments[0];
		NSString *body = command.arguments[1];

		NSString *post = [NSString stringWithFormat:body];
		NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding];
		
    NSURL *url = [NSURL URLWithString:urlString];

    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
		[urlRequest setHTTPBody:postData];
    [urlRequest setValue:@"application/vnd.api+json" forHTTPHeaderField:@"Content-Type"];

    NSURLSession *urlSession = [NSURLSession sharedSession];

    [[urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable urlResponse, NSError * _Nullable error) {
      CDVPluginResult *result;

      if (error) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
      } else {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
      }

      [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }] resume];
  }
  @catch (NSException *exception) {
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:exception.reason];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
  }
}

@end
