// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPEventServer.h"
#import "GCDWebServerDataRequest.h"
#import "UPPLastChangeParser.h"

const NSUInteger UPPEventServerPort = 54123;
NSString * const UPPEventServerSIDKey = @"SID";
NSString * const UPPEventServerBodyKey = @"Event";

@implementation UPPEventServer

- (void)startServer
{
    __weak typeof(self) weakSelf = self;

    [self.webServer addHandlerForMethod:@"NOTIFY" path:@"/Event" requestClass:[GCDWebServerDataRequest class] processBlock:^GCDWebServerResponse *(GCDWebServerRequest *request) {
        if (request != nil) {
            [weakSelf requestRecieved:(GCDWebServerDataRequest *)request];
        }
        return [[GCDWebServerResponse alloc] init];
    }];

    [self.webServer startWithPort:UPPEventServerPort bonjourName:nil];
}

- (void)stopServer
{
    if ([self.webServer isRunning]) {
        [self.webServer stop];
    }
}

- (NSURL *)eventServerCallbackURL
{
    if (!self.webServer.isRunning) {
        return nil;
    }
    NSURL *baseURL = self.webServer.serverURL;
    return [baseURL URLByAppendingPathComponent:@"Event"];
}

- (BOOL)isRunning
{
    return self.webServer.isRunning;
}

#pragma mark - Lazy Instantiation

- (GCDWebServer *)webServer
{
    if (!_webServer) {
        _webServer = [[GCDWebServer alloc] init];
    }
    return _webServer;
}

#pragma mark - Callbacks

- (void)requestRecieved:(GCDWebServerDataRequest *)request
{
    NSDictionary *headers = request.headers;
    NSMutableDictionary *eventDictionary = [NSMutableDictionary dictionary];

    NSString *sid = headers[@"SID"];
    if (sid) {
        [eventDictionary setObject:sid forKey:UPPEventServerSIDKey];
    }

    [UPPLastChangeParser parseData:request.data completion:^(NSDictionary *event, NSError *error) {
        if (event) {
            eventDictionary[UPPEventServerBodyKey] = event;
        }
    }];

    [self.eventDelegate eventReceived:[eventDictionary copy]];
}

@end
