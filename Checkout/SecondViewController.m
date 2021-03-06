//
//  SecondViewController.m
//  Checkout
//
//  Created by Kevin Song on 6/15/13.
//  Copyright (c) 2013 Kevin Song. All rights reserved.
//

#import "SecondViewController.h"
#import "AppDelegate.h"
#import "Item.h"
#import "iToast.h"
#import "RedLaserOverlayViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

NSString * itemName;
NSString * itemPrice;
NSString * itemDescription;
NSString * itemId;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    NSLog(@"View Loaded!");

}

- (void)viewDidAppear:(BOOL)animated
{    
    NSLog(@"View appeared");

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) barcodePickerController:(BarcodePickerController*)picker
                   returnResults:(NSSet *)results
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissModalViewControllerAnimated:TRUE];
    
    //NSLog(@"%@", [[results anyObject] barcodeString]);

    NSString *requestString = [NSString stringWithFormat:@"http://simpligro.com/api/item.json?upc=%@", [[results anyObject] barcodeString]];
    
    NSLog(requestString);
    
    NSString *jsonString = [NSString stringWithContentsOfURL:[NSURL URLWithString:requestString] encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"%@", jsonString);
    
    NSError *e = nil;
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    
    NSLog(@"%@", data);
    
    itemName = [JSON objectForKey:@"name"];
    itemDescription = [JSON objectForKey:@"description"];
    itemId = [JSON objectForKey:@"id"];
    NSString *itemPriceString = [JSON objectForKey:@"cost"];
    float cost = [itemPriceString floatValue];
    
    cost = cost / 100;
    
    itemPrice = [NSString stringWithFormat:@"$%.2f", cost];
    
    NSLog(@"%@", itemName);
    NSLog(@"%@", itemPrice);
    
    NSString *description = [NSString stringWithFormat:@"%@\n%@", itemDescription, itemPrice];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: itemName message: description delegate: self cancelButtonTitle:@"Close" otherButtonTitles:@"Add to Cart", nil];
    [alert show];
}

- (IBAction)scanBtn {
    
    BarcodePickerController *picker = [[BarcodePickerController alloc] init];
    // Let's keep things simple by using the default built-in overlay
    [picker setOverlay:[[RedLaserOverlayViewController alloc] init]];
    
    [picker setDelegate:self];
    picker.orientation = UIImageOrientationUp;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self presentModalViewController:picker animated:TRUE];
    //[picker release];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
        NSLog(@"user pressed Close");
        
    } else {
        
        NSLog(@"User pressed Add to Cart");
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString *postString = [[NSString alloc] initWithFormat:@"http://simpligro.com/api/transaction_item_add.json?transaction_id=%@&item_id=%@", appDelegate.currentCartId,itemId];
        
        NSLog(@"%@", postString);
        
        NSString* postResult = [NSString stringWithContentsOfURL:[NSURL URLWithString:postString] encoding:NSUTF8StringEncoding error:nil];
        
        NSLog(@"%@", appDelegate.currentCart);
        
        NSString *transactionItemId = [postResult stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        NSLog(@"%@", transactionItemId);
        
        [appDelegate.currentCart addObject: [[Item alloc] initWithItemId:itemId withTransactionItemId:transactionItemId withName:itemName withDescription:itemDescription withPrice:itemPrice]];
        
        
        NSString *subTotalString = [[NSString alloc] initWithFormat:@"http://simpligro.com/api/transaction_subtotal.json?id=%@", appDelegate.currentCartId];
        NSString* subTotalResult = [NSString stringWithContentsOfURL:[NSURL URLWithString:subTotalString] encoding:NSUTF8StringEncoding error:nil];
        subTotalResult = [subTotalResult stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        NSLog(@"subTotalResult: %@", subTotalResult);
        
        float subTotalFloat = [subTotalResult floatValue];
        
        subTotalFloat = subTotalFloat / 100;
        
        subTotalResult = [NSString stringWithFormat:@"%.2f", subTotalFloat];
        
        appDelegate.subTotal = subTotalResult;
        
        [[[[iToast makeText:NSLocalizedString(@"Added to Cart", @"")]
           setGravity:iToastGravityBottom] setDuration:iToastDurationShort] show];
    }
}

@end
