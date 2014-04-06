//
//  ParseXMLUtil.m
//  POS2iPhone
//
//  Created by  STH on 11/28/12.
//  Copyright (c) 2012 RYX. All rights reserved.
//

#import "ParseXMLUtil.h"
#import "TBXML.h"
#import "CatalogModel.h"
#import "SystemConfig.h"
#import "BankModel.h"
#import "RechargeModel.h"
#import "FileOperatorUtil.h"
#import "FieldModel.h"
#import "TransferModel.h"
#import "AreaModel.h"
#import "CityModel.h"

@implementation ParseXMLUtil

+ (NSDictionary *) parseSystemConfigXML
{
    NSError *error = nil;
    TBXML *tbXML = [[TBXML alloc] initWithXMLData:[FileOperatorUtil getDataFromXML:@"systemconfig.xml"] error:&error];
    if (error) {
        NSLog(@"%@->ParseSystemConfigXML:%@", [self class] ,[error localizedDescription]);
        return nil;
    }
    
    TBXMLElement *rootElement = [tbXML rootXMLElement];
    if (rootElement) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        TBXMLElement *itemElement = [TBXML childElementNamed:@"item" parentElement:rootElement];
        while (itemElement) {
            NSString *key = [TBXML valueOfAttributeNamed:@"key" forElement:itemElement];
            NSString *value = [TBXML valueOfAttributeNamed:@"value" forElement:itemElement];
            [dic setObject:value forKey:key];
            itemElement = [TBXML nextSiblingNamed:@"item" searchFromElement:itemElement];
        }
        return dic;
    }
    return nil;
}

// 因为有的属性可能不存在导致程序崩溃，所以更改了TBXML的源代码：TBXML.m at 316
+ (NSArray *) parseCatalogXML
{
    NSError *error = nil;
    
    NSString *tmp = @"catalog.xml";
    if (ApplicationDelegate.isAishua) {
        tmp = @"catalog_aishua.xml";
    }
    TBXML *tbXML = [[TBXML alloc] initWithXMLData:[FileOperatorUtil getDataFromXML:tmp] error:&error];
    if (error) {
        NSLog(@"%@->parseCatalogXML:%@", [self class], [error localizedDescription]);
        return nil;
    }
    
    TBXMLElement *rootElement = [tbXML rootXMLElement];
    if (rootElement) {
        NSMutableArray *array = [NSMutableArray array];
        TBXMLElement *catalogElement = [TBXML childElementNamed:@"catalog" parentElement:rootElement];
        while (catalogElement) {
            CatalogModel *model = [[CatalogModel alloc] init];
            
            [model setCatalogId:[[TBXML textForElement:[TBXML childElementNamed:@"catalogId" parentElement:catalogElement]] integerValue]];
            [model setTitle:[TBXML textForElement:[TBXML childElementNamed:@"title" parentElement:catalogElement]]];
            [model setParentId:[[TBXML textForElement:[TBXML childElementNamed:@"parentId" parentElement:catalogElement]] integerValue]];
            [model setActionId:[TBXML textForElement:[TBXML childElementNamed:@"actionId" parentElement:catalogElement]]];
            [model setIconId:[[TBXML textForElement:[TBXML childElementNamed:@"iconId" parentElement:catalogElement]] integerValue]];
            //[model setDescription:[TBXML textForElement:[TBXML childElementNamed:@"description" parentElement:catalogElement]]];
            [model setNeedReverse:[[TBXML textForElement:[TBXML childElementNamed:@"needReverse" parentElement:catalogElement]] boolValue]];
            //[model setTransferCode:[TBXML textForElement:[TBXML childElementNamed:@"transferCode" parentElement:catalogElement]]];
            [model setActive:[[TBXML textForElement:[TBXML childElementNamed:@"isActive" parentElement:catalogElement]] boolValue]];
            
            [array addObject:model];
            
            catalogElement = [TBXML nextSiblingNamed:@"catalog" searchFromElement:catalogElement];
        }
        return array;
    }
    
    return nil;
    
}

+ (NSArray *) parseBankXML
{
    NSError *error = nil;
    TBXML *tbXML = [[TBXML alloc] initWithXMLData:[FileOperatorUtil getDataFromXML:@"bank.xml"] error:&error];
    if (error) {
        NSLog(@"%@->parseBankXML:%@", [self class] ,[error localizedDescription]);
        return nil;
    }
    
    TBXMLElement *rootElement = [tbXML rootXMLElement];
    if (rootElement) {
        NSMutableArray *array = [NSMutableArray array];
        TBXMLElement *bankElement = [TBXML childElementNamed:@"bank" parentElement:rootElement];
        while (bankElement) {
            NSString *name = [TBXML valueOfAttributeNamed:@"name" forElement:bankElement];
            NSString *code = [TBXML valueOfAttributeNamed:@"code" forElement:bankElement];
            BankModel *bank = [[BankModel alloc] init];
            [bank setName:name];
            [bank setCode:code];
            [array addObject:bank];
            
            bankElement = [TBXML nextSiblingNamed:@"bank" searchFromElement:bankElement];
        }
        
        return array;
    }
    
    return nil;
}
//省份
+ (NSArray *) parseAreaXML
{
    NSError *error = nil;
    TBXML *tbXML = [[TBXML alloc] initWithXMLData:[FileOperatorUtil getDataFromXML:@"province.xml"] error:&error];
    if (error) {
        NSLog(@"%@->parseProvinceXML:%@", [self class] ,[error localizedDescription]);
        return nil;
    }
    
    TBXMLElement *rootElement = [tbXML rootXMLElement];
    if (rootElement) {
        NSMutableArray *array = [NSMutableArray array];
        TBXMLElement *bankElement = [TBXML childElementNamed:@"province" parentElement:rootElement];
        while (bankElement) {
            NSString *name = [TBXML valueOfAttributeNamed:@"name" forElement:bankElement];
            NSString *code = [TBXML valueOfAttributeNamed:@"code" forElement:bankElement];
            AreaModel *area = [[AreaModel alloc] init];
            [area setName:name];
            [area setCode:code];
            [array addObject:area];
            
            bankElement = [TBXML nextSiblingNamed:@"province" searchFromElement:bankElement];
        }
        
        return array;
    }
    
    return nil;
}
//城市
+ (NSArray *) parseCityXML
{
    NSError *error = nil;
    TBXML *tbXML = [[TBXML alloc] initWithXMLData:[FileOperatorUtil getDataFromXML:@"city.xml"] error:&error];
    if (error) {
        NSLog(@"%@->parseCityXML:%@", [self class] ,[error localizedDescription]);
        return nil;
    }
    
    TBXMLElement *rootElement = [tbXML rootXMLElement];
    if (rootElement) {
        NSMutableArray *array = [NSMutableArray array];
        TBXMLElement *bankElement = [TBXML childElementNamed:@"city" parentElement:rootElement];
        while (bankElement) {
            NSString *parentCode = [TBXML valueOfAttributeNamed:@"parentCode" forElement:bankElement];
            NSString *name = [TBXML valueOfAttributeNamed:@"name" forElement:bankElement];
            NSString *code = [TBXML valueOfAttributeNamed:@"code" forElement:bankElement];
            CityModel *city = [[CityModel alloc] init];
            [city setParentCode:parentCode];
            [city setName:name];
            [city setCode:code];
            [array addObject:city];
            
            bankElement = [TBXML nextSiblingNamed:@"city" searchFromElement:bankElement];
        }
        
        return array;
    }
    
    return nil;
}

+ (NSArray *) parsePhoneRechargeXML
{
    NSError *error = nil;
    TBXML *tbXML = [[TBXML alloc] initWithXMLData:[FileOperatorUtil getDataFromXML:@"phonerecharge.xml"] error:&error];
    if (error) {
        NSLog(@"%@->parsePhoneRechargeXML:%@", [self class] ,[error localizedDescription]);
        return nil;
    }
    
    TBXMLElement *rootElement = [tbXML rootXMLElement];
    if (rootElement) {
        NSMutableArray *array = [NSMutableArray array];
        TBXMLElement *rechargeElement = [TBXML childElementNamed:@"item" parentElement:rootElement];
        while (rechargeElement) {
            NSString *key = [TBXML valueOfAttributeNamed:@"key" forElement:rechargeElement];
            NSString *value = [TBXML valueOfAttributeNamed:@"value" forElement:rechargeElement];
            RechargeModel *model = [[RechargeModel alloc] init];
            [model setFaceValue:key];
            [model setSellingPrice:value];
            [array addObject:model];
            
            rechargeElement = [TBXML nextSiblingNamed:@"item" searchFromElement:rechargeElement];
        }
        
        return array;
    }
    
    return nil;
}

+ (NSDictionary *) parseHistoryTypeXML
{
    NSError *error = nil;
    TBXML *tbXML = [[TBXML alloc] initWithXMLData:[FileOperatorUtil getDataFromXML:@"queryhistorymap.xml"] error:&error];
    if (error) {
        NSLog(@"%@->parseHistoryTypeXML:%@", [self class] ,[error localizedDescription]);
        return nil;
    }
    
    TBXMLElement *rootElement = [tbXML rootXMLElement];
    if (rootElement) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        TBXMLElement *typeElement = [TBXML childElementNamed:@"item" parentElement:rootElement];
        while (typeElement) {
            NSString *key = [TBXML valueOfAttributeNamed:@"key" forElement:typeElement];
            NSString *value = [TBXML valueOfAttributeNamed:@"value" forElement:typeElement];
            [dic setObject:value forKey:key];
            
            typeElement = [TBXML nextSiblingNamed:@"item" searchFromElement:typeElement];
        }
        
        return dic;
    }
    
    return nil;
}

+ (NSDictionary *) parseReversalMapXML
{
    NSError *error = nil;
    TBXML *tbXML = [[TBXML alloc] initWithXMLData:[FileOperatorUtil getDataFromXML:@"reversalmap.xml"] error:&error];
    if (error) {
        NSLog(@"%@->parseReversalMapXML:%@", [self class] ,[error localizedDescription]);
        return nil;
    }
    
    TBXMLElement *rootElement = [tbXML rootXMLElement];
    if (rootElement) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        TBXMLElement *typeElement = [TBXML childElementNamed:@"item" parentElement:rootElement];
        while (typeElement) {
            NSString *key = [TBXML valueOfAttributeNamed:@"key" forElement:typeElement];
            NSString *value = [TBXML valueOfAttributeNamed:@"value" forElement:typeElement];
            [dic setObject:value forKey:key];
            
            typeElement = [TBXML nextSiblingNamed:@"item" searchFromElement:typeElement];
        }
        
        return dic;
    }
    
    return nil;
}

+ (NSDictionary *) parseTransferMapXML
{
    NSError *error = nil;
    TBXML *tbXML = [[TBXML alloc] initWithXMLData:[FileOperatorUtil getDataFromXML:@"transfername.xml"] error:&error];
    if (error) {
        NSLog(@"%@->parseTransferMapXML:%@", [self class] ,[error localizedDescription]);
        return nil;
    }
    
    TBXMLElement *rootElement = [tbXML rootXMLElement];
    if (rootElement) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        TBXMLElement *typeElement = [TBXML childElementNamed:@"item" parentElement:rootElement];
        while (typeElement) {
            NSString *code = [TBXML valueOfAttributeNamed:@"code" forElement:typeElement];
            NSString *name = [TBXML valueOfAttributeNamed:@"name" forElement:typeElement];
            [dic setObject:name forKey:code];
            
            typeElement = [TBXML nextSiblingNamed:@"item" searchFromElement:typeElement];
        }
        
        return dic;
    }
    
    return nil;
}

+ (TransferModel *) parseConfigXML:(NSString *) transferCode
{
    
    NSError *error = nil;
//    TBXML *tbXML = [[TBXML alloc] initWithXMLData:[FileOperatorUtil getDataFromXML:[NSString stringWithFormat:@"con_req_%@.xml", transferCode]] error:&error];
    NSString *formatStr = @"con_req_%@.xml";
    if (ApplicationDelegate.isAishua ) {
        if([transferCode isEqualToString:@"086000"] || [transferCode isEqualToString:@"080003"] || [transferCode isEqualToString:@"086002"]
           || [transferCode isEqualToString:@"020001"] || [transferCode isEqualToString:@"020022"] || [transferCode isEqualToString:@"020023"]){
            formatStr = @"con_req_%@_aishua.xml";    
        }
        
    }
    TBXML *tbXML = [[TBXML alloc] initWithXMLFile:[NSString stringWithFormat:formatStr, transferCode] error:&error];
    
    if (error) {
        NSLog(@"%@->parseConfigXML:%@", [self class] ,[error localizedDescription]);
        return nil;
    }
    
    TBXMLElement *rootElement = [tbXML rootXMLElement];
    if (rootElement) {
        TBXMLElement *fieldElement = [TBXML childElementNamed:@"field" parentElement:rootElement];
        
        NSString * _isJson = [TBXML valueOfAttributeNamed:@"isJson" forElement:rootElement];
        NSString * _shouldMac = [TBXML valueOfAttributeNamed:@"shouldMac" forElement:rootElement];
        
        NSMutableArray *fieldArray = [[NSMutableArray alloc] init];
        //print false
        NSLog(@"######======= %@",_isJson);
        NSLog(@"######======= %@",_shouldMac);
        
//        [UserDefaults setObject:_isJson forKey:@"ISJSON"];
//        [UserDefaults synchronize];

        while (fieldElement) {
            FieldModel *model = [[FieldModel alloc] init];
            
            [model setKey:[TBXML valueOfAttributeNamed:@"key" forElement:fieldElement]];
            [model setValue:[TBXML valueOfAttributeNamed:@"value" forElement:fieldElement]];
            [model setMac:[TBXML valueOfAttributeNamed:@"macField" forElement:fieldElement]];
            
            [fieldArray addObject:model];
            
            fieldElement = [TBXML nextSiblingNamed:@"field" searchFromElement:fieldElement];
        }
        
        TransferModel *transModel = [[TransferModel alloc] initWithArray:fieldArray isJson:_isJson shouldMac:_shouldMac];
//        transModel.fieldModelArray = fieldArray;
        
        return transModel;
    }
    return nil;
}

@end

