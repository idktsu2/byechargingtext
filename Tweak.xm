

#import <UIKit/UIKit.h>


@interface _SBLockScreenSingleBatteryChargingView : UIView
@end

@interface SBDashBoardChargingViewController : UIViewController
@end

@interface SBFLockScreenDateSubtitleDateView : UILabel
@end


%hook _SBLockScreenSingleBatteryChargingView

- (void)layoutSubviews {
	%orig;
	self.hidden = YES;
	self.alpha = 0.0;
}

- (void)setBatteryVisible:(BOOL)visible {
	%orig(NO);
}

%end


%hook SBDashBoardChargingViewController

- (void)viewDidLoad {
	%orig;
	self.view.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
	%orig;
	self.view.hidden = YES;
}

%end


%hook SBFLockScreenDateSubtitleDateView

- (void)setText:(NSString *)text {
	if ([text containsString:@"%"] &&
		([text localizedCaseInsensitiveContainsString:@"carga"] ||
		 [text localizedCaseInsensitiveContainsString:@"charg"])) {
		%orig(@"");
	} else {
		%orig;
	}
}

%end


%hook UILabel

- (void)setText:(NSString *)text {
	if (text.length &&
		[text containsString:@"%"] &&
		([text localizedCaseInsensitiveContainsString:@"carga"] ||
		 [text localizedCaseInsensitiveContainsString:@"charg"])) {
		NSLog(@"[ByeAnnoyingChargingText] label encontrado -> clase: %@ | texto original: %@",
			  NSStringFromClass([self class]), text);
		%orig(@"");
		return;
	}
	%orig;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
	NSString *plain = attributedText.string;
	if (plain.length &&
		[plain containsString:@"%"] &&
		([plain localizedCaseInsensitiveContainsString:@"carga"] ||
		 [plain localizedCaseInsensitiveContainsString:@"charg"])) {
		NSLog(@"[ByeAnnoyingChargingText] attributedLabel encontrado -> clase: %@ | texto original: %@",
			  NSStringFromClass([self class]), plain);
		%orig(nil);
		return;
	}
	%orig;
}

%end

%ctor {
	%init;
}
