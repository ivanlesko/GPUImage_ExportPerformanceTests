



#import "SimpleVideoFileFilterViewController.h"
#import "RenderParameter.h"

@implementation SimpleVideoFileFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.renderQueue = [self createRenderQueueArray];
    
    [self exportVideoInRenderQueue:self.renderQueue];
}

- (NSMutableArray *)createRenderQueueArray {
    GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
    exposureFilter.exposure = 0.0;
    
    GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
    contrastFilter.contrast = 1.05;
    
    GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    brightnessFilter.brightness = 0.1;
    
    GPUImageHueFilter *hueFilter = [[GPUImageHueFilter alloc] init];
    
    GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
    sepiaFilter.intensity = 1.0;
    
    GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
    saturationFilter.saturation = 1.05;
    
    NSValue *size1 = [NSValue valueWithCGSize:CGSizeMake(480, 270)];
    NSValue *size2 = [NSValue valueWithCGSize:CGSizeMake(640, 360)];
    NSValue *size3 = [NSValue valueWithCGSize:CGSizeMake(720, 405)];
    NSValue *size4 = [NSValue valueWithCGSize:CGSizeMake(1080, 608)];
    NSValue *size5 = [NSValue valueWithCGSize:CGSizeMake(1600, 900)];
    NSValue *size6 = [NSValue valueWithCGSize:CGSizeMake(1920, 1080)];
    
    NSArray *numberOfFilters = @[@(1), @(5), @(10), @(20), @(50), @(75)];
    NSArray *filterTypes = @[exposureFilter, contrastFilter, brightnessFilter, hueFilter, sepiaFilter, saturationFilter];
    NSArray *videoSizes = @[size1, size2, size3, size4, size5, size6];
    
    NSMutableArray *parameters = [NSMutableArray array];
    
    for (int i = 0; i < numberOfFilters.count; i++) {
        for (int j = 0; j < numberOfFilters.count; j++) {
            RenderParameter *param = [RenderParameter videoExportSettingsFromNumberOfFilters:numberOfFilters[j]
                                                                                  filterType:filterTypes[i]
                                                                                   videoSize:[videoSizes[i] CGSizeValue]];
            [parameters addObject:param];
        }
    }
    
    return parameters;
}

- (void)exportVideoInRenderQueue:(NSMutableArray *)queue {
    if (self.renderQueue.count) {
        if ([[self.renderQueue lastObject] isKindOfClass:[RenderParameter class]]) {
            RenderParameter *param = [self.renderQueue firstObject];
            
            NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"sampleMovie" withExtension:@"MOV"];
            
            movieFile = [[GPUImageMovie alloc] initWithURL:sampleURL];
            movieFile.runBenchmark = YES;
            movieFile.playAtActualSpeed = NO;
            filter = [[GPUImagePixellateFilter alloc] init];
            
            [movieFile addTarget:filter];
            
            // Only rotate the video for display, leave orientation the same for recording
            GPUImageView *filterView = (GPUImageView *)self.view;
            [filter addTarget:filterView];
            
            // In addition to displaying to the screen, write out a processed version of the movie to disk
            NSString *movieName   = [NSString stringWithFormat:@"/sampleMovie_%.0fx%.0f_%d-filters.MOV", param.size.width, param.size.height, param.numberOfFilters.intValue];
            NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            pathToMovie = [pathToMovie stringByAppendingString:movieName];
//            NSLog(@"%@", pathToMovie);
            
            NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
            
            [self.renderQueue removeObject:param];
            [self exportVideoInRenderQueue:self.renderQueue];
            
            movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:param.size];
            [filter addTarget:movieWriter];
            
            //        [movieWriter startRecording];
            //        [movieFile startProcessing];
            //
            //        timer = [NSTimer scheduledTimerWithTimeInterval:0.3f
            //                                                 target:self
            //                                               selector:@selector(retrievingProgress)
            //                                               userInfo:nil
            //                                                repeats:YES];
            //
            //        [movieWriter setCompletionBlock:^{
            //            [filter removeTarget:movieWriter];
            //            [movieWriter finishRecording];
            //
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                [timer invalidate];
            //            });
            //        }];
        }
    }
}

- (void)retrievingProgress
{
    self.progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(movieFile.progress * 100)];
}

- (void)viewDidUnload
{
    [self setProgressLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)updatePixelWidth:(id)sender
{
//    [(GPUImageUnsharpMaskFilter *)filter setIntensity:[(UISlider *)sender value]];
    [(GPUImagePixellateFilter *)filter setFractionalWidthOfAPixel:[(UISlider *)sender value]];
}

- (void)dealloc {
    [_progressLabel release];
    [super dealloc];
}
@end
