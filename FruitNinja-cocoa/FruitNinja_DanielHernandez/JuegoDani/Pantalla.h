//
//  Pantalla.h
//  JuegoDani
//
//  Created by daniel hernandez on 30/10/2019.
//  Copyright © 2019 daniel hernandez. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainControlador.h"

@interface Pantalla : NSView{
    IBOutlet __weak MainControlador *controlador;
    NSPoint click;
}

- (void)mouseDown:(NSEvent *)theEvent;

@end

