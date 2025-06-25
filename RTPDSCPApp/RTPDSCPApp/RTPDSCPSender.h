//
//  RTPDSCPSender.h
//  RTPDSCPApp
//
//  Created by Admin1 on 20/06/25.
//

#ifndef RTPDSCPSender_h
#define RTPDSCPSender_h

#import <Foundation/Foundation.h>

@interface RTPDSCPSender : NSObject

/// Returns nil on success, or an error message string on failure
+ (NSString *)sendFakeRTPPacketToHost:(NSString *)host port:(int)port;

@end

#endif /* RTPDSCPSender_h */
