//
//  MainControlador.h
//  JuegoDani
//
//  Created by daniel hernandez on 30/10/2019.
//  Copyright © 2019 daniel hernandez. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class PanelControlador;
@class Pantalla;
@class Objeto;

@interface MainControlador : NSObject<NSWindowDelegate>
{
    PanelControlador *panel;
    NSMutableArray *arrayObjetos;
    NSTimer *temporizador;
    IBOutlet Pantalla *vista;
    IBOutlet NSButton *botonEmpezarParar;
    IBOutlet NSButton *botonAñadir;
    IBOutlet NSButton *botonEliminar;
    NSTimer *tiempo;
    IBOutlet NSTextField *contadorPantalla;
    IBOutlet NSTextField *puntuacionPantalla;
    IBOutlet NSTextField *contadorBombasPantalla;
    IBOutlet NSTextField *labelWin;
    IBOutlet NSImageView *imagenGameOver;
    int contBombas;
    NSNumber *segundos;
    int puntos;
    NSTimer *tiempoAñadirObjeto;
   
}

-(id)init;
-(IBAction)showPanel:(id)sender;
-(IBAction)botonAñadir:(id)sender;
-(IBAction)botonEliminar:(id)sender;
-(IBAction)botonEmpezar_Parar:(id)sender;

- (void)dibujarObjetos:(NSRect)b
       withGraphicsContext:(NSGraphicsContext *)ctx;

-(void) handleNotControlador:(NSNotification *)aNotificacion;

- (void) siguienteMov: (NSTimer *) aTimer;

- (void) añadeObjetosAutomatico;

@end


