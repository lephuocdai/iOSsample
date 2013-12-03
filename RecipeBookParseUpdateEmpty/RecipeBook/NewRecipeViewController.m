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








