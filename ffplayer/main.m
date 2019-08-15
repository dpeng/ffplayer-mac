//
//  main.m
//  ffplayer
//
//  Created by Peng Dongfeng on 2019/8/15.
//  Copyright © 2019 Peng Dongfeng. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "../progressbar/progressbar.h"
#include "../ffplay/ffplay.h"
#include <pthread.h>

void *progressbarThread(void *vargp)
{
    progressbar *m_pProgressBar = NULL;
    
    double curTime   = 0;;
    int    totalTime = 0;
    int    trytime   = 0;
    while(totalTime <= 1 && trytime <= 10)
    {
        usleep(1000000);
        totalTime = ffplay_get_stream_totaltime();
        curTime = ffplay_get_stream_curtime();
        trytime++;
    }
    while(totalTime - curTime > 1)
    {
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
        usleep(999999);
    }
    
    return NULL;
}

int main(int argc, const char * argv[]) {
    ffplay_toggle_set_init_volume(50);
    char* filename[256];
    for (int i = 1; i<argc; i++)
    {
        filename[i-1] = argv[i];
    }

    if (0 == ffplay_init(filename[0], 400, 300))
    {
        pthread_t progressbarThread_id;
        pthread_create(&progressbarThread_id, NULL, progressbarThread, NULL);
        pthread_join(progressbarThread_id, NULL);
        int ret = ffplay_play(pthread_self());
        if (ret == 0)  //indicate that this file play comes to an end
        {
            pthread_detach( progressbarThread_id );
            return NULL;
        }
        else printf("playing error, will pass play this file.");
    }
    
    printf("Hello, World!\n");
    return NSApplicationMain(argc, argv);
}
