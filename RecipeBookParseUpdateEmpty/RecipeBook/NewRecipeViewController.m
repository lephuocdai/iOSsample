//
//  NewRecipeViewController.m
//  RecipeBook
//
//  Created by Simon on 10/8/13.
//
//

#import "NewRecipeViewController.h"
#import <Parse/Parse.h>

@interface NewRecipeViewController ()
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *prepTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *ingredientsTextField;

@end

@implementation NewRecipeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _nameTextField.delegate = self;
    _prepTimeTextField.delegate = self;
    _ingredientsTextField.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate


- (IBAction)save:(id)sender {
    // Create PFObject with recipe information
    PFObject *recipe = [PFObject objectWithClassName:@"Recipe"];
    [recipe setObject:_nameTextField.text forKey:@"name"];
    [recipe setObject:_prepTimeTextField.text forKey:@"prepTime"];
    
    NSArray *ingredients = [_ingredientsTextField.text componentsSeparatedByString:@","];
    [recipe setObject:ingredients forKey:@"ingredients"];
    
    // Recipe image
    NSData *imageData = UIImageJPEGRepresentation(_recipeImageView.image, 0.8);
    NSString *filename = [NSString stringWithFormat:@"%@.png", _nameTextField.text];
    PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
    [recipe setObject:imageFile forKey:@"imageFile"];
    
    // Show progress
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = @"Uploading";
    [hud show:YES];
    
    // Uploading recipe to Parse
    [recipe saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [hud hide:YES];
        
        if (!error) {
            // Show success message
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the recipe" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            // Notify table view to reload the recipes from Cloud
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            
            // Dismiss the controller
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload {
    [self setRecipeImageView:nil];
    [self setNameTextField:nil];
    [self setPrepTimeTextField:nil];
    [self setIngredientsTextField:nil];
    [super viewDidUnload];
}


#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)showPhotoLibrary {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return;
    }
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Display saved pictures from the Camera Roll album
    mediaUI.mediaTypes = @[(NSString*)kUTTypeImage];
    
    // Hide the controls for moving & scaling pictures
    mediaUI.allowsEditing = NO;
    
    mediaUI.delegate = self;
    
    [self.navigationController presentModalViewController:mediaUI animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self showPhotoLibrary];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    self.recipeImageView.image = originalImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}




@end








