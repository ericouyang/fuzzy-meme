//
//  PayPalViewController.m
//  Checkout
//
//  Created by Kevin Song on 6/16/13.
//  Copyright (c) 2013 Kevin Song. All rights reserved.
//

#import "PayPalViewController.h"

@interface PayPalViewController ()

@end

@implementation PayPalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pay{
 
    //Create a PayPal Payment
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [[NSDecimalNumber alloc] initWithString:@""]; //TODO: GET COST
    payment.currencyCode = @"USD";
    payment.shortDescription = @""; //TODO: GET DESCRIPTION
    
    //Check whether payment is processable
    if (!payment.processable ) {
        //TODO: Handle negative amounts, etc. here
    }
    
    //Test Enviornment. Comment o
    [PayPalPaymentViewController setEnvironment:PayPalEnvironmentNoNetwork];
    
    //unique identifier of user
    NSString *aPayerId = @"TEMPORARY"; //TODO: Get user email (or other identifier)
    
    //Create PaypalPaymentViewController w/ credentials and payerId, PayPal Payment, PayPalPaymentDelegate to handle results
    PayPalPaymentViewController *paymentViewController;
    paymentViewController = [[PayPalPaymentViewController alloc] initWithClientId:@""/*ADD CLIENT ID*/
                                                                    receiverEmail:@""/*Client's Paypal Email*/
                                                                          payerId:aPayerId
                                                                          payment:payment
                                                                         delegate:self];
    
    //present PayPalPaymentViewController
    [self presentViewController: paymentViewController animated:YES completion: nil];
    
}

- (void)veriftyCompletedPayment:(PayPalPayment *)completedPayment {
    //send entire confirmation dictionary
    NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation options:0 error:nil];
    
    //TODO: Send confirmation to server and verify proof of payment
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //start w/ test environemnt. COMMENT OUT BELOW to switch to live
    [PayPalPaymentViewController setEnvironment:PayPalEnvironmentNoNetwork];
    [PayPalPaymentViewController prepareForPaymentUsingClientId: @""];//TODO: ADD CLIENT ID
}


@end