//
//  PAPProfileImageView.h
//  Anypic
//
//  Created by Mattieu Gamache-Asselin on 5/17/12.
//

@class PFImageView;
@interface PAPProfileImageView : UIView

@property (nonatomic, strong) UIButton *profileButton;
@property (nonatomic, strong) PFImageView *profileImageView;

- (void)setFile:(PFFile *)file;

@end
