/***************************************************************************
                 empresa.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
    copyright            : (C) 2004 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
function main()
{
		var f = new FLFormSearchDB("empresa");
		var cursor = f.cursor();

		cursor.select();
		if (!cursor.first())
				cursor.setModeAccess(cursor.Insert);
		else
				cursor.setModeAccess(cursor.Edit);

		f.setMainWidget();
		if (cursor.modeAccess() == cursor.Insert)
				f.child("pushButtonCancel").setDisabled(true);
		cursor.refreshBuffer();
		var commitOk = false;
		var acpt;
		cursor.transaction(false);
		while (!commitOk) {
				acpt = false;
				f.exec("nombre");
				acpt = f.accepted();
				if (!acpt) {
						if (cursor.rollback())
								commitOk = true;
				} else {
						if (cursor.commitBuffer()) {
								cursor.commit();
								commitOk = true;
						}
				}
				f.close();
		}
}

function validateForm() 
{
		var util = new FLUtil();
		if (!sys.isLoadedModule("flcontppal") 
				&& form.cursor().valueBuffer("contintegrada") == true) {
				MessageBox.warning(util.translate("scripts", 
						"No puede activarse la contabilidad integrada si no está cargado el módulo principal de Contabilidad"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
		}
		return true;
}
