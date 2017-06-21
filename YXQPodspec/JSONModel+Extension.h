//
//  JSONModel+Extension.h
//  YouGouApp
//
//  Created by iyan on 2017/6/21.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface JSONModel (Extension)

+ (id)objectByTraversingObject:(id)object withError:(NSError * __autoreleasing *)error;

@end
