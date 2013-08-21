package com.swadhinapp.sensosaur;

import java.io.File;
import java.io.IOException;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpVersion;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.CoreProtocolPNames;
import org.apache.http.params.HttpParams;
import org.apache.http.protocol.HttpContext;
import org.apache.http.util.EntityUtils;

import android.util.Log;
import android.widget.Toast;
import android.os.AsyncTask;


public class ServerCommunication extends AsyncTask<File,Void,String>{
	@Override
	protected String doInBackground(File... files) {
	      String msg = "Upload finished";
	      uploadFiles(files);
	      return msg; 
	    }
	
	@Override
    protected void onPostExecute(String result) {
		Log.d("UPLOAD",result);
      //Toast.makeText(this, result, Toast.LENGTH_SHORT);
    }
	
	private DefaultHttpClient mHttpClient;

	public ServerCommunication() {
	        HttpParams params = new BasicHttpParams();
	        params.setParameter(CoreProtocolPNames.PROTOCOL_VERSION, HttpVersion.HTTP_1_1);
	        mHttpClient = new DefaultHttpClient(params);
	    }

    public void uploadFiles(File[] files) {

	        try {

	            HttpPost httppost = new HttpPost("http://131.252.130.215/fileUpload.php");

	            MultipartEntity multipartEntity = new MultipartEntity(HttpMultipartMode.BROWSER_COMPATIBLE);  
         
	            for (int i=0;i<files.length;i++)
	            {
	            	String tag = "file" + (i+1);
	            	multipartEntity.addPart(tag , new FileBody(files[i]));
	            	Log.d("UPLOAD",tag+","+files[i].getAbsolutePath());
	            }
	            httppost.setEntity(multipartEntity);
            	
	            Log.d("UPLOAD", "Uploading");
	            HttpEntity r_entity =  mHttpClient.execute(httppost).getEntity();
	            String responseString = EntityUtils.toString(r_entity);
	            //Toast.makeText( getApplicationContext(), "Files are done", Toast.LENGTH_LONG );
	            Log.d("UPLOAD", "Response="+responseString);
	            } catch (Exception e) {
	            Log.e(ServerCommunication.class.getName(), e.getLocalizedMessage(), e);
	        }
	    }

	
}
