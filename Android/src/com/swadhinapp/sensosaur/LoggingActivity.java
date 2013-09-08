package com.swadhinapp.sensosaur;

import java.io.File;
import java.util.TimerTask;

import android.util.Log;

public class LoggingActivity extends TimerTask {

	File[] files;
	String uid;	
	
	public LoggingActivity(File[] files,String uid)
	{
		this.files = files;
		this.uid = uid;
	}
	
	@Override
	public void run() {
		// TODO Auto-generated method stub
		try
    	{
    		ServerCommunication s = new ServerCommunication();
    		s.execute(files,uid,"no");
    		//Toast.makeText(this, "Files uploaded", Toast.LENGTH_SHORT).show();    
    	}
    	catch (Exception ex)
    	{
    		Log.e("File Uploader111", "error: " + ex.getMessage(), ex);
			
    	}
	}

}
