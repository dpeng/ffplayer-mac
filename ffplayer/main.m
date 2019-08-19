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

extern char* m_filename[256];
int main(int argc, const char * argv[]) {
    ffplay_toggle_set_init_volume(50);
    char* filename[256];
    for (int i = 1; i<argc; i++)
    {
        m_filename[i-1] = argv[i];
    }


    
    printf("Hello, World!\n");
    return NSApplicationMain(argc, argv);
}
