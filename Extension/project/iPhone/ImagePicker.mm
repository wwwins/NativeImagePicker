#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#include "Extension.h"

// UIViewController -> NSObject
@interface ImagePickerDelegate : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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


//#define trace(c) NSLog(@"%s [Line %d] %s", __PRETTY_FUNCTION__, __LINE__, c);

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

// self -> [[[UIApplication sharedApplication] keyWindow] rootViewController]
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

		//[self presentViewController:picker animated:YES completion:NULL];
		[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self.picker animated:YES completion:NULL];
	}
	else NSLog(@"no camera");
}

- (void)selectPhoto {

	//NSLog(@"%s [Line %d] %@", __PRETTY_FUNCTION__, __LINE__, @"selectPhoto");
	trace("selectPhoto");

    UIView *rootView = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];

    if(!self.imageView) {
      self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 250, 250)];
      [rootView addSubview:self.imageView];
    }

    if(!self.picker) {
      self.picker = [[UIImagePickerController alloc] init];
      //picker.delegate = [ImagePickerDelegate sharedInstance];
	    self.picker.delegate = self;
	    self.picker.allowsEditing = YES;
    }
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
	//[self presentViewController:picker animated:YES completion:NULL];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self.picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	NSLog(@"mm:didFinishPicking");

  //UIImage *chosenImage = [self resizeImage:[info objectForKey:UIImagePickerControllerEditedImage] Size:CGSizeMake(250, 250)];
  //UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
  //UIImage *chosenImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	//self.imageView = [[UIImageView alloc] initWithImage: chosenImage];
	//self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
  //self.imageView.image = chosenImage;
  //self.imageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
	//self.imageView.image = [[info objectForKey:UIImagePickerControllerOriginalImage] resizedImageToSize:CGSizeMake(150, 150)];
  //self.imageView.frame = CGRectMake(10, 20, 150, 150);
  //self.imageView.image = chosenImage;
  //self.imageView.image = [self resizeImage:[info objectForKey:UIImagePickerControllerEditedImage] Size:CGSizeMake(150, 250)];
	//[[[UIApplication sharedApplication] keyWindow] addSubview:self.imageView];

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

	//UIWindow *window;

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
/* 下列方法也行
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			UIImagePickerController *picker = [[UIImagePickerController alloc] init];
			picker.delegate = [ImageDelegate sharedInstance];
			picker.allowsEditing = YES;
			picker.sourceType = UIImagePickerControllerSourceTypeCamera;
 
			//[self presentViewController:picker animated:YES completion:NULL];
			// get rootViewController and pass picker
			[[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:picker animated:YES completion:NULL];

			// 或自己手動加入
			//[[[UIApplication sharedApplication] keyWindow] addSubview:picker.view];
		}
		else {
			NSLog(@"Device has no camera");
		}
*/
	}
    
    void selectPhoto() {

		[[ImagePickerDelegate sharedInstance] selectPhoto];
/*
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = [ImageDelegate sharedInstance];
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
		//[self presentViewController:picker animated:YES completion:NULL];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:picker animated:YES completion:NULL];
		//[[[UIApplication sharedApplication] keyWindow] addSubview:picker.view];
*/ 
    }
}
