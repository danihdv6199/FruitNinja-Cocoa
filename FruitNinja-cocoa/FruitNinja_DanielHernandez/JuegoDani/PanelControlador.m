//
//  PanelControlador.m
//  JuegoDani
//
//  Created by daniel hernandez on 30/10/2019.
//  Copyright © 2019 daniel hernandez. All rights reserved.
//

#import "PanelControlador.h"
#import "Objeto.h"
extern BOOL YoNjuegoAutomatico;
extern NSString * notAPanel;
NSString * notAControlador = @"controladorNotificacion";
@interface PanelControlador ()

@end

@implementation PanelControlador

-(id)initWithArray:(NSMutableArray *)aArrayObjetos
{
    if (![super initWithWindowNibName:@"PanelControlador"])
        return nil;
    
    arrayObjetos=aArrayObjetos;
    YoNjuegoAutomatico=NO;
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(handleActualizarTabla:)
               name:notAPanel
             object:nil];
    
    return self;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView{
    
    return [arrayObjetos count];
    
}

- (void)handleActualizarTabla:(NSNotification *)aNotificacion{
    
    [Tabla reloadData];
    if(YoNjuegoAutomatico)
        [botonEliminarPanel setEnabled:NO];
    else
        [botonEliminarPanel setEnabled:YES];
}

//Metodo para la tabla 
- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
            row:(NSInteger)rowIndex{
    
    Objeto * obj = [arrayObjetos objectAtIndex:rowIndex];

    if([[aTableColumn identifier] isEqualToString:@"Tipo"]){
        return [obj nombre];
    }
    
    return nil;
}

-(IBAction)botonEliminar:(id)sender{
     NSInteger indice = [Tabla selectedRow];
    
    NSDictionary * notificationInfo = [NSDictionary dictionaryWithObject:@(indice)
                                                                 forKey:@"eliminarObjeto"];
    
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:notAControlador
                      object:self
                    userInfo:notificationInfo];
}

-(IBAction)juegoAutomatico:(id)sender{
     NSInteger tiempo=([indicadorTiempo intValue] );

    if(YoNjuegoAutomatico==NO){
        YoNjuegoAutomatico=YES;
    }
    NSDictionary * notificationInfo = [NSDictionary dictionaryWithObject:@(tiempo)
                                                                  forKey:@"tiempoJuego"];
                                      
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:notAControlador
                      object:self
                    userInfo:notificationInfo];
    
}

- (void)windowDidLoad {
    [indicadorTiempo selectItemAtIndex:0];//primera opcion pred

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
