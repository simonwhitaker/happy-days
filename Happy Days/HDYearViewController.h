//
//  HDYearViewController.h
//  Happy Days
//
//  Created by Simon Whitaker on 22/01/2014.
//  Copyright (c) 2014 Netcetera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDDataController.h"

@interface HDYearViewController : UICollectionViewController

@property (nonatomic) NSInteger year;
@property (nonatomic) HDDataController *dataController;

@end
