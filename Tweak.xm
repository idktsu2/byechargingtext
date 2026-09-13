// ByeAnnoyingChargingText
// Oculta el texto "X% de carga" / "X% Charged" que aparece en la
// lockscreen al conectar el cargador con el teléfono encendido.
//
// Intentamos varias clases candidatas porque el nombre exacto puede
// variar según el firmware. Logos ignora silenciosamente el %hook
// de una clase que no existe en runtime, así que esto es seguro:
// no vas a crashear el SpringBoard si alguna de estas clases no
// aplica en tu iOS 15.8.8.

#import <UIKit/UIKit.h>

// Declaramos las superclases de estas clases privadas para que el
// compilador sepa qué propiedades/métodos heredan (UIView, UIViewController,
// UILabel). Sin esto, Logos las trata como "forward class" vacías y
// self.hidden / self.alpha / self.view no compilan.
@interface _SBLockScreenSingleBatteryChargingView : UIView
@end

@interface SBDashBoardChargingViewController : UIViewController
@end

@interface SBFLockScreenDateSubtitleDateView : UILabel
@end

// --- Candidato 1: vista dedicada de "cargando" en la lockscreen clásica ---
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

// --- Candidato 2: view controller del dashboard que gestiona el estado de carga ---
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

// --- Candidato 3 (fallback): buscamos el label del subtítulo de fecha/carga ---
// En builds notch/Face ID, el texto de carga a veces vive dentro del
// subtitle view que normalmente muestra la fecha bajo el reloj.
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

// --- Candidato 4 (red de seguridad): cualquier UILabel con ese texto ---
// Este hook es el más amplio: intercepta el texto en el momento en que
// CUALQUIER UILabel de SpringBoard lo recibe, sin importar en qué clase
// esté envuelto. Debería atrapar el label sí o sí, y de paso el NSLog
// nos dice el nombre real de la clase contenedora para poder limpiar
// el tweak después.
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
