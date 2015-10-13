package sk.bpositive.bcommon;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import android.app.Activity;

import android.os.Bundle;

public class LoginActivity extends Activity
{	
	public static String extraPrefix = "LoginActivity";
	
	private BCommonExtensionContext _context = null;

	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);

		// Retrieve context
		_context = BCommonExtension.context;
		if (_context == null) {
			BCommonExtension.log("Extension context is null");
			finish();
			return;
		}

		// Get extra values
		Bundle extras = this.getIntent().getExtras();
		List<String> permissions = new ArrayList<String>(Arrays.asList(extras.getStringArray(extraPrefix+".permissions")));
		String type = extras.getString(extraPrefix+".type");

	}
}
