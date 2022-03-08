//
//  PanelControlador.h
//  JuegoDani
//
//  Created by daniel hernandez on 30/10/2019.
//  Copyright © 2019 daniel hernandez. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class Objeto;

@interface PanelControlador : NSWindowController <NSWindowDelegate,
NSTextFieldDelegate,
NSTableViewDelegate,
NSTableViewDataSource,
NSControlTextEditingDelegate>
{
    NSMutableArray *arrayObjetos;
    IBOutlet NSTableView * Tabla;
    IBOutlet NSComboBox *indicadorTiempo;
    IBOutlet NSButton *botonEliminarPanel;
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView; //numero de filas a mostrar por la tabla

- (id) initWithArray:(NSMutableArray *)arrayObjetos;
-(IBAction)botonEliminar:(id)sender;
-(IBAction)juegoAutomatico:(id)sender;
- (void)handleActualizarTabla:(NSNotification *)aNotificacion;
-(id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
row:(NSInteger)rowIndex; //Devuelve el objeto a mostrar en la fila rowIndex de la columna
@end

