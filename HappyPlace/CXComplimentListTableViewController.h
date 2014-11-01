//
//  CXComplimentListTableViewController.h
//  HappyPlace
//
//  Created by Cyrus Xi on 9/11/14.
//  Copyright (c) 2014 ___SURYC11___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXComplimentItem.h"

@interface CXComplimentListTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSString *listPath;
    NSMutableArray *listCompliments;
    
}

@property NSMutableArray *complimentItems;
@property CXComplimentItem *complimentItem;
@property NSInteger index;
@property NSString *complimentDetail;
@property NSDate *lastDate;
@property NSMutableArray *listDates;

- (IBAction)writeToFile:(id)sender;

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

- (IBAction)unwindAndUpdate:(UIStoryboardSegue *)segue;

@end
