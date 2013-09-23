package com.swadhinapp.sensosaur;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpVersion;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.CookieStore;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.protocol.ClientContext;
import org.apache.http.cookie.Cookie;
import org.apache.http.entity.mime.FormBodyPart;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.BasicCookieStore;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.cookie.BasicClientCookie;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.CoreProtocolPNames;
import org.apache.http.params.HttpParams;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.protocol.HttpContext;
import org.apache.http.util.EntityUtils;

import com.swadhinapp.sensosaur.library.DatabaseHandler;

import android.util.Log;
import android.widget.Toast;
import android.os.AsyncTask;


public class ServerCommunication extends AsyncTask<Object,Void,String>{
	@Override
	protected String doInBackground(Object... params) {
	      String msg = "Upload finished";
	      File[] files = (File [])params[0];
	      String uid = (String)params[1];
	      String newFile = (String)params[2];
	      
	      uploadFiles(files,uid,newFile);
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

    public void uploadFiles(File[] files,String uid,String newFile) {

	        try {

	        	
	            HttpPost httppost = new HttpPost("http://131.252.130.215/fileUpload.php");
	            	
	            //HttpPost httppost = new HttpPost("http://131.252.130.215/fileUpload.php");
	            //MultipartEntity multipartEntity = new MultipartEntity(HttpMultipartMode.BROWSER_COMPATIBLE);  
         
	            MultipartEntity multipartEntity = new MultipartEntity();
	            multipartEntity.addPart(new FormBodyPart("uid", new StringBody(uid)));
	            multipartEntity.addPart(new FormBodyPart("new", new StringBody(newFile)));
	            for (int i=0;i<files.length;i++)
	            {
	            	String tag = "file" + (i+1);
	            	multipartEntity.addPart(tag , new FileBody(files[i]));
	            	Log.d("UPLOAD",tag+","+files[i].getAbsolutePath());
	            }
	            
	            //multipartEntity.addPart("sessionId",new StringBody(value));
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
