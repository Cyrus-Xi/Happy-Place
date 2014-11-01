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

@interface CXComplimentDetailViewController : UIViewController

@property (nonatomic) NSString *complimentText;
@property (nonatomic) NSInteger indexCompliment;
@property (nonatomic) NSMutableArray *complimentItems;
//@property (nonatomic, getter=isEditing) BOOL editing;
//@property (nonatomic, strong) NSLayoutConstraint *constraint;
@property CXComplimentItem *complimentItem;
//@property NSMutableArray *complimentItems;
//@property CXComplimentListTableViewController *ex;


@end
