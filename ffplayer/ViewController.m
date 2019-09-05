//
//  ViewController.m
//  ffplayer
//
//  Created by Peng Dongfeng on 2019/8/15.
//  Copyright © 2019 Peng Dongfeng. All rights reserved.
//

#import "ViewController.h"
#include "../progressbar/progressbar.h"
#include "../ffplay/ffplay.h"

extern char* m_filename[256];
progressbar *m_pProgressBar = NULL;

NSTimer *playProcessTimerID;
NSTimer *playTimerID;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
- (void)playTimerAction:(NSTimer*)timer;
{
    int ret = ffplay_play(NULL);
    if (ret == 0)  printf("file comes to end, goodbye~");
    else if (ret == -1) printf("you stop this file playing, goodbye~");
    else printf("playing error, will pass play this file.");
    [self buttonStopPlay:nil];
}
- (void)playProcessTimerAction:(NSTimer*)timer
{
    double curTime   = 0.0;
    int    totalTime = 0;
    totalTime = ffplay_get_stream_totaltime();
    curTime = ffplay_get_stream_curtime();

    if ((totalTime >= 1) && !isnan(curTime))
    {
        if (NULL == m_pProgressBar)
        {
            static char buf[20];
            int seconds = totalTime;
            int hours = seconds / 3600;
            seconds -= hours * 3600;
            int minutes = seconds / 60;
            seconds -= minutes * 60;
            sprintf(buf, "%02d:%02d", minutes, seconds);
            m_pProgressBar = progressbar_new(buf, 100);
        }
        else
        {
            //wstring current_lyric{ m_lyrics.GetLyric(Time((int)curTime*1000+999), 0).text };
            //string lyric_str = CCommon::UnicodeToStr(current_lyric, CodeType::ANSI, false);
            m_pProgressBar->currentTime = (unsigned long)curTime;
            m_pProgressBar->leftTime = (unsigned long)(totalTime - curTime);
            progressbar_update(m_pProgressBar, (unsigned long)(curTime * 100 / totalTime), (char*)"");
        }
    }
}

char ChOpenFile[256] = {0};

- (IBAction)buttonPlay:(id)sender {
    if (0 == ffplay_init(m_filename[0], 400, 300))
    {
        ViewController *processTimer = [[ViewController alloc] init];
        ViewController *playTimer = [[ViewController alloc] init];
        
        playProcessTimerID = [NSTimer scheduledTimerWithTimeInterval:1 target:processTimer selector:@selector(playProcessTimerAction:) userInfo:nil repeats:YES];
        playTimerID = [NSTimer scheduledTimerWithTimeInterval:1 target:playTimer selector:@selector(playTimerAction:) userInfo:nil repeats:NO];
    }
    
}
- (IBAction)buttonOpenFile:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:YES];
    
    NSInteger clicked = [panel runModal];
    
    if (clicked == NSFileHandlingPanelOKButton) {
        for (NSURL *url in [panel URLs]) {
            // do something with the url here.
            //m_filename[0] = [url UTF8String];
            NSString *nsOpenFile = [[panel URL] path];
            const char *pChOpenFilePath = [nsOpenFile UTF8String];
            char *pChOpenFile = ChOpenFile;
            while ((*pChOpenFile++ = *pChOpenFilePath++) != '\0');
            m_filename[0] = ChOpenFile;

        }
    }
}
- (IBAction)buttonStopPlay:(id)sender {
    [playTimerID invalidate];
    playTimerID = nil;
    [playProcessTimerID invalidate];
    playProcessTimerID = nil;
    ffplay_stop();
    if (m_pProgressBar)
    {
        progressbar_finish(m_pProgressBar);
        m_pProgressBar = NULL;
    }
}

@end
