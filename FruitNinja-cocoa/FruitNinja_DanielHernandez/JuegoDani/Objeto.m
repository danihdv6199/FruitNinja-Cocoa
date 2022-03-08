//
//  Objeto.m
//  JuegoDani
//
//  Created by daniel hernandez on 30/10/2019.
//  Copyright © 2019 daniel hernandez. All rights reserved.
//

#import "Objeto.h"


@implementation Objeto

#define RANDFLOAT() (random()%128/128.0)
#define XDIMENSION 400
#define YDIMENSION 400
#define MAXDIMENSION 200

//                              X           Y           anchura   Heithg:altura
static NSRect funcObjec = {-XDIMENSION,-YDIMENSION,2*XDIMENSION,2*YDIMENSION};
@synthesize objeto,xIncremento,yIncremento,tipo,nombre;

-(id)initFromObjeto:(NSRect)obj
     xIncrement:(float)xInc
     yIncrement:(float)yInc
           tipo:(int)tipo
             nombre:(NSString *) nombre
{

    self = [super init];
    if(!self){
        return nil;
    }

    //Damos valores a los atributos
    [self setObjeto:obj];
    [self setXIncremento:xInc];
    [self setYIncremento:yInc];
    [self setTipo:tipo];
    [self setNombre:nombre];
    
    return self;
}

-(void)moverObjeto
{
    //Cambio de direccion eje X
  
    if (objeto.origin.x + objeto.size.width >= XDIMENSION
        || objeto.origin.x <= -XDIMENSION)
        xIncremento *= -1;

    objeto.origin.x += xIncremento;
    objeto.origin.y += yIncremento;
    
}
float randomFloat(float Min, float Max){
    return ((arc4random()%RAND_MAX)/(RAND_MAX*1.0))*(Max-Min)+Min;
}

+(id)crearObjeto{
    NSRect elObjeto;
    Objeto *obj;
    int opcionObjeto=rand()%4+1;
    int tamaño=randomFloat(45, 55);
    switch(opcionObjeto){
        case 1:
            elObjeto.origin.x=randomFloat(-310, 310);
            elObjeto.origin.y=420;
            elObjeto.size.width=tamaño;
            elObjeto.size.height=tamaño+10;
            obj=[[Objeto alloc]initFromObjeto:elObjeto
                                xIncrement:randomFloat(-3, 3)//velocidad eje X
                                   yIncrement:randomFloat(-3, -1.3)//velocidad eje Y
                 tipo:1
                                       nombre:@"Manzana"];
            break;
        case 2:
            elObjeto.origin.x=randomFloat(-310, 310);
            elObjeto.origin.y=420;
            elObjeto.size.width=tamaño;
            elObjeto.size.height=tamaño+10;
            obj=[[Objeto alloc]initFromObjeto:elObjeto
                               xIncrement:randomFloat(-3, 3)
                               yIncrement:randomFloat(-3, -1.3)
                 tipo:2
                 nombre:@"Platano"];
            break;
        case 3:
            elObjeto.origin.x=randomFloat(-310, 310);
            elObjeto.origin.y=420;
            elObjeto.size.width=tamaño;
            elObjeto.size.height=tamaño+10;
            obj=[[Objeto alloc]initFromObjeto:elObjeto
                               xIncrement:randomFloat(-3, 3)
                              yIncrement:randomFloat(-3, -1.3)
                 tipo:3
                 nombre:@"Pera"];
            break;
        case 4:
            elObjeto.origin.x=randomFloat(-310, 310);
            elObjeto.origin.y=420;
            elObjeto.size.width=tamaño;
            elObjeto.size.height=tamaño+10;
            obj=[[Objeto alloc]initFromObjeto:elObjeto
                                   xIncrement:randomFloat(-3, 3)
                                   yIncrement:randomFloat(-3, -1.3)
                                         tipo:4
                                       nombre:@"Bomba"];
            break;
        default:
            NSLog(@"fallo");
            break;
    }

    return obj;
}

-(void) dibujarObjeto: (NSRect)b
      withGraphicsContext:(NSGraphicsContext *)ctx
tipo:(int)tipo
{

    NSAffineTransform *tf;
    [ctx saveGraphicsState];
    tf = [NSAffineTransform transform];
    [tf translateXBy:b.size.width/2 yBy:b.size.height/2];
    [tf scaleXBy:b.size.width/funcObjec.size.width
             yBy:b.size.height/funcObjec.size.height];
    [tf concat];
    if(tipo==1){
    NSImage *manzana=[NSImage imageNamed:@"Manzana.png"];
      b.size=[manzana size];
    [manzana  drawInRect:[self objeto]
                fromRect:b
               operation:NSCompositingOperationSourceOver
                fraction:1.0];
    [ctx restoreGraphicsState];
    }
    else if(tipo==2){
        NSImage *manzana=[NSImage imageNamed:@"Platano.png"];
           b.size=[manzana size];
        [manzana  drawInRect:[self objeto]
                    fromRect:b
                   operation:NSCompositingOperationSourceOver
                    fraction:1.0];
        [ctx restoreGraphicsState];

    }
    else if (tipo==3){
        NSImage *manzana=[NSImage imageNamed:@"Pera.png"];
        b.size=[manzana size];
        [manzana  drawInRect:[self objeto]
                    fromRect:b
                   operation:NSCompositingOperationSourceOver
                    fraction:1.0];
        [ctx restoreGraphicsState];
    }
    else{
        NSImage *manzana=[NSImage imageNamed:@"Bomba.png"];
        b.size=[manzana size];
        [manzana  drawInRect:[self objeto]
                    fromRect:b
                   operation:NSCompositingOperationSourceOver
                    fraction:1.0];
        [ctx restoreGraphicsState];

    }

    
}


@end
