//
//  FirstViewController.h
//  Checkout
//
//  Created by Kevin Song on 6/15/13.
//  Copyright (c) 2013 Kevin Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView *cartTable;
    IBOutlet UILabel *subTotalLabel;
}

@property (nonatomic, retain) UITableView *cartTable;

@property (nonatomic, retain) UILabel *subTotalLabel;


@end
