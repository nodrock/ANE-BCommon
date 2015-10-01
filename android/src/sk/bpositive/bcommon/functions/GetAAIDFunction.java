package sk.bpositive.bcommon.functions;


import java.io.IOException;

import android.content.Context;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.google.android.gms.ads.identifier.AdvertisingIdClient;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.common.GooglePlayServicesRepairableException;
import org.json.JSONException;
import org.json.JSONObject;
import sk.bpositive.bcommon.BCommonExtension;

public class GetAAIDFunction implements FREFunction {
	
	public FREObject call(FREContext ctx, FREObject[] args) {

		BCommonExtension.log("GetAAIDFunction");

		final Context	context		= ctx.getActivity().getApplicationContext();

		int connectionResult = GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(context);
		if(connectionResult == ConnectionResult.SUCCESS){

			BCommonExtension.log("GOOGLE_API_AVAILABLE");
		}else{

			BCommonExtension.log("GOOGLE_API_NOT_AVAILABLE connectionResult:" + connectionResult);
			BCommonExtension.context.dispatchStatusEventAsync("AAID_FAILED", "{\"error\": \"google_api_not_available\"}");
			return null;
		}

		// getAdvertisingIdInfo needs to be handled in a separate thread
		Thread aaidThread = new Thread(new Runnable() {
			
			@Override
			public void run() {
				
				try {

					AdvertisingIdClient.Info advertisingIdInfo = AdvertisingIdClient.getAdvertisingIdInfo(context);

					String jsonResult;
					try {
						JSONObject object = new JSONObject();
						object.put("id", advertisingIdInfo.getId());
						object.put("limitAdTrackingEnabled", advertisingIdInfo.isLimitAdTrackingEnabled());
						jsonResult = object.toString();
					} catch (JSONException e) {
						e.printStackTrace();
						jsonResult = "{\"error\":\"json_parse_error\", \"message\":\"GameRequestDialog.Result parsing error!\"}";
						BCommonExtension.context.dispatchStatusEventAsync("AAID_FAILED", jsonResult);
					}

					BCommonExtension.log("AAID_COMPLETED json:" + jsonResult);
					BCommonExtension.context.dispatchStatusEventAsync("AAID_COMPLETED", jsonResult);
				} 
				catch (IllegalStateException | GooglePlayServicesRepairableException | GooglePlayServicesNotAvailableException | IOException e) {

					e.printStackTrace();
					BCommonExtension.log("AAID_FAILED message:" + e.getMessage());
					// TODO: spravit si classu na generovanie tychto error jsonov v stringovej podobe
					BCommonExtension.context.dispatchStatusEventAsync("AAID_FAILED", "{\"error\": \"exception\"}");
				}
			}
		});

		aaidThread.start();
		
		return null;
	}
}
