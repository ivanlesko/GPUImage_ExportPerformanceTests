//
//  RenderParameter.m
//  SimpleVideoFileFilter
//
//  Created by Ivan Lesko on 5/30/14.
//  Copyright (c) 2014 Cell Phone. All rights reserved.
//

#import "RenderParameter.h"

@implementation RenderParameter

+ (RenderParameter *)videoExportSettingsFromNumberOfFilters:(NSNumber *)num
                                                 filterType:(GPUImageFilter *)filterType
                                                  videoSize:(CGSize)size {
    RenderParameter *newParameter = [[RenderParameter alloc] init];
    newParameter.numberOfFilters = num;
    newParameter.filterType      = filterType;
    newParameter.size            = size;
    
    newParameter.filter = [[GPUImageFilterGroup alloc] init];
    
    for (int i = 0; i < num.intValue; i++) {
        
    }
    
    return newParameter;
}

@end
