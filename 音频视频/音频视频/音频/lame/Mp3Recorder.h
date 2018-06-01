//
//  Mp3Recorder.h
//  Created by huafeng on 16/5/31.
//  Copyright © 2016年 super. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Mp3Recorder;
@protocol Mp3RecorderDelegate <NSObject>
- (void)failRecord;
- (void)beginConvert;
- (void)recordingMp3Recorder:(Mp3Recorder *)mp3Recorder recordTime:(float)recordTime volume:(float)volume;
- (void)endConvertWithData:(NSData *)data path:(NSString *)path;
@end

@interface Mp3Recorder : NSObject{
    double lowPassResults;
    float recordTime;
    NSTimer *playTimer;
}
@property (nonatomic, weak) id<Mp3RecorderDelegate> delegate;

- (id)initWithDelegate:(id<Mp3RecorderDelegate>)delegate fileName:(NSString *)fileName;
- (void)startRecord;
- (void)stopRecord;
- (void)cancelRecord;

- (NSString *)getOrigPath;
- (NSString *)getMp3Path;
@end
