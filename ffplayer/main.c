//
//  main.c
//  ffplayer
//
//  Created by Peng Dongfeng on 2019/8/5.
//  Copyright © 2019 Peng Dongfeng. All rights reserved.
//

#include <stdio.h>
#include <unistd.h>
#include "../progressbar/progressbar.h"
#include "../ffplay/ffplay.h"
#import <VideoToolbox/VideoToolbox.h>

int main(int argc, const char * argv[]) {
    // insert code here...
    progressbar *m_pProgressBar;
    m_pProgressBar = NULL;
    static char buf[20];
    int seconds = 253;
    int hours = seconds / 3600;
    seconds -= hours * 3600;
    int minutes = seconds / 60;
    seconds -= minutes * 60;
    sprintf(buf, "%02d:%02d", minutes, seconds);
    m_pProgressBar = progressbar_new(buf, 100);
    //char *filename = "/Users/dpeng/Music/无损/flac流行/晓月老板 - 探清水河.flac";
    ffplay_toggle_set_init_volume(25);
    char* filename[256];
    for (int i = 1; i<argc; i++)
    {
        filename[i-1] = argv[i];
    }
    ffplay_init(filename[0], 100, 200);
    ffplay_play(argv[0]);
    int curTime = 0;
    while(1){
        sleep(1);
        curTime++;
        progressbar_update(m_pProgressBar, (unsigned long)( curTime / 10), (char*)"lyric_str.c_str()");
        if(curTime >= 1)
            break;
    }
    printf("Hello, World!\n");
    return 0;
}
