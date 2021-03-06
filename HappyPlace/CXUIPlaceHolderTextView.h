//
//  CXUIPlaceHolderTextView.h
//  HappyPlace
//
//  Created by Cyrus Xi on 9/11/14.
//  Copyright (c) 2014 ___SURYC11___. All rights reserved.
//
//  From the top answer here: http://stackoverflow.com/questions/1328638/placeholder-in-uitextview
//

#import <Foundation/Foundation.h>

@interface CXUIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
