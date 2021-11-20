//
//  HelloWorldWrapper.m
//  BIoStatsScanner
//
//  Created by Kamran on 11/20/21.
//

#import <Foundation/Foundation.h>

#import "HelloWorldWrapper.h"
#import "HelloWorld.hpp"

@implementation HelloWorldWrapper


-(NSString *) sayHello {
    HelloWorld helloWorld;
    std::string helloWorldMessage = helloWorld.sayHello(3, 5);
    return [NSString
            stringWithCString:helloWorldMessage.c_str()
            encoding:NSUTF8StringEncoding];
}

@end
