Air Native Extension (iOS + Android)
======================================

This is an [Air native extension](http://www.adobe.com/devnet/air/native-extensions-for-air.html) for [Facebook SDK](https://developers.facebook.com/docs#apis-and-sdks) on iOS and Android. It is a collection of various native tools useful (Firebase, Notifications, ZIP, CRC32, etc.). For any suggestions open a issue.

Installation
---------

The ANE binary (BCommon.ane) is located in the *bin* folder. You should add it to your application project's Build Path and make sure to package it with your app (more information [here](http://help.adobe.com/en_US/air/build/WS597e5dadb9cc1e0253f7d2fc1311b491071-8000.html)).

Documentation
--------

ActionScript documentation is available in HTML format on project pages [here](http://nodrock.github.io/ANE-Facebook/docs/).

Build from source
---------

Should you need to edit the extension source code and/or recompile it, you will find an ant build script (build.xml) in the *build* folder:
    
```bash
cd /path/to/the/ane

# Setup build configuration
cd build
mv example.build.config build.config
# Edit build.config file to provide your machine-specific paths

# Build the ANE
ant
```

**NOTE (deprecated):**  You MUST use Java 1.6 otherwise in android context will be null (probably bug in Adobe AIR SDK). On OSX you can call "export JAVA_HOME=`/usr/libexec/java_home -v 1.6`" without " to set JAVA_HOME properly.

Authors
------

[Ján Horváth](https://github.com/nodrock)

