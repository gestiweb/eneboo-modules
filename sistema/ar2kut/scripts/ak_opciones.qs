/***************************************************************************
                                flopciones.qs
                            -------------------
   begin                : lun abr 26 2004
   copyright            : (C) 2004-2005 by InfoSiAL S.L.
   email                : mail@infosial.com
***************************************************************************/
/***************************************************************************
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; version 2 of the License.               *
 ***************************************************************************/
/***************************************************************************
   Este  programa es software libre. Puede redistribuirlo y/o modificarlo
   bajo  los  términos  de  la  Licencia  Pública General de GNU   en  su
   versión 2, publicada  por  la  Free  Software Foundation.
 ***************************************************************************/

var util = new FLUtil();

function main() 
{
	var dialog = new Dialog;
	dialog.caption = "Opciones";
	dialog.okButtonText = "Ok"
	dialog.cancelButtonText = "Cancelar";
	
	var texto = new Label;
 	texto.text = util.translate("scripts", "Opciones");
	dialog.add( texto );
	
	var grupo = new GroupBox;
	dialog.add( grupo );
	
	var botonAr = new CheckBox;
	if (util.readSettingEntry("scripts/sys/conversionAr") == "true")
		botonAr.checked = true;
	botonAr.text = util.translate("scripts", "Activar conversión de ficheros .ar");
	grupo.add( botonAr );
	
	var gbxDialogo = new GroupBox;
	gbxDialogo.title = util.translate("scripts", "Codificación:");
	
	rButtonISO = new RadioButton;
	rButtonISO.text = "ISO-8859-15";
	if (util.readSettingEntry("scripts/sys/conversionArENC") == "ISO-8859-15")
		rButtonISO.checked = true;
	gbxDialogo.add(rButtonISO);
		
	rButtonUTF = new RadioButton;
	rButtonUTF.text = "UTF-8";
	if (!rButtonISO.checked)
		rButtonUTF.checked = true;
	gbxDialogo.add(rButtonUTF);
	
	dialog.add(gbxDialogo);
	
	if( dialog.exec() ) {

		if (botonAr.checked) {
			res = MessageBox.warning(util.translate("scripts", "Atención: la conversión automática de ficheros se debe utilizar sólamente en entornos de programación\n¿Estás seguro?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
			if (res != MessageBox.Yes)
				return;
			util.writeSettingEntry("scripts/sys/conversionAr", "true");
			if (rButtonISO.checked)
				util.writeSettingEntry("scripts/sys/conversionArENC", "ISO-8859-15");
			else
				util.writeSettingEntry("scripts/sys/conversionArENC", "UTF-8");
		}
		else
			util.writeSettingEntry("scripts/sys/conversionAr", "false");
	}
}