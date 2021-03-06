//
//  PlayerSerachMng.mm
//  uPlayer
//
//  Created by liaogang on 15/1/27.
//  Copyright (c) 2015年 liaogang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "PlayerSerachMng.h"

@interface PlayerSearchMng ()
@property (nonatomic,strong) NSString *searchKey;
@end

@implementation PlayerSearchMng

-(void)research
{
    [self search:self.searchKey];
}

-(void)search:(NSString *)key
{
    assert(self.playerlistOriginal);
    
    self.searchKey = key;
    
    //search title first.
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.info.title contains[c] %@",key];
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF.info.artist contains[c] %@ ||SELF.info.album contains[c] %@",key,key];
    
    NSMutableArray *dataOld = [_playerlistOriginal.playerTrackList mutableCopy] ;
    
    NSMutableArray *dataNew = [ NSMutableArray array];
    [dataNew addObjectsFromArray: [dataOld filteredArrayUsingPredicate:predicate]];
    
    [dataOld removeObjectsInArray: dataNew];
    
    [dataNew addObjectsFromArray:[dataOld filteredArrayUsingPredicate: predicate2]];
    
    if(!_dicFilterToOrginal)
        _dicFilterToOrginal = [NSMutableDictionary dictionary];
        
    int i = 0;
    for (PlayerTrack *track in dataNew)
    {
        NSNumber *numNew = [NSNumber numberWithInt:i];
        
        self.dicFilterToOrginal[numNew] = track;
        i++;
    }
    
    if(!_playerlistFilter)
        _playerlistFilter = [[PlayerList alloc]init];
    
    _playerlistFilter.playerTrackList = dataNew;
    
}

-(PlayerTrack*)getOrginalByIndex:(NSInteger)index
{
    NSNumber *numNew = [NSNumber numberWithInteger:index];
    return (PlayerTrack*) self.dicFilterToOrginal[numNew];
}

@end
