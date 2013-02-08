/* Network.m
 *
 * Copyright (C) 2012  Belledonne Comunications, Grenoble, France
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

#import "Network.h"
#import "BuschJaegerConfiguration.h"
#import "Utils.h"

@implementation Network

@synthesize domain;
@synthesize localAddress;
@synthesize globalAddress;
@synthesize localHistory;
@synthesize globalHistory;
@synthesize tlsCertificate;
@synthesize derCertificate;
/*
 domain=abb
 
 local-address=192.168.1.1
 
 global-address=welcome.dyndns.org
 
 local-history=http://192.168.1.1:8080/history.ini
 
 global-history=http://welcome.dyndns.org:8080/history.ini
 
 tls-certificate=http://192.168.1.1:8080/cert.pem 
 
 der-certificate=http://192.168.1.1:8080/cert.der
 */

- (void)dealloc {
    [domain release];
    [localAddress release];
    [globalAddress release];
    [localHistory release];
    [globalHistory release];
    [tlsCertificate release];
    
    [super dealloc];
}

- (NSString*)write {
    NSMutableString *str = [NSMutableString string];
    [str appendString:[NSString stringWithFormat:@"\n[network]\n"]];
    [str appendString:[NSString stringWithFormat:@"domain=%@\n", domain]];
    [str appendString:[NSString stringWithFormat:@"local-address=%@\n", localAddress]];
    [str appendString:[NSString stringWithFormat:@"global-address=%@\n", globalAddress]];
    [str appendString:[NSString stringWithFormat:@"local-history=%@\n", localHistory]];
    [str appendString:[NSString stringWithFormat:@"global-history=%@\n", globalHistory]];
    [str appendString:[NSString stringWithFormat:@"tls-certificate=%@\n", tlsCertificate]];
    [str appendString:[NSString stringWithFormat:@"der-certificate=%@\n", derCertificate]];
    return str;
}

+ (id)parse:(NSString*)section array:(NSArray*)array {
    NSString *gparam;
    Network *net = nil;
    if((gparam = [BuschJaegerConfiguration getRegexValue:@"^\\[(network)\\]$" data:section]) != nil) {
        net = [[[Network alloc] init] autorelease];
        NSString *param;
        for(NSString *entry in array) {
            if((param = [BuschJaegerConfiguration getRegexValue:@"^domain=(.*)$" data:entry]) != nil) {
                net.domain = param;
            } else if((param = [BuschJaegerConfiguration getRegexValue:@"^local-address=(.*)$" data:entry]) != nil) {
                net.localAddress = param;
            } else if((param = [BuschJaegerConfiguration getRegexValue:@"^global-address=(.*)$" data:entry]) != nil) {
                net.globalAddress = param;
            } else if((param = [BuschJaegerConfiguration getRegexValue:@"^local-history=(.*)$" data:entry]) != nil) {
                net.localHistory = param;
            } else if((param = [BuschJaegerConfiguration getRegexValue:@"^global-history=(.*)$" data:entry]) != nil) {
                net.globalHistory = param;
            } else if((param = [BuschJaegerConfiguration getRegexValue:@"^tls-certificate=(.*)$" data:entry]) != nil) {
                net.tlsCertificate = param;
            } else if((param = [BuschJaegerConfiguration getRegexValue:@"^der-certificate=(.*)$" data:entry]) != nil) {
                net.derCertificate = param;
            } else if([[entry stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] != 0){
                [LinphoneLogger log:LinphoneLoggerWarning format:@"Unknown entry in %@ section: %@", section, entry];
            }
        }
    }
    
    return net;
}

@end