//
//  MainControlador.m
//  JuegoDani
//
//  Created by daniel hernandez on 30/10/2019.
//  Copyright © 2019 daniel hernandez. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "MainControlador.h"
#import "PanelControlador.h"
#import "Objeto.h"
#import "Pantalla.h"
BOOL YoNjuegoAutomatico;
NSString * notAPanel = @"PanelNotificacion";
extern NSString * notAControlador;
@implementation MainControlador

-(id)init
{
    self = [super init];
    
    if(!self){
        
        return nil;
        
    }
    arrayObjetos=[[NSMutableArray alloc]init];
    temporizador = nil;
    tiempoAñadirObjeto=nil;
    contBombas=0;
    puntos=0;
    segundos=@(30);
    [[NSSound soundNamed:@"SonidoFondo2.wav"] play];
    //observer (el que recibe)
   //Recogemos la notificacion que manda el panel
   NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
   
   [nc addObserver:self
   selector:@selector(handleNotControlador:)
   name:notAControlador
   object:nil];
    

    return self;
}

//Muestra el panel
-(IBAction)showPanel:(id)sender{
    
    if (!panel) {
        panel = [[PanelControlador alloc]initWithArray:arrayObjetos];
    }
    
    [panel showWindow:self];
    
}




-(IBAction)botonAñadir:(id)sender
{
    if([imagenGameOver isEnabled])
        [imagenGameOver setHidden:YES];
    if(![labelWin isHidden])
        [labelWin setHidden:YES];
    Objeto *obj=[Objeto crearObjeto];
    
    [arrayObjetos addObject:obj];
    [botonEmpezarParar setEnabled:YES];
    [botonEliminar setEnabled:YES];
    [vista setNeedsDisplay:YES];
    
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:notAPanel
                      object:self];
    
}

-(IBAction)botonEliminar:(id)sender
{
    if([arrayObjetos count]==0)
        [[NSSound soundNamed:@"Blow"] play];//sonido del sistema
    else{
        [arrayObjetos removeLastObject];
        [[NSSound soundNamed:@"Basso"] play];
        if([arrayObjetos count]==0 && [botonEmpezarParar isEnabled]==YES){//SI NO QUEDAN MAS OBJETOS
            if (temporizador) {//Y ESTA ACTIVADO EL MOV
                [temporizador invalidate];
                temporizador=nil;
                [tiempo invalidate];
                tiempo=nil;
                [botonEmpezarParar setImage:[NSImage imageNamed:@"PlayBoton.png"]];
            }
            //cuando se hayan acabado los objetos
            [botonEmpezarParar setEnabled:NO];
            [botonEliminar setEnabled:NO];
    }
        [vista setNeedsDisplay:YES];
        NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:notAPanel
                          object:self];
    }
}

-(IBAction)botonEmpezar_Parar:(id)sender
{

    if (temporizador == nil) {//si no esta activado el movimiento
        
        temporizador = [NSTimer scheduledTimerWithTimeInterval:0.0001
                                                        target:self
                                                      selector:@selector(siguienteMov:)
                                                      userInfo:nil
                                                       repeats:YES];
        
        
        tiempo = [NSTimer scheduledTimerWithTimeInterval:1.0 // El timer se ejcuta cada segundo
                                                  target:self     // Se ejecuta este timer en este view
                                                selector:@selector(contar)      // Se ejecuta el método contar
                                                userInfo:nil
                                                 repeats:YES];   // El timer es repetitivo, es decir cada segundo (en esta caso) se ejecuta
         [botonEmpezarParar setImage:[NSImage imageNamed:@"PauseBoton.png"]];
        [[NSSound soundNamed:@"Morse"] play];
        if(YoNjuegoAutomatico){
            [self añadeObjetosAutomatico];
        }
    }
    else {//si esta activado el movimiento
        [botonEmpezarParar setImage:[NSImage imageNamed:@"PlayBoton.png"]];
        if(YoNjuegoAutomatico){
            [[NSSound soundNamed:@"Funk"] play];
            [temporizador invalidate];
            temporizador=nil;
            [tiempo invalidate];
            tiempo=nil;
            [tiempoAñadirObjeto invalidate];
            tiempoAñadirObjeto=nil;
        }else{
            [[NSSound soundNamed:@"Funk"] play];
            [temporizador invalidate];
            temporizador=nil;
            [tiempo invalidate];
            tiempo=nil;
        }
    }
   
    
}
 -(void) añadeObjetosAutomatico{
         tiempoAñadirObjeto = [NSTimer scheduledTimerWithTimeInterval:randomFloat(2, 4)// El timer se ejcuta cada segundo
                                                   target:self     // Se ejecuta este timer en este view
                                                 selector:@selector(añadirObjeto)      // Se ejecuta el método contar
                                                 userInfo:nil
                                                  repeats:YES];   // El timer es repetitivo, es decir cada segundo (en esta caso) se ejecuta
 }


-(void)añadirObjeto{
 
        if(([segundos intValue]>=50 && ([segundos intValue]<=60 ))){
            NSRect elObjeto;
            Objeto *objAleatorio;
            NSString *nom;
            int numObjetos=rand()%5+1;
            for(int i=0;i<numObjetos;i++){
                int opcionObjeto=rand()%3+1;
                if(opcionObjeto==1)nom=@"Manzana";
                else if(opcionObjeto==2)nom=@"Platano";
                else if(opcionObjeto==3)nom=@"Pera";
                else nom=@"Bomba";
                elObjeto.origin.x=randomFloat(-100,100);
                elObjeto.origin.y=randomFloat(410, 450);
                elObjeto.size.width=55;
                elObjeto.size.height=65;
                objAleatorio=[[Objeto alloc]initFromObjeto:elObjeto
                                                xIncrement:randomFloat(-2, 2)//velocidad eje X
                                                yIncrement:randomFloat(-1.5, -0.3)//velocidad eje Y
                                                      tipo:opcionObjeto
                                                    nombre:nom];
                [arrayObjetos addObject:objAleatorio];
            }
        }
        else if(([segundos intValue]>=40 && ([segundos intValue]<50 ))){
            NSRect elObjeto;
            Objeto *objAleatorio;
            NSString *nom;
            int numObjetos=rand()%5+2;
            for(int i=0;i<numObjetos;i++){
                int opcionObjeto=rand()%4+1;
                if(opcionObjeto==1)nom=@"Manzana";
                else if(opcionObjeto==2)nom=@"Platano";
                else if(opcionObjeto==3)nom=@"Pera";
                else nom=@"Bomba";
                elObjeto.origin.x=randomFloat(-200,200);
                elObjeto.origin.y=randomFloat(410, 500);
                elObjeto.size.width=55;
                elObjeto.size.height=65;
                objAleatorio=[[Objeto alloc]initFromObjeto:elObjeto
                                                xIncrement:randomFloat(-2, 2)//velocidad eje X
                                                yIncrement:randomFloat(-1.7, -0.5)//velocidad eje Y
                                                      tipo:opcionObjeto
                                                    nombre:nom];
                [arrayObjetos addObject:objAleatorio];
            }
        }
        else if(([segundos intValue]>=30 && ([segundos intValue]<40 ))){
            NSRect elObjeto;
            Objeto *objAleatorio;
            NSString *nom;
            int numObjetos=rand()%4+2;
            for(int i=0;i<numObjetos;i++){
                int opcionObjeto=rand()%4+1;
                if(opcionObjeto==1)nom=@"Manzana";
                else if(opcionObjeto==2)nom=@"Platano";
                else if(opcionObjeto==3)nom=@"Pera";
                else nom=@"Bomba";
                elObjeto.origin.x=randomFloat(-300,300);
                elObjeto.origin.y=randomFloat(410, 550);
                elObjeto.size.width=50;
                elObjeto.size.height=60;
                objAleatorio=[[Objeto alloc]initFromObjeto:elObjeto
                                                xIncrement:randomFloat(-2, 2)//velocidad eje X
                                                yIncrement:randomFloat(-2, -1)//velocidad eje Y
                                                      tipo:opcionObjeto
                                                    nombre:nom];
                [arrayObjetos addObject:objAleatorio];
            }
        }
        else if(([segundos intValue]>=25 && ([segundos intValue]<30 ))){
            NSRect elObjeto;
            Objeto *objAleatorio;
            NSString *nom;
            int numObjetos=rand()%6+2;
            for(int i=0;i<numObjetos;i++){
                int opcionObjeto=rand()%4+1;
                if(opcionObjeto==1)nom=@"Manzana";
                else if(opcionObjeto==2)nom=@"Platano";
                else if(opcionObjeto==3)nom=@"Pera";
                else nom=@"Bomba";
                elObjeto.origin.x=randomFloat(-100,100);
                elObjeto.origin.y=randomFloat(410, 650);
                elObjeto.size.width=50;
                elObjeto.size.height=60;
                objAleatorio=[[Objeto alloc]initFromObjeto:elObjeto
                                                xIncrement:randomFloat(-2, 2)//velocidad eje X
                                                yIncrement:randomFloat(-1.7, -1)//velocidad eje Y
                                                      tipo:opcionObjeto
                                                    nombre:nom];
                [arrayObjetos addObject:objAleatorio];
            }
        }
   else if(([segundos intValue]>=25 && ([segundos intValue]<30 ))){
            NSRect elObjeto;
            Objeto *objAleatorio;
            NSString *nom;
            int numObjetos=rand()%6+1;
            for(int i=0;i<numObjetos;i++){
                int opcionObjeto=rand()%4+1;
                if(opcionObjeto==1)nom=@"Manzana";
                else if(opcionObjeto==2)nom=@"Platano";
                else if(opcionObjeto==3)nom=@"Pera";
                else nom=@"Bomba";
                elObjeto.origin.x=randomFloat(-100,100);
                elObjeto.origin.y=randomFloat(420, 700);
                elObjeto.size.width=50;
                elObjeto.size.height=60;
                objAleatorio=[[Objeto alloc]initFromObjeto:elObjeto
                                                xIncrement:randomFloat(-2, 2)//velocidad eje X
                                                yIncrement:randomFloat(-2.3, -1.2)//velocidad eje Y
                                                      tipo:opcionObjeto
                                                    nombre:nom];
                [arrayObjetos addObject:objAleatorio];
        }
    }
    else if(([segundos intValue]>=20 && ([segundos intValue]<25 ))){
        NSRect elObjeto;
        Objeto *objAleatorio;
        NSString *nom;
        int numObjetos=rand()%7+2;
        for(int i=0;i<numObjetos;i++){
        int opcionObjeto=rand()%4+1;
            if(opcionObjeto==1)nom=@"Manzana";
            else if(opcionObjeto==2)nom=@"Platano";
            else if(opcionObjeto==3)nom=@"Pera";
            else nom=@"Bomba";
        elObjeto.origin.x=randomFloat(-150,150);
        elObjeto.origin.y=randomFloat(450, 700);
        elObjeto.size.width=50;
        elObjeto.size.height=60;
        objAleatorio=[[Objeto alloc]initFromObjeto:elObjeto
                                        xIncrement:randomFloat(-2, 2)//velocidad eje X
                                        yIncrement:randomFloat(-1.5, -0.7)//velocidad eje Y
                                              tipo:opcionObjeto
                                            nombre:nom];
        [arrayObjetos addObject:objAleatorio];
    }
    }
    else if(([segundos intValue]>=15 && ([segundos intValue]<20 ))){
        NSRect elObjeto;
        Objeto *objAleatorio;
        NSString *nom;
        int numObjetos=rand()%5+2;
        for(int i=0;i<numObjetos;i++){
            int opcionObjeto=rand()%4+1;
            if(opcionObjeto==1)nom=@"Manzana";
            else if(opcionObjeto==2)nom=@"Platano";
            else if(opcionObjeto==3)nom=@"Pera";
            else nom=@"Bomba";
            elObjeto.origin.x=randomFloat(-200,200);
            elObjeto.origin.y=randomFloat(420, 700);
            elObjeto.size.width=50;
            elObjeto.size.height=60;
            objAleatorio=[[Objeto alloc]initFromObjeto:elObjeto
                                            xIncrement:randomFloat(-2, 2)//velocidad eje X
                                            yIncrement:randomFloat(-1.8, -1)//velocidad eje Y
                                                  tipo:opcionObjeto
                                                nombre:nom];
            [arrayObjetos addObject:objAleatorio];
        }

    }
    else if(([segundos intValue]>=10 && ([segundos intValue]<15 ))){
        NSRect elObjeto;
        Objeto *objAleatorio;
        NSString *nom;
        int numObjetos=rand()%6+2;
        for(int i=0;i<numObjetos;i++){
            int opcionObjeto=rand()%4+1;
            if(opcionObjeto==1)nom=@"Manzana";
            else if(opcionObjeto==2)nom=@"Platano";
            else if(opcionObjeto==3)nom=@"Pera";
            else nom=@"Bomba";
            elObjeto.origin.x=randomFloat(-250,250);
            elObjeto.origin.y=randomFloat(450, 700);
            elObjeto.size.width=45;
            elObjeto.size.height=55;
            objAleatorio=[[Objeto alloc]initFromObjeto:elObjeto
                                            xIncrement:randomFloat(-2, 2)//velocidad eje X
                                            yIncrement:randomFloat(-2, -1.2)//velocidad eje Y
                                                  tipo:opcionObjeto
                                                nombre:nom];
            [arrayObjetos addObject:objAleatorio];
        }

    }
    else if(([segundos intValue]>=5 && ([segundos intValue]<10 ))){
        NSRect elObjeto;
        Objeto *objAleatorio;
        NSString *nom;
        int numObjetos=rand()%4+1;
        for(int i=0;i<numObjetos;i++){
            int opcionObjeto=rand()%4+1;
            if(opcionObjeto==1)nom=@"Manzana";
            else if(opcionObjeto==2)nom=@"Platano";
            else if(opcionObjeto==3)nom=@"Pera";
            else nom=@"Bomba";
            elObjeto.origin.x=randomFloat(-100,100);
            elObjeto.origin.y=randomFloat(420, 500);
            elObjeto.size.width=40;
            elObjeto.size.height=50;
            objAleatorio=[[Objeto alloc]initFromObjeto:elObjeto
                                            xIncrement:randomFloat(-2, 2)//velocidad eje X
                                            yIncrement:randomFloat(-2.6, -2)//velocidad eje Y
                                                  tipo:opcionObjeto
                                                nombre:nom];
            [arrayObjetos addObject:objAleatorio];
        }

    }
    else if(([segundos intValue]>=0 && ([segundos intValue]<5 ))){
        NSRect elObjeto;
        Objeto *objAleatorio;
        NSString *nom;
        int numObjetos=rand()%3+1;
        for(int i=0;i<numObjetos;i++){
            int opcionObjeto=rand()%4+1;
            if(opcionObjeto==1)nom=@"Manzana";
            else if(opcionObjeto==2)nom=@"Platano";
            else if(opcionObjeto==3)nom=@"Pera";
            else nom=@"Bomba";
            elObjeto.origin.x=randomFloat(-100,100);
            elObjeto.origin.y=randomFloat(420, 460);
            elObjeto.size.width=35;
            elObjeto.size.height=40;
            objAleatorio=[[Objeto alloc]initFromObjeto:elObjeto
                                            xIncrement:randomFloat(-2, 2)//velocidad eje X
                                            yIncrement:randomFloat(-3, -2)//velocidad eje Y
                                                  tipo:opcionObjeto
                                                nombre:nom];
            [arrayObjetos addObject:objAleatorio];
        }

    }
    [vista setNeedsDisplay:YES];
    
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:notAPanel
                      object:self];
}


-(void)contar{
    segundos=@([segundos intValue]-1);
    
    [contadorPantalla setStringValue:[NSString stringWithFormat:@"Tiempo: %@",segundos]];
    if(([segundos intValue]<=0)){

        [tiempo invalidate];
        tiempo=nil;
        if(YoNjuegoAutomatico){//para cuando llega a 0
            [tiempoAñadirObjeto invalidate];
            tiempoAñadirObjeto=nil;
            
            if( [arrayObjetos count]==0){//entra cuando tiempo 0 y cumple que no hay mas objetos en ese momento
                YoNjuegoAutomatico=NO;
                [temporizador invalidate];
                temporizador = nil;
                [botonAñadir setEnabled:YES];
                [botonEliminar setEnabled:NO];
                [botonEmpezarParar setEnabled:NO];
                [botonEmpezarParar setImage:[NSImage imageNamed:@"PlayBoton.png"]];
                //aqui win
                [labelWin setHidden:NO];
                [labelWin setStringValue:[NSString stringWithFormat:@"BIEN JUGADO TU PUNTUACION HA SIDO: %d",puntos]];
                contBombas=0;
                segundos=@(30);
                puntos=0;
                [contadorBombasPantalla setHidden:YES];
                [puntuacionPantalla setStringValue:[NSString stringWithFormat:@"Puntuacion: %d",puntos]];
                [contadorPantalla setStringValue:[NSString stringWithFormat:@"Tiempo: %@",segundos]];
            }
        }
        else{
            if( [arrayObjetos count]==0){
                [temporizador invalidate];
                temporizador = nil;
                [botonEmpezarParar setImage:[NSImage imageNamed:@"PlayBoton.png"]];
                [labelWin setHidden:NO];
                [labelWin setStringValue:[NSString stringWithFormat:@"BIEN JUGADO TU PUNTUACION HA SIDO: %d",puntos]];
                contBombas=0;
                segundos=@(30);
                puntos=0;
                [contadorBombasPantalla setHidden:YES];
                [puntuacionPantalla setStringValue:[NSString stringWithFormat:@"Puntuacion: %d",puntos]];
                [contadorPantalla setStringValue:[NSString stringWithFormat:@"Tiempo: %@",segundos]];
            }
        }
       
    }

}

- (void) siguienteMov: (NSTimer *) aTimer
{
    int indiceArray=-1;
    for (Objeto *obj in arrayObjetos){
        [obj moverObjeto];

        if(obj.objeto.origin.y<-450){
            indiceArray=(int)[arrayObjetos indexOfObject:obj];
            if(obj.tipo>=1 && obj.tipo <=3){
                puntos=puntos-5;
                [puntuacionPantalla setStringValue:[NSString stringWithFormat:@"Puntuacion: %d",puntos]];
            }
        }
    }
    if(indiceArray>-1){
       
        [arrayObjetos removeObjectAtIndex:indiceArray];
        if(puntos<0){//entra cuando al restar puntos de caida la puntacion es 10
            if(YoNjuegoAutomatico){
                [arrayObjetos removeAllObjects];
                
                [botonAñadir setEnabled:YES];
                [botonEmpezarParar setEnabled:NO];
                
                [temporizador invalidate];
                temporizador=nil;
                [tiempo invalidate];
                tiempo=nil;
                [tiempoAñadirObjeto invalidate];
                tiempoAñadirObjeto=nil;
                
                [imagenGameOver setHidden:NO];
                [[NSSound soundNamed:@"SonidoGame over.mp3"] play];
                [botonEmpezarParar setImage:[NSImage imageNamed:@"PlayBoton.png"]];
                contBombas=0;
                puntos=0;
                segundos=@(30);
                [contadorBombasPantalla setHidden:YES];
                [puntuacionPantalla setStringValue:[NSString stringWithFormat:@"Puntuacion: %d",puntos]];
                [contadorPantalla setStringValue:[NSString stringWithFormat:@"Tiempo: %@",segundos]];
                YoNjuegoAutomatico=NO;
            }
            else{
                [arrayObjetos removeAllObjects];
                [botonEmpezarParar setEnabled:NO];
                [botonEliminar setEnabled:NO];
                [temporizador invalidate];
                temporizador=nil;
                [tiempo invalidate];
                tiempo=nil;
                [imagenGameOver setHidden:NO];
                 [[NSSound soundNamed:@"SonidoGame over.mp3"] play];
                //[botonEmpezarParar setTitle:@"Empezar"];
                //[botonEmpezarParar alternateImage];
                [botonEmpezarParar setImage:[NSImage imageNamed:@"PlayBoton.png"]];
                contBombas=0;
                puntos=0;
                segundos=@(30);
                [contadorBombasPantalla setHidden:YES];
                [puntuacionPantalla setStringValue:[NSString stringWithFormat:@"Puntuacion: %d",puntos]];
                [contadorPantalla setStringValue:[NSString stringWithFormat:@"Tiempo: %@",segundos]];
            }
        }
        else if(([segundos intValue]<=0) &&( [arrayObjetos count]==0)){//entra cuando un objeto llega abajo y el tiempo se ha cumplido y no hay mas objetos
            if(YoNjuegoAutomatico){
                [botonAñadir setEnabled:YES];
                [botonEmpezarParar setEnabled:NO];
                [temporizador invalidate];
                temporizador=nil;
                [tiempo invalidate];
                tiempo=nil;
                [tiempoAñadirObjeto invalidate];
                tiempoAñadirObjeto=nil;
                [botonEmpezarParar setImage:[NSImage imageNamed:@"PlayBoton.png"]];
                [labelWin setHidden:NO];
                [labelWin setStringValue:[NSString stringWithFormat:@"BIEN JUGADO TU PUNTUACION HA SIDO: %d",puntos]];
                contBombas=0;
                puntos=0;
                segundos=@(30);
                [contadorBombasPantalla setHidden:YES];
                [puntuacionPantalla setStringValue:[NSString stringWithFormat:@"Puntuacion: %d",puntos]];
                [contadorPantalla setStringValue:[NSString stringWithFormat:@"Tiempo: %@",segundos]];
                YoNjuegoAutomatico=NO;
            }
            else{
                [botonEmpezarParar setEnabled:NO];
                [botonEliminar setEnabled:NO];
                [temporizador invalidate];
                temporizador=nil;
                [tiempo invalidate];
                tiempo=nil;
                [botonEmpezarParar setImage:[NSImage imageNamed:@"PlayBoton.png"]];
                [labelWin setHidden:NO];
                [labelWin setStringValue:[NSString stringWithFormat:@"BIEN JUGADO TU PUNTUACION HA SIDO: %d",puntos]];
                contBombas=0;
                puntos=0;
                segundos=@(30);
                [contadorBombasPantalla setHidden:YES];
                [puntuacionPantalla setStringValue:[NSString stringWithFormat:@"Puntuacion: %d",puntos]];
                [contadorPantalla setStringValue:[NSString stringWithFormat:@"Tiempo: %@",segundos]];
            }

        }
        
        NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:notAPanel
                          object:self];
    }
    [vista setNeedsDisplay:YES];
    
}

-(void)dibujarObjetos:(NSRect)b
      withGraphicsContext:(NSGraphicsContext *)ctx
{
    for (Objeto *r in arrayObjetos){
        [r dibujarObjeto:b withGraphicsContext:ctx tipo:r.tipo];
    }
}

-(void) handleNotControlador:(NSNotification *)aNotificacion
{
    NSDictionary * notificationInfo = [aNotificacion userInfo];
    NSNumber * indice = [notificationInfo objectForKey:@"eliminarObjeto"];
    NSNumber *X = [notificationInfo objectForKey:@"EjeX"];
    NSNumber *Y = [notificationInfo objectForKey:@"EjeY"];

 //------------------------------------------------------------
    if(indice != nil){
        [arrayObjetos removeObjectAtIndex:[indice integerValue]];
    }
//------------------------------------------------------------
    if((X!=nil)&&(Y!=nil)){
        float x = [X floatValue];
        float y =[Y floatValue];
        NSPoint puntoClick;
        puntoClick=NSMakePoint(x, y);
        int indiceArray=-1;
        
        for (Objeto *obj in arrayObjetos){
            if(NSPointInRect(puntoClick, obj.objeto )){
                switch (obj.tipo) {
                    case 1:
                        [[NSSound soundNamed:@"Ping"] play];
                        puntos+=1;
                        break;
                        
                    case 2:
                        [[NSSound soundNamed:@"Ping"] play];
                        puntos+=1;
                         break;
                        
                    case 3:
                        [[NSSound soundNamed:@"Ping"] play];
                        puntos+=1;
                         break;
                        
                    case 4:
                        [[NSSound soundNamed:@"SonidoBomba.mp3"] play];
                        puntos=puntos-10;
                        contBombas+=+1;
                         //aqui cont bombas pantalla
                        switch (contBombas) {
                            case 1:
                                [contadorBombasPantalla setHidden:NO];
                                [contadorBombasPantalla setStringValue:[NSString stringWithFormat:@"X"]];
                                break;
                            case 2:
                                
                                [contadorBombasPantalla setStringValue:[NSString stringWithFormat:@"X X"]];
                                break;
                            case 3:
                                [contadorBombasPantalla setStringValue:[NSString stringWithFormat:@"X X X"]];
                            default:
                                break;
                        }
                        
                         break;
                        
                    default:
                        
                        break;
                        
                }
                [puntuacionPantalla setStringValue:[NSString stringWithFormat:@"Puntuacion: %d",puntos]];
                indiceArray=(int)[arrayObjetos indexOfObject:obj];
            }
        }
        
        if(indiceArray>-1){
            [arrayObjetos removeObjectAtIndex:indiceArray];
            if(contBombas==3 || puntos<0){//entra cuando clicka en un objeto y el num de bombas es 3 ó puntos -10
                if(YoNjuegoAutomatico){
                    [arrayObjetos removeAllObjects];
                    
                    [botonAñadir setEnabled:YES];
                    [botonEmpezarParar setEnabled:NO];
                    [botonEmpezarParar setImage:[NSImage imageNamed:@"PlayBoton.png"]];
                    [temporizador invalidate];
                    temporizador=nil;
                    [tiempo invalidate];
                    tiempo=nil;
                    [tiempoAñadirObjeto invalidate];
                    tiempoAñadirObjeto=nil;
                    [imagenGameOver setHidden:NO];
                     [[NSSound soundNamed:@"SonidoGame over.mp3"] play];
                    segundos=@(30);
                    contBombas=0;
                    puntos=0;
                    [contadorBombasPantalla setHidden:YES];
                    [puntuacionPantalla setStringValue:[NSString stringWithFormat:@"Puntuacion: %d",puntos]];
                    [contadorPantalla setStringValue:[NSString stringWithFormat:@"Tiempo: %@",segundos]];
                    
                    YoNjuegoAutomatico=NO;
                }else{
                    [arrayObjetos removeAllObjects];
                    [botonEmpezarParar setEnabled:NO];
                    [botonEmpezarParar setImage:[NSImage imageNamed:@"PlayBoton.png"]];
                    [temporizador invalidate];
                    temporizador=nil;
                    [tiempo invalidate];
                    tiempo=nil;
                    
                    [imagenGameOver setHidden:NO];
                     [[NSSound soundNamed:@"SonidoGame over.mp3"] play];
                    contBombas=0;
                    puntos=0;
                    segundos=@(30);
                    [contadorBombasPantalla setHidden:YES];
                    [puntuacionPantalla setStringValue:[NSString stringWithFormat:@"Puntuacion: %d",puntos]];
                    [contadorPantalla setStringValue:[NSString stringWithFormat:@"Tiempo: %@",segundos]];
                }
            }
            if(([segundos intValue]<=0) &&( [arrayObjetos count]==0)){//entra cuando un objeto llega abajo y el tiempo se ha cumplido y no hay mas objetos
                if(YoNjuegoAutomatico){
                    [botonAñadir setEnabled:YES];
                    [botonEmpezarParar setEnabled:NO];
                    
                    [temporizador invalidate];
                    temporizador=nil;
                    [tiempo invalidate];
                    tiempo=nil;
                    [tiempoAñadirObjeto invalidate];
                    tiempoAñadirObjeto=nil;
                    [botonEmpezarParar setImage:[NSImage imageNamed:@"PlayBoton.png"]];
                    //AQUI WIN
                    [labelWin setHidden:NO];
                    [labelWin setStringValue:[NSString stringWithFormat:@"BIEN JUGADO TU PUNTUACION HA SIDO: %d",puntos]];
                    contBombas=0;
                    puntos=0;
                    segundos=@(30);
                    [contadorBombasPantalla setHidden:YES];
                    [puntuacionPantalla setStringValue:[NSString stringWithFormat:@"Puntuacion: %d",puntos]];
                    [contadorPantalla setStringValue:[NSString stringWithFormat:@"Tiempo: %@",segundos]];
                    
                    YoNjuegoAutomatico=NO;
                }
                else{
                    [botonEmpezarParar setEnabled:NO];
                    [botonEliminar setEnabled:NO];
                    
                    [temporizador invalidate];
                    temporizador=nil;
                    [tiempo invalidate];
                    tiempo=nil;
                    [botonEmpezarParar setImage:[NSImage imageNamed:@"PlayBoton.png"]];
                    [labelWin setHidden:NO];
                    [labelWin setStringValue:[NSString stringWithFormat:@"BIEN JUGADO TU PUNTUACION HA SIDO: %d",puntos]];
                    contBombas=0;
                    puntos=0;
                    segundos=@(30);
                    [contadorBombasPantalla setHidden:YES];
                    [puntuacionPantalla setStringValue:[NSString stringWithFormat:@"Puntuacion: %d",puntos]];
                    [contadorPantalla setStringValue:[NSString stringWithFormat:@"Tiempo: %@",segundos]];
                }
                
            }
        }
    }
    //--------------------------------------------------------------------------------------------------------
    else{//cuando pulsa juego auto
        if(YoNjuegoAutomatico==YES){
            segundos =[notificationInfo objectForKey:@"tiempoJuego"];
            [arrayObjetos removeAllObjects];
            [temporizador invalidate];
            temporizador=nil;
            [tiempo invalidate];
            tiempo=nil;
            [tiempoAñadirObjeto invalidate];
            tiempoAñadirObjeto=nil;
            [contadorBombasPantalla setHidden:YES];
            if([imagenGameOver isEnabled])
                 [imagenGameOver setHidden:YES];
            if([botonAñadir isEnabled])
                [botonAñadir setEnabled:NO];
            if([botonEliminar isEnabled])
                [botonEliminar setEnabled:NO];
            if(![botonEmpezarParar isEnabled])
                [botonEmpezarParar setEnabled:YES];
            
            [botonEmpezarParar setImage:[NSImage imageNamed:@"PlayBoton.png"]];
            
            if(contBombas>=1){
                contBombas=0;
            }
            if(![imagenGameOver isEnabled])
                [imagenGameOver setHidden:YES];
            else if(![labelWin isHidden])
                [labelWin setHidden:YES];
            puntos=0;
             [puntuacionPantalla setStringValue:[NSString stringWithFormat:@"Puntuacion: %d",puntos]];
             [contadorPantalla setStringValue:[NSString stringWithFormat:@"Tiempo: %@",segundos]];
        }
    }
    
    //------------------------------------------------------------
    
    [vista setNeedsDisplay:YES];
    
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:notAPanel
                      object:self];
    
}



#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

-(BOOL)windowShouldClose:(NSWindow *)sender
{
    NSInteger respuesta;
    
    respuesta = NSRunAlertPanel(@"Atencion",
                                @"¿Está seguro de que desea cerrar la ventana?.Esta accion finalizará la ejecución de la aplicación ",
                                @"No",
                                @"Si",
                                nil);
    if(respuesta == NSAlertDefaultReturn)
        return NO;
    else
        [NSApp terminate:self];
    return YES;
}
#pragma clang diagnostic pop

@end
