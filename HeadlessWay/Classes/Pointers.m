//
//  Pointers.m
//  HeadlessWay
//
//  Created by Bobby Crabtree on 12/3/12.
//  Copyright (c) 2012 HeadlessWay. All rights reserved.
//

#import "Pointers.h"
@interface Pointers() {
    NSMutableArray *_pointers;
}
@end

static NSString* POINTER_BUNDLE_FILE = @"Pointers";
static NSString* POINTER_BUNDLE_EXT = @"txt";
static NSString* POINTER_FILE = @"Pointers.txt";

@implementation Pointers

- (NSString*)pointerFilePath
{
    NSArray *dir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[dir objectAtIndex:0] stringByAppendingPathComponent:POINTER_FILE];
}

- (void) initPointers
{
    
    NSString *pointerPath = [self pointerFilePath];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:pointerPath];
    
    // see if pointers file exists
    // if so, load them into array
    // if not, parse bundle file and save them to pointers file
    if (fileExists) {
        NSArray *values = [[NSArray alloc] initWithContentsOfFile:pointerPath];
        for (int i = 0; i < values.count; i++) {
            NSString *pointer = [values objectAtIndex:i];
            pointer = [pointer stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            if ([pointer length] > 0) {
                //NSLog(@"%02d :%@", i, pointer);
                [_pointers addObject:pointer];
            }
        }
        [values release];
    } else {
        NSString *file = [[NSBundle mainBundle] pathForResource:POINTER_BUNDLE_FILE ofType:POINTER_BUNDLE_EXT];
        NSString *fileContents = [NSString stringWithContentsOfFile:file
                                                           encoding:NSUTF8StringEncoding error:NULL];
        NSArray* pointers = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        for (int i = 0; i < pointers.count; i++) {
            NSString *pointer = [pointers objectAtIndex:i];
            pointer = [pointer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if ([pointer length] > 0) {
                //NSLog(@"%02d :%@", i, pointer);
                [_pointers addObject:pointer];
            }
        }
        [_pointers writeToFile:pointerPath atomically:YES];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        _pointers = [[NSMutableArray alloc] init];
        [self initPointers];
    }
    return self;
}

- (void)dealloc
{
    [_pointers release];
    [super dealloc];
}

- (NSString*)nextPointer
{
    if (!_pointers) {
        NSLog(@"Error: pointer not init");
        return @"Error";
    }

    int random = arc4random() % _pointers.count;
    NSString *pointer = [_pointers objectAtIndex:random];
//    NSLog(@"random %d=%@", random, pointer);
    return pointer;
}
@end
