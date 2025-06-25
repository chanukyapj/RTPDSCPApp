//
//  RTPDSCPSender.m
//  RTPDSCPApp
//
//  Created by Admin1 on 20/06/25.
//

#import <Foundation/Foundation.h>

#import "RTPDSCPSender.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>

#import "RTPDSCPSender.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>

@implementation RTPDSCPSender

+ (NSString *)sendFakeRTPPacketToHost:(NSString *)host port:(int)port {
	int sockfd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
	if (sockfd < 0) {
		return [NSString stringWithFormat:@"socket creation failed: %s", strerror(errno)];
	}

	int dscp_value = 46 << 2; // DSCP = 46 → TOS = 184
	if (setsockopt(sockfd, IPPROTO_IP, IP_TOS, &dscp_value, sizeof(dscp_value)) < 0) {
		close(sockfd);
		return [NSString stringWithFormat:@"setsockopt failed: %s", strerror(errno)];
	}

	struct sockaddr_in dest_addr;
	memset(&dest_addr, 0, sizeof(dest_addr));
	dest_addr.sin_family = AF_INET;
	dest_addr.sin_port = htons(port);
	inet_pton(AF_INET, [host UTF8String], &dest_addr.sin_addr);

	const char *packet = "Fake RTP Packet";
	ssize_t sent = sendto(sockfd, packet, strlen(packet), 0, (struct sockaddr *)&dest_addr, sizeof(dest_addr));
	if (sent < 0) {
		close(sockfd);
		return [NSString stringWithFormat:@"sendto failed: %s", strerror(errno)];
	}

	close(sockfd);
	return nil; // Success
}

@end
