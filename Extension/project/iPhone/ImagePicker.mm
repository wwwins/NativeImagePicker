#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#include "Extension.h"

// UIViewController -> NSObject
@interface ImagePickerDelegate : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain) UIImagePickerController *picker;
@property (nonatomic, retain) UIImageView *imageView;

+ (ImagePickerDelegate *)sharedInstance;

+ (bool)isAvailable;

- (UIImage *)resizeImage:(UIImage *)image Size:(CGSize)size;

@end

@implementation ImagePickerDelegate

@synthesize picker;
@synthesize imageView;

static ImagePickerDelegate *sharedInstance = nil;


extern "C" void sendEvent(int type, const char *data);

+ (ImagePickerDelegate *)sharedInstance {

	if (!sharedInstance) {
		NSLog(@"mm:init");
		sharedInstance = [[ImagePickerDelegate alloc] init];
	}
	return sharedInstance;
}

+ (bool)isAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES;
}

- (void) dealloc {

  [picker release];
  picker = nil;

  [imageView release];
  imageView = nil;

  [super dealloc];

}

/*
- (void)viewDidAppear:(BOOL)animated {

	[super viewDidAppear:animated];

}
*/

- (void)takePhoto {

	NSLog(@"mm:takePhoto");

	if(ImagePickerDelegate.isAvailable) {
    UIView *rootView = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
    if(!self.imageView) {
      self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 250, 250)];
      [rootView addSubview:self.imageView];
    }
    if(!self.picker) {
	    self.picker = [[UIImagePickerController alloc] init];
		  self.picker.delegate = self;
		  self.picker.allowsEditing = YES;
    }
		self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;

		[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self.picker animated:YES completion:NULL];
	}
	else NSLog(@"no camera");
}

- (void)selectPhoto {

	trace("selectPhoto");

    UIView *rootView = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];

    if(!self.imageView) {
      self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 250, 250)];
      [rootView addSubview:self.imageView];
    }

    if(!self.picker) {
      self.picker = [[UIImagePickerController alloc] init];
	    self.picker.delegate = self;
	    self.picker.allowsEditing = YES;
    }
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self.picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	NSLog(@"mm:didFinishPicking");

  self.imageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
	[self.picker dismissViewControllerAnimated:YES completion:NULL];

	sendEvent(1, "didFinishPicking");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

	NSLog(@"mm:cancel");

  [self.picker dismissViewControllerAnimated:YES completion:NULL];

	sendEvent(1, "cancel");
}

- (UIImage *)resizeImage:(UIImage *)image Size:(CGSize)size {

  UIGraphicsBeginImageContext(size);
  [image drawInRect:CGRectMake(0,0,size.width,size.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;

}


@end

namespace extension {


	bool initImagePicker() {

		UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Info"
			message:[NSString stringWithFormat:@"Device has camera:%d", [ImagePickerDelegate isAvailable]]
			delegate:nil
			cancelButtonTitle:@"OK"
			otherButtonTitles: nil];

		[myAlertView show];

		if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			return false;
		}

		return true;
	}

	void takePhoto() {

		[[ImagePickerDelegate sharedInstance] takePhoto];

	}
    
    void selectPhoto() {

		[[ImagePickerDelegate sharedInstance] selectPhoto];

    }
}
