/*

 Mac OSX 10.6 Screen Recorder
	by Daniel Dixon
	assistance from Ben Spratling and Graham Booker
 
 A fun exercise in Objective-C during the month of March 2010.
 
*/

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#include "Console.h"

int main (int argc, char * argv[]) {
	@autoreleasepool {
		[NSApplication sharedApplication];
		
		// Class to manage user interaction
		Console *console = [[Console alloc] initWithArgc:argc withArgv:argv];
		if(console == nil) {
			return 1;
		}

		// File reader for standard input
		NSFileHandle *fileHandle = [NSFileHandle fileHandleWithStandardInput];
		
		// Register console for notifications in a non-blocking manner
		[[NSNotificationCenter defaultCenter] addObserver:console
												 selector:@selector(dataAvailable:)
													 name:NSFileHandleDataAvailableNotification
												   object:fileHandle];

		// Wait for user input on the background thread
		[fileHandle waitForDataInBackgroundAndNotify];
		
		// Run the main event loop (application stays open)
		[NSApp run];
		
		// Proper memory management on closing
		[[NSNotificationCenter defaultCenter] removeObserver:console];	
		[fileHandle closeFile];
	}
    return 0;
}