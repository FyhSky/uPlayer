//
//  AppDelegate.m
//  uPlayer
//
//  Created by liaogang on 15/1/27.
//  Copyright (c) 2015年 liaogang. All rights reserved.
//

#import "AppDelegate.h"
#import "UPlayer.h"
#import "PlayerMessage.h"
#import "serialize.h"

@interface AppDelegate ()

@end



@implementation AppDelegate
- (IBAction)cmdOpenDirectory:(id)sender
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    [openDlg setCanChooseDirectories: YES ];
    [openDlg setAllowsMultipleSelection:NO];
    
    NSString *initPath = NSSearchPathForDirectoriesInDomains( NSMusicDirectory, NSUserDomainMask, false).firstObject;
    
    if ( [openDlg runModalForDirectory:initPath file:nil] == NSOKButton )
    {
        NSArray* files = [openDlg filenames];
        if (files.count > 0) {
            NSString* fileName = files.firstObject;
            
            PlayerDocument *document = player().document;
            PlayerList *list = [document.playerlList getSelectedList];
            list.playerTrackList = enumAudioFiles(fileName);
            
            postEvent(EventID_to_reload_tracklist, nil);
        }
    }
    
}

- (IBAction)cmdFind:(id)sender
{
    NSLog(@"command: Find");

}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [player().document load];
    postEvent(EventID_to_reload_tracklist, nil);
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [player().engine stop];
    
    [player().document save];
}

@end