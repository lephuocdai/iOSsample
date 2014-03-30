//
//  PAPImageView.h
//  Anypic
//
//  Created by Mattieu Gamache-Asselin on 5/14/12.
//

@interface PAPImageView : UIImageView

@property (nonatomic, strong) UIImage *placeholderImage;

- (void) setFile:(PFFile *)file;

@end
