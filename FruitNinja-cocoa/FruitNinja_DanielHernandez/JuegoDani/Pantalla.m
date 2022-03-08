//
//  Pantalla.m
//  JuegoDani
//
//  Created by daniel hernandez on 30/10/2019.
//  Copyright © 2019 daniel hernandez. All rights reserved.
//

#import "Pantalla.h"
#import "MainControlador.h"


extern NSString * notAControlador;


#define XDIMENSION 400
#define YDIMENSION 400
#define MAXDIMENSION 200

//                              X           Y           anchura   Heithg:altura
static NSRect funcObjec = {-XDIMENSION,-YDIMENSION,2*XDIMENSION,2*YDIMENSION};

@implementation Pantalla

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }

    return self;
}
- (void)drawRect:(NSRect)dirtyRect {

    [super drawRect:dirtyRect];
    NSRect bounds = [self bounds];
    NSGraphicsContext * ctx = [NSGraphicsContext currentContext];
    NSImage *fondo=[NSImage imageNamed:@"fondo2.png"];
    dirtyRect.size=[fondo size];
    [fondo  drawInRect:[self bounds]
                fromRect:dirtyRect
               operation:NSCompositingOperationSourceOver
                fraction:1.0];
    
    [controlador dibujarObjetos:bounds
                withGraphicsContext:ctx];
    
}

- (void)mouseDown:(NSEvent *)theEvent {
    NSRect bounds = [self bounds];
    NSPoint new;
    click = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    /*
     *Transformación afín de la vista que creamos para representar los ejes
     *invertida para conseguir las coordenadas x e y
     *punto 0,0 en el medio
     *de la ventana y no en la esquina inferior izquierda.
    */
    
    NSAffineTransform *tf = [NSAffineTransform transform];
    tf = [NSAffineTransform transform];
    [tf translateXBy:bounds.size.width/2
                 yBy:bounds.size.height/2];
    [tf scaleXBy:bounds.size.width/funcObjec.size.width
             yBy:bounds.size.height/funcObjec.size.height];
    [tf invert];
    new = [tf transformPoint:click];
    
    NSNumber *Xleyend = [[NSNumber alloc]initWithFloat:new.x];
    NSNumber *Yleyend = [[NSNumber alloc]initWithFloat:new.y];
    NSDictionary *notificationInfo=[NSDictionary dictionaryWithObjectsAndKeys: Xleyend,@"EjeX",
                        Yleyend,@"EjeY",
                        nil];
    
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:notAControlador
                      object:self
                    userInfo:notificationInfo];
    
}


@end
