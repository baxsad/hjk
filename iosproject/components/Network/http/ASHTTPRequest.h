//
//  ASHTTPRequest.h
//  iosproject
//
//  Created by hlcisy on 2020/12/9.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ASHTTPRequestState) {
    ASHTTPRequestInitialized = 0,
    ASHTTPRequestResumed,
    ASHTTPRequestSuspended,
    ASHTTPRequestCancelled,
    ASHTTPRequestFinished
};

@interface ASHTTPRequest : NSObject
@property (nonatomic, assign) ASHTTPRequestState state;
@property (nonatomic, strong) NSUUID *identifier;
@property (nonatomic, strong) dispatch_queue_t underlyingQueue;
@property (nonatomic, strong) dispatch_queue_t serializationQueue;

@end

NS_ASSUME_NONNULL_END
