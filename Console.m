//
//  Console.m
//  mac-screen-recorder
//
//  Created by Daniel Dixon on 3/20/10.
//

#import "Console.h"


@implementation Console

-(Console*)initWithArgc:(int)argc withArgv:(char*[])argv 
{
	BOOL captureAudio = YES;
	
	if (self = [super init]) {
		NSLog(@"Mac Screen Recorder");
		NSLog(@"requires Snow Leopard, Mac OS 10.6)");
		
		if (argc < 2 || argv[argc-1][0] == '-') {
			// If an error occurs here, send a [self release] message and return nil.
			NSLog(@"ERROR: Please specify a proper output file as the only parameter (ex: './mac-screen-recorder movie.mov')");
			return nil;
		} else {
			NSLog(@"Please type a command (i.e. 'help'):");
		}
		
		// Find an parameters passed in via command line
		int i;
		for (i = 1; i < argc; i++) {
			if (strcmp(argv[i],"-noaudio") == 0) {
				captureAudio = NO;
			}
		}
		
		// Get the path and name of the output file
		mOutputFilePath = [[NSString alloc] initWithCString: argv[argc-1]];
		
		mRecorder = [[ScreenRecorder alloc] init:captureAudio];
		if(mRecorder == nil) {
			return nil;
		}
	}
	return self;
}

// Called when user hits return
- (void)dataAvailable:(NSNotification *)notification
{
	//Get the available data
	NSData *data = [[notification object] availableData];	//This will be the latest line of input
	
	//Convert it to a string
	NSString *dataString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	
	//Process the data, in this case, we just log it
	//NSLog(@"%@ = %@", dataString, data);
	
	if([dataString isEqualToString:@"start\n"]) {
		[mRecorder startRecording:mOutputFilePath];
		NSLog(@"Starting recording...");
	} 
	else if([dataString isEqualToString:@"stop\n"]) {
		[mRecorder stopRecording];
		NSLog(@"Stopping recording...");
	}
	else if([dataString isEqualToString:@"help\n"]) {
		NSLog(@"Usage (type one of the following commands):");
		NSLog(@" start	- Start recording the screen");
		NSLog(@" stop	- Stop recording the screen");
		NSLog(@" help	- Print this information");
		NSLog(@" quit	- Quit the screen recorder");
	}
	else if(![dataString isEqualToString:@"quit\n"]) {
		[mRecorder stopRecording];
		NSLog(@"Unknown command: '%s' \n",dataString);
	}
	
	
	// Wait for new input or exit?
	if ([dataString isEqualToString:@"quit\n"]) {
		NSLog(@"Goodbye");
		[NSApp terminate:self];
	} else {
		//Clean up the string
		
		//the waitFor... method only works once, so reregister.
		[[notification object] waitForDataInBackgroundAndNotify];
	}
}


@end
