# libCatchClient
CatchClient is an Objective-C library for iOS and MacOS X.  It makes it easy to use the Catch.com API.  Here's a quick preview...

```objc
CatchClient *client = [[[CatchClient alloc] initWithAppName:@"MyCoolApp" 
                                                    version:@"1.2.3" 
                                                        url:@"http://example.com/MyCoolApp/"] autorelease];

@try {
    // sign in
    [client signIn:@"username" password:@"pass1234"];
    
    // add a new note
    CatchApiNote *note = [[[CatchApiNote alloc] initWithText:@"Hello World!" location:nil] autorelease];
    [client addNote:note];
}
@catch (NSException *exception) {
    NSLog(@"Error: %@", [exception reason]);
}
```

Check out the [online documentation](http://catch.github.com/objc-api/Documentation/) for more.  The [CatchClient class](http://catch.github.com/objc-api/Documentation/Classes/CatchClient.html) is the primary interface, so you might want to start there.

Also, take a look at the DesktopDemo sample app to see an example of the library in use.  The interesting stuff is in [DesktopDemoAppDelegate.m](https://github.com/catch/objc-api/blob/master/Examples/DesktopDemo/DesktopDemo/DesktopDemoAppDelegate.m).


## Using libCatchClient in an Xcode4 Workspace
Using Xcode4's implicit dependency feature is the easiest way to use libCatchClient in your project.

1. Create a new workspace.  Add your application project (MyCoolApp.xcodeproj) to the workspace.

2. Add the library project (CatchClient-iOS.xcodeproj or CatchClient-MacOS.xcodeproj) to the workspace.  Add it as a toplevel item, not as a subordinate of the application project.  
   ![](http://catch.github.com/objc-api/images/workspace.png)

3. Configure your application to link with libCatchClient.
   * Click the + button under Link Binary With Libraries.  
     ![](http://catch.github.com/objc-api/images/library-1.png)
   * Choose libCatchClient.a from the resulting dialog.  
     ![](http://catch.github.com/objc-api/images/library-2.png)
   * Drag the library to the Frameworks folder (to reduce clutter).  
     ![](http://catch.github.com/objc-api/images/library-3.png)

4. Repeat the steps above for each of the following system libraries...
   * CoreLocation.framework
   * libz.1.2.3.dylib
   * SystemConfiguration.framework
   * CFNetwork.framework (for iOS projects)
   * MobileCoreServices.framework (for iOS projects)

5. Set Header Search Paths to `"$(BUILT_PRODUCTS_DIR)/usr/local/include"` so that library headers are available during build.  
   ![](http://catch.github.com/objc-api/images/headers.png)

6. Add linker flags `-ObjC -all_load` to enable proper static library linking.  
   ![](http://catch.github.com/objc-api/images/linker.png)

7. Restart Xcode.
