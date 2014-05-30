//
//  RenderParameter.h
//  SimpleVideoFileFilter
//
//  Created by Ivan Lesko on 5/30/14.
//  Copyright (c) 2014 Cell Phone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"

@interface RenderParameter : NSObject

/**
 *  Each render parameter contains a filter group that is generated based on its number of filters and filter type.
 */
@property (nonatomic, strong) GPUImageFilterGroup *filter;

/**
 *  The number of filters the Render Parameter will export with.
 */
@property (nonatomic, strong) NSNumber *numberOfFilters;
@property (nonatomic, strong) GPUImageFilter *filterType;
@property (nonatomic)         CGSize size;

+ (RenderParameter *)videoExportSettingsFromNumberOfFilters:(NSNumber *)num
                                                 filterType:(GPUImageFilter *)filterType
                                                  videoSize:(CGSize)size;

@end
