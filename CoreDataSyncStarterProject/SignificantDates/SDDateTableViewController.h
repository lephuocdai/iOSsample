//
//  SDDateTableViewController.h
//  SignificantDates
//
//  Created by Chris Wagner on 6/1/12.
//

#import <UIKit/UIKit.h>

@interface SDDateTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *dates;
@property (nonatomic, strong) NSString *entityName;

- (IBAction)refreshButtonTouched:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@end
