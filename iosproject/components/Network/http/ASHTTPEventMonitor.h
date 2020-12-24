//
//  ASHTTPEventMonitor.h
//  iosproject
//
//  Created by hlcisy on 2020/12/9.
//  Copyright © 2020 hlcisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ASHTTPRequest;

@protocol ASHTTPEventMonitor <NSObject>
@optional
#pragma mark - URLSession
- (dispatch_queue_t)queue;
- (void)urlSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error;
- (void)urlSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceive:(NSURLAuthenticationChallenge *)challenge;
- (void)urlSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend;
- (void)urlSession:(NSURLSession *)session taskNeedsNewBodyStream:(NSURLSessionTask *)task;
- (void)urlSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request;
- (void)urlSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollecting:(NSURLSessionTaskMetrics *)metrics;
- (void)urlSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error;
- (void)urlSession:(NSURLSession *)session taskIsWaitingForConnectivity:(NSURLSessionTask *)task API_AVAILABLE(ios(11.0));
- (void)urlSession:(NSURLSession *)session dataTask:(NSURLSessionTask *)task didReceive:(NSData *)data;
- (void)urlSession:(NSURLSession *)session dataTask:(NSURLSessionTask *)task willCacheResponse:(NSCachedURLResponse *)proposedResponse;
- (void)urlSession:(NSURLSession *)session
      downloadTask:(NSURLSessionTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes;
- (void)urlSession:(NSURLSession *)session
      downloadTask:(NSURLSessionTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;
- (void)urlSession:(NSURLSession *)session downloadTask:(NSURLSessionTask *)downloadTask didFinishDownloadingTo:(NSURL *)location;
#pragma mark - Request
- (void)request:(ASHTTPRequest *)request didCreateInitialURLRequest:(NSURLRequest *)urlRequest;
- (void)request:(ASHTTPRequest *)request didFailToCreateURLRequestWithError:(NSError *)error;
- (void)request:(ASHTTPRequest *)request didAdaptInitialRequest:(NSURLRequest *)initialRequest to:(NSURLRequest *)adaptedRequest;
- (void)request:(ASHTTPRequest *)request didFailToAdaptURLRequest:(NSURLRequest *)initialRequest withError:(NSError *)error;
- (void)request:(ASHTTPRequest *)request didCreateURLRequest:(NSURLRequest *)urlRequest;
- (void)request:(ASHTTPRequest *)request didCreateTask:(NSURLSessionTask *)task;
- (void)request:(ASHTTPRequest *)request didGatherMetrics:(NSURLSessionTaskMetrics *)metrics;
- (void)request:(ASHTTPRequest *)request didFailTask:(NSURLSessionTask *)task earlyWithError:(NSError *)error;
- (void)request:(ASHTTPRequest *)request didCompleteTask:(NSURLSessionTask *)task with:(nullable NSError *)error;
- (void)requestIsRetrying:(ASHTTPRequest *)request;
- (void)requestDidFinish:(ASHTTPRequest *)request;
- (void)requestDidResume:(ASHTTPRequest *)request;
- (void)request:(ASHTTPRequest *)request didResumeTask:(NSURLSessionTask *)task;
- (void)requestDidSuspend:(ASHTTPRequest *)request;
- (void)request:(ASHTTPRequest *)request didSuspendTask:(NSURLSessionTask *)task;
- (void)requestDidCancel:(ASHTTPRequest *)request;
- (void)request:(ASHTTPRequest *)request didCancelTask:(NSURLSessionTask *)task;
- (void)request:(ASHTTPRequest *)request
didValidateRequest:(nullable NSURLRequest *)urlRequest
       response:(NSHTTPURLResponse *)response
           data:(nullable NSData *)data
     withResult:(id)result;
@end

@interface ASHTTPEventMonitor : NSObject

@end

NS_ASSUME_NONNULL_END
