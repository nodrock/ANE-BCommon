package sk.bpositive.bcommon.functions;

import android.content.Context;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.google.android.gms.ads.identifier.AdvertisingIdClient;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.common.GooglePlayServicesRepairableException;

import org.json.JSONObject;

import java.io.IOException;

import sk.bpositive.bcommon.BCommonEvents;
import sk.bpositive.bcommon.BCommonExtension;

public class GetAAIDFunction extends BaseFunction {
	
	public FREObject call(FREContext context, FREObject[] args) {

		super.call(context, args);

		final Context	ctx		= context.getActivity().getApplicationContext();

		// getAdvertisingIdInfo needs to be handled in a separate thread
		Thread aaidThread = new Thread(new Runnable() {
			
			@Override
			public void run() {
				
				try {

					AdvertisingIdClient.Info advertisingIdInfo = AdvertisingIdClient.getAdvertisingIdInfo(ctx);
					String jsonResult = createResultJson(advertisingIdInfo.getId(), !advertisingIdInfo.isLimitAdTrackingEnabled());
					BCommonExtension.context.dispatchEvent(BCommonEvents.AD_IDENTIFIER, jsonResult);
				} 
				catch (IllegalStateException | GooglePlayServicesRepairableException | GooglePlayServicesNotAvailableException | IOException e) {

					e.printStackTrace();
					BCommonExtension.context.dispatchEvent(BCommonEvents.AD_IDENTIFIER, createErrorJson(e.getMessage()));
				}
			}
		});

		aaidThread.start();
		
		return null;
	}

	private static String createResultJson(String id, boolean trackingEnabled) {
		try {
			JSONObject object = new JSONObject();
			object.put("type", "AAID");
			object.put("id", id);
			object.put("trackingEnabled", trackingEnabled);
			return object.toString();
		} catch (Throwable t) {
			t.printStackTrace();
			return null;
		}
	}

	private static String createErrorJson(String error)
	{
		try {
			JSONObject object = new JSONObject();
			object.put("type", "AAID");
			object.put("error", error);
			return object.toString();
		} catch (Throwable t) {
			t.printStackTrace();
			return null;
		}
	}
}
