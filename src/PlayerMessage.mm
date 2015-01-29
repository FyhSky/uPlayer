//
//  UPlayer.m
//  uPlayer
//
//  Created by liaogang on 15/1/27.
//  Copyright (c) 2015年 liaogang. All rights reserved.
//

#import "PlayerMessage.h"


const char *arrEvent[] =
{
    "track_started",
    "track_stopped",
    "track_paused",
    "track_resumed",
    "track_selected",
    "track_progress_changed",
    "playerqueue_changed",
    "to_save_config",
    "to_reload_lyrics",
    "to_center_item",
    "to_change_player_title"
};


NSString *eventIDtoString(enum EventID et)
{
    return [NSString stringWithUTF8String: arrEvent[et]];
}


void addObserverForEvent(id observer , SEL sel, enum EventID et)
{
    NSNotificationCenter *d =[NSNotificationCenter defaultCenter];
    
    [d addObserver:observer selector:sel name: eventIDtoString(et) object:nil];
}

void removeObserverForEvent(id observer , SEL sel, enum EventID et)
{
    NSNotificationCenter *d =[NSNotificationCenter defaultCenter];
    [d removeObserver:observer name:eventIDtoString(et) object:nil];
}

void removeObserver(id observer)
{
    NSNotificationCenter *d =[NSNotificationCenter defaultCenter];
    [d removeObserver:observer];
}


void postEvent(enum EventID et , id object)
{
    NSNotificationCenter *d =[NSNotificationCenter defaultCenter];
    [d postNotificationName: eventIDtoString(et) object:object];
}
