//
//  Wall.m
//  APITest
//
//  Created by Admin on 07.10.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//






#import "Wall.h"

@implementation Wall

- (id)initWithServerResponse:(NSDictionary *) responseObject;
{
    self = [super init];
    if (self) {
        
        self.text = [responseObject objectForKey:@"text"];
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:@"dd MMM yyyy "];
        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[[responseObject objectForKey:@"date"] floatValue]];
        NSString *date = [dateFormater stringFromDate:dateTime];
        self.date = date;
        
        // If posted directly from user
        
        if ([responseObject objectForKey:@"copy_history"] == nil) {
            
            
            NSArray *array = [responseObject objectForKey:@"attachments"];
            
            // Is post a photo?
            
            if ([[[array objectAtIndex:0]objectForKey:@"type"] isEqualToString:@"photo"]) {
                
                
                NSDictionary *dictTemp = [[array objectAtIndex:0]objectForKey:@"photo"];
                
                NSString* urlString = [dictTemp objectForKey:@"photo_604"];
                
                if (urlString) {
                    self.postImageURL = [NSURL URLWithString:urlString];
                }
            }
            
            // Is post a video?
            
            if ([[[array objectAtIndex:0]objectForKey:@"type"] isEqualToString:@"video"]) {
                
                
                NSDictionary *dictTemp = [[array objectAtIndex:0]objectForKey:@"video"];
                
                NSString* urlString = [dictTemp objectForKey:@"photo_320"];
                
                if (urlString) {
                    self.postImageURL = [NSURL URLWithString:urlString];
                }
            }
            
            // Is post a link?
            
            if ([[array objectAtIndex:0]objectForKey:@"link"] != nil) {
                
                
                NSDictionary *dictTemp = [[array objectAtIndex:0]objectForKey:@"link"];
                
                NSDictionary *dictPhoto = [dictTemp objectForKey:@"photo"];
                
                NSString* urlString = [dictPhoto objectForKey:@"photo_604"];
                
                if (urlString) {
                    self.postImageURL = [NSURL URLWithString:urlString];
                }
            }
        }
        // If post - repost from another user/group.
        
        else {
            
            // Parsing for photo of shared post.
            
            NSArray *array = [responseObject objectForKey:@"copy_history"];
            
            NSDictionary* tempDict = [array objectAtIndex:0];
            
            NSArray* attachArray = [tempDict objectForKey:@"attachments"];
            
            NSDictionary* tempAttachDict = [attachArray objectAtIndex:0];
    
            
            if ([[tempAttachDict objectForKey:@"type"] isEqualToString:@"video"]) {
                
                NSDictionary *dictTemp = [tempAttachDict objectForKey:@"video"];
                
                NSString* urlString = [dictTemp objectForKey:@"photo_320"];
                
                if (urlString) {
                    self.postImageURL = [NSURL URLWithString:urlString];
                }
                
                
                
            } else {
                
                NSDictionary* photoDict = [tempAttachDict objectForKey:@"photo"];
                
                NSString* urlString = [photoDict objectForKey:@"photo_604"];
                
                if (urlString) {
                    self.postImageURL = [NSURL URLWithString:urlString];
                }
            }
        }   
    }
    return self;
}

@end
