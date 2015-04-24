//
//  PlayerImpl.mm
//  uPlayer
//
//  Created by liaogang on 15/1/27.
//  Copyright (c) 2015年 liaogang. All rights reserved.
//

#import "PlayerTrack.h"
#import "id3Info.h"

#import "fileCtrl.h"
#import "threadpool.h"

#import "UPlayer.h"
#import "PlayerMessage.h"
#import "PlayerError.h"

#import "PlayerSerialize.h"


TrackInfo* getId3Info(NSString *filename)
{
    TrackInfo* at = [[TrackInfo alloc]init];
    
    NSMutableData *image = nil;
    NSMutableString *artist = [NSMutableString string];
    NSMutableString *title = [NSMutableString string];
    NSMutableString *album = [NSMutableString string];
    NSMutableString *genre = [NSMutableString string];
    NSMutableString *year = [NSMutableString string];
    NSMutableString *lyrics = [NSMutableString string];
    
    if (! getId3FromAudio([NSURL fileURLWithPath:filename], image, album, artist, title, lyrics ,genre,year) )
    {
        return nil;
    }
    
   
    at.artist = artist;
    at.title = title;
    at.album = album;
    at.lyrics = lyrics;
    at.genre = genre;
    at.year = year;
//    at.image = [[NSImage alloc] initWithData:image];
    
    if([at.genre isEqualToString:@"null"])
        at.genre=@"";
    
    
    return at;
}



void* addJobIsFileAudio(const char * file ,void *arg)
{
    NSMutableArray *array = (__bridge NSMutableArray*)arg;
    
    TrackInfo *arti = getId3Info([NSString stringWithUTF8String:file]);
    
    if (arti) {
        arti.path = [NSString stringWithUTF8String:file];
        
        [array addObject:arti];
    }
    
    return nil;
}


NSArray* enumAudioFiles(NSString* path)
{
    NSMutableArray *array = [NSMutableArray array];
    
    pool_init(8);
    
    IterFiles(std::string (path.UTF8String ), std::string (path.UTF8String ), addJobIsFileAudio, (__bridge void*)array );
    
    pool_destroy();
    
    return array;
}



@implementation PlayerEngine (playTrack)
-(void)playTrackInfo:(PlayerTrack*)track pauseAfterInit:(BOOL)pfi
{
    NSString *path = track.info.path;
    
   if ([[NSFileManager defaultManager] fileExistsAtPath: path])
   {
       player().playing = track;
       [self playURL:[NSURL fileURLWithPath: path] pauseAfterInit:pfi];
   }
    else
        postEvent(EventID_play_error_happened, [PlayerError errorNoSuchFile: path]);
    
}
@end


void playTrack(PlayerTrack *track)
{
    if (track)
    {
        player().playing = track;
        
        [player().engine playTrackInfo:track pauseAfterInit: FALSE ];
    }
    
}

void playTrackPauseAfterInit(PlayerList *list,PlayerTrack *track)
{
    if (track)
        [player().engine playTrackInfo:track pauseAfterInit: TRUE ];
}

void collectInfo(PlayerDocument *d , PlayerEngine *e)
{
    PlayStateTime st = [e close];
    d.playTime = st.time;
    d.playState = st.state;
    d.volume = st.volume;
}




@implementation PlayerDocument (documentLoaded)

-(void)willSave
{
    PlayerTrack *track = player().playing;
    self.playingIndexTrack = (int)track.index;
    self.playingIndexList = (int)[player().document.playerlList getIndex: track.list];
    
    [self.playerlList willSave];
}

-(void)didLoad
{
    [self.playerlList didLoad];
    
    if (self.playingIndexList >= 0 && self.playingIndexTrack >= 0)
        player().playing = [[self.playerlList getItem: self.playingIndexList] getItem: self.playingIndexTrack];
    
}

@end

@implementation PlayerlList (documentLoaded)

-(void)willSave
{
    self.selectIndex =  (int) [self getIndex:self.selectItem];
}

-(void)didLoad
{
    self.selectItem = [self getItem: self.selectIndex];
}

@end
