//
//  Objeto.h
//  JuegoDani
//
//  Created by daniel hernandez on 30/10/2019.
//  Copyright © 2019 daniel hernandez. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Objeto : NSObject
{
    NSString * nombre;
    NSRect objeto;
    float xIncremento, yIncremento;
    int tipo;
}
@property(nonatomic, copy)NSString * nombre;

@property (nonatomic)NSRect objeto;
@property (nonatomic) float xIncremento;
@property (nonatomic) float yIncremento;
@property(nonatomic)int  tipo;

-(id)initFromObjeto:(NSRect) obj
    xIncrement: (float) xInc
     yIncrement: (float) yInc
           tipo:(int )tipo
             nombre:(NSString *)nombre;
-(void)moverObjeto;
+(id)crearObjeto;
-(void) dibujarObjeto: (NSRect)b
      withGraphicsContext:(NSGraphicsContext *)ctx
                 tipo:(int)tipo;
float randomFloat(float Min, float Max);
@end


