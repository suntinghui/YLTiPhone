//
//  ParseXMLUtil.h
//  POS2iPhone
//
//  Created by  STH on 11/28/12.
//  Copyright (c) 2012 RYX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransferModel.h"

@interface ParseXMLUtil : NSObject

+ (NSDictionary *) parseSystemConfigXML;
+ (NSArray *) parseCatalogXML;
+ (NSArray *) parseBankXML;
+ (NSArray *) parsePhoneRechargeXML;
+ (NSDictionary *) parseHistoryTypeXML;
+ (NSDictionary *) parseReversalMapXML;
+ (NSDictionary *) parseTransferMapXML;
+ (TransferModel *) parseConfigXML:(NSString *) transferCode;

+ (NSArray *) parseAreaXML;
+ (NSArray *) parseCityXML;

@end
