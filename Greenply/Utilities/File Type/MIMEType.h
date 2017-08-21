//
//  MIMEType.h
//  Greenply
//
//  Created by Shatadru Datta on 13/10/16.
//  Copyright © 2016 Indus Net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIMEType : NSString
+ (NSString *)mimeTypeForData:(NSData *)data;
@end
