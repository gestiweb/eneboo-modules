function main()
{
		var f = new FLFormSearchDB("datosentidad");
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
				f.exec("nombreentidad");
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