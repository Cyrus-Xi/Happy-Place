//
//  CXComplimentDetailViewController.h
//  HappyPlace
//
//  Created by Cyrus Xi on 9/14/14.
//  Copyright (c) 2014 ___SURYC11___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXComplimentItem.h"
#import "CXComplimentListTableViewController.h"

@interface CXComplimentDetailViewController : UIViewController {
    UITextView *messageTextView;
}

@property (nonatomic) NSString *complimentText;
@property (nonatomic) NSInteger indexCompliment;
@property (nonatomic) NSMutableArray *complimentItems;
@property CXComplimentItem *complimentItem;

@end
