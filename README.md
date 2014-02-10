# CeedVocal
[CeedVocal](http://www.creaceed.com/ceedvocal/about) is Creaceed's iPhone Speech Recognition SDK for iOS.

## What's CeedVocal?
CeedVocal is a speech recognition SDK for iPhone/iPad that we have built around open source libraries [Julius](http://julius.sourceforge.jp/en_index.php) and [FLite](http://cmuflite.org), when developing our own Vocalia application. CeedVocal runs on iOS 5.0+ (even 4.3 with some restrictions, see below), and is optimized for the latest iOS7 and 64-bit architectures. It is not available for Android devices at this time.

CeedVocal runs directly on the device (there's no network connection). The SDK consists of a static library (universal: iPhone/iPad and Simulator, 32- and 64-bit), a header file, and acoustic models that we have dutifully trained for 6 languages (EN, FR, DE, ES, IT, NL), and an example iPhone application.

CeedVocal performs either isolated words recognition or keyword spotting from a list of user provided words. It will *not* perform continuous dictation like what Siri does. If you are interested in that, you should discuss it with companies like Nuance which have an SDK for that. CeedVocal works with any word list (or small sentences), but works best with longer words (or phrases) that are different from each other, than with small, 1-syllable words. As of version 1.2, CeedVocal is optimized for 64-bit iOS devices.

CeedVocal must be licensed prior to be integrated into your app. We provide it free of charge for evaluation purpose (that is, after signing an evaluation agreement). Licensing procedure and prices can be found [here](http://www.creaceed.com/ceedvocal/about). If you include CeedVocal in your published application, you should add Julius and FLite licenses which are provided in the `Acknowldgments.html` file. Please contact us at ceedvocal@creaceed.com if you have any questions.

## Quick Start
### Licensing
This is the first thing you must do before any other invocation of the CeedVocal API.
Make sure that the Identifier of your app (Xcode: select target, cmd-i, properties tab, Identifier) corresponds to the one you have sent us for license generation. 

To set your license in the code, invoke this method with the license key (a string) you received from us (either an expiring evaluation license or a commercial one):

```Objective-C
[CVSpeechRecognizer setLicense:@"4DIKJ5PFEFCHKBAUWXK4L4A…
VCRSMBAZD"];
```

### Loading the acoustic model
Loading the acoustic model for the appropriate language is needed before any speech recognition can happen. Add both `.enchmm` and `.fastied` files to the resources of your app and create the recognizer with this call:

```Objective-C
speechRecognizer = [[CVSpeechRecognizer alloc] initWithLanguage:CV_LANGUAGE_ENGLISH acousticModel:[[NSBundle mainBundle] pathForResource:@"ceedmodel-en" ofType:@"enchmm"]];
```

Acoustic models are specific to each language, and you should check that the constant matches the model files in the application bundle.

#### Setting up the Recognizer
To be notified when speech is recognized, you should add a delegate to the recognizer. This is done this way (assuming self is the delegate:

```Objective-C
CVSpeechRecognizer *recognizer = [[CVSpeechRecognizer alloc] init];
speechRecognizer.delegate = self; // self is your view controller (or another object)
```

Your delegate object must implement the appropriate delegate method:

```Objective-C
- (void)speechRecognizerDidRecognizeSpeech:(CVSpeechRecognizer*)recognizer
{	
	[result release];
	result  = [NSMutableString new];
	
	int i=0;
	for(id res in [recognizer recognizedPhrases])
	{
		NSLog(@"%@ (score=%f)", res, [recognizer scoreForRecognizedPhrase:res]);
		
		[(NSMutableString*)result appendString:[NSString stringWithFormat:@"%d. %@ (score=%f)\n", ++i, res, [recognizer scoreForRecognizedPhrase:res]]];
	}
	
	// Call to UI on main thread only !!!
	[self performSelectorOnMainThread:@selector(updateResult:) withObject:nil waitUntilDone:YES];
	
	// If you need to stop the recognizer, do it on main thread
	//[self performSelectorOnMainThread:@selector(stopRecognition:) withObject:nil waitUntilDone:YES];
}
```

This method will be invoked from the recognizer thread. Therefore, you should not make any direct UI call from there, but instead do it through a main thread invocation (or use GCD's main queue). The same hold true if you want to stop the recognizer (only from the main thread).

#### Adding some words to be recognized
Adding the words to be recognized is next done. Do not forget to call prepareRecognizer after that.

```Objective-C
[speechRecognizer addPhrase:@"flower"];
[speechRecognizer addPhrase:@"sun"];
[speechRecognizer addPhrase:@"mountain"];
[speechRecognizer addPhrase:@"river"];
[speechRecognizer addPhrase:@"sky"];
[speechRecognizer addPhrase:@"clouds"];
	
[speechRecognizer prepareRecognizer];
```

#### Starting speech recognition
Starting the recognizer is done that way:

```Objective-C
[speechRecognizer startRecognition]; 
```
 
Stopping it that way:

```Objective-C
[speechRecognizer stopRecognition];
```

Actual results are handled through the delegate you installed.

## Programming Guide
### Isolated Words and Keyword Spotting Modes
The default mode is *isolated words*, in which case the recognizer will force the audio input into one of the provided words/small phrases. *Keyword spotting* can be used instead to recognize words continuously, but works best when the number of phrases is limited (<50). 

Advantages of keyword spotting is that keywords can be recognized in the stream of speech (they don't have to be pronounced alone, but can be surrounded by other words). The words have to be distinctive, short words like numbers should be avoided if possible.

### Speech Recognition Scenarios
CeedVocal's recognizer can load different sets of phrases at different moments in your app lifetime. You decide what speech recognition scenario lives in your app. In particular, you can implement a variety of scenarios like **tap and talk once**, **tap-and-talk-multiple-times**, **push-to-talk**.

#### Loading new phrases
To load new phrases, you just need to stop the recognizer if it's running, remove existing phrases, and load new ones. And then prepare the recognizer before starting it again.

```Objective-C
[speechRecognizer stopRecognition];
[speechRecognizer removeAllPhrases];

[speechRecognizer addPhrase:@"river"];
[speechRecognizer addPhrase:@"sky"];
[speechRecognizer addPhrase:@"clouds"];
	
[speechRecognizer prepareRecognizer];
[speechRecognizer startRecognition];
```

#### Tap-and-talk-once scenario
User taps once, and speech recognition will wait for voice input. The recognizer must determine when speech is being spoken, and also recognizes contents of speech. You use this scenario in quiet environment, when the user is supposed to give a single answer to a question. That is easily achieved by invoking `-stopRecognition` from the `-speechRecognizerDidRecognizeSpeech` delegate method (be sure to actually call `-stopRecognition` on the main thread, using GCD for instance).

#### Tap-and-talk-multiple-times scenario
This scenario is very similar to the previous one, the difference being that the app waits for new commands to be pronounced after it has processed some speech. It's also best in quiet environment. The only difference in code is that you don't stop the recognizer when it gives you back results.

#### Push-to-talk scenario
The user has to tap and hold a button on screen while talking in this scenario.  It is better in a noisy environment as the user gets the control on when the speech recognition should start and stop. You implement it by invoking `-startRecognition` as the user taps, `-stopRecognition` when he releases the button. Invoking '-stopRecognition' automatically triggers speech recognition.

### Speech Recognition Accuracy
#### Quality of Audio Recording and Influence of Environment
Speech recognition accuracy is highly dependent on the quality of recorded audio signal. In a noisy environment, performance will degrade, sometimes severely. And to be honest, CeedVocal was not trained with the same amount of data than Siri, and it is therefore not as good to process speech in noisy environments.

#### Improving Speech Recognition Accuracy - Developer Side
##### Using a threshold on result confidence
When speech recognition is performed, CeedVocal typically returns multiple results, each with a score which is the confidence of the recognized sentence. 

```Objective-C
- (NSArray*)recognizedPhrases; 
- (float)scoreForRecognizedPhrase:(NSString*)phrase;`
```

Using these methods, you can filter out results that seem incoherent because they have poor scores. In Vocalia for instance, we use a threshold of 0.7 to reject bad recognition results.

##### Avoid small words
On the developer side, longer words/sentences can be used as it decreases occurrences of recognition mismatch. In particular, avoid 1-syllable words. You should typically avoid words (or phrases) that are too similar with each other, like `beach, bee, fee, gee` etc.

##### Model pronunciation variants
Words can be pronounced differently by different people, and it's also possible that some phoneme in CeedVocal's acoustic models don't reflect the exact pronunciation of specific regions. To cope with that, you can add words with different spelling: this will make CeedVocal more tolerant to input variants. Example: if you want to recognize tomato, add the following words `tomato, tomahto, tomatos, tomahtos`.

##### Use garbage modeling
Even if you are only interested in 5 words, you should probably add more words into your list (a few 10s maybe). This permits to cope with spoken phrases that are not expected by CeedVocal. On unexpected input, the closest one will be chosen, and if it's not in your initial list, you can just reject it. That's probably a better behavior than accepting it as a valid result.

#### Improve Speech Recognition - User Side
##### Clear pronunciation
Users can adapt their speech to speak more clearly and slowly. This can help. Also, talking close to the mic can help increase speech volume over background noise.
##### Using external mic
iPhone & iPad can use a mic connected to the headphone jack. You can use that to your advantage, especially if the app is also playing audio simultaneously to speech recognition.

When running on the simulator (development prototype), the built-in Mac microphone is used, and speech recognition accuracy may well depend on the distance you speak from the mic. For better results with the simulator, use an external mic (and activate it through the Mac preferences).

### Audio Session Remarks
AVAudioSession is an iOS class that handles audio devices (routing, simultaneous input/output, etc.). CeedVocal does not make any call to AVAudioSession, it's the developer job to tune it for its particular application. In particular, if your app plays audio at the same time as it does speech recognition (yes, that's possible), you'll have to tune the Audio Session accordingly (which loudspeaker vs. which device mic is used).

If you intend to use playback of audio/video along side with speech recognition, you should enable support for simultaneous audio in and out with the following code sequence (preferably as soon as the app starts):

```Objective-C
if(![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
{
	NSLog(@"setCategory error %@", error);
}
```

### Programming Notes
#### Threading
- Accessing results can only be done from within the delegate method when it is invoked
- All other API can't be called when the recognizer is running, except stopRecognition
- All CeedVocal API must be called from the main thread, except the ones marked as safe and intended to be invoked from delegate methods (`-recognizedPhrases`, `-scoreForRecognizedPhrase:`).

#### Z library
When building your own app, you will need to add "-lz" to "Other Linker Flags" of your target Build settings, as CeedVocal depends on the Z library. 

#### C++ Standard Library
You’ll also need to add libc++.dylib in the target link phase as CeedVocal is making use of the C++ Standard Template Library (STL). 

iOS provides two versions of this library, GNU’s and LLVM’s. As of iOS 7, Apple encourages all developments be made with LLVM’s version (compatible with iOS 5.0 and greater), but GNU’s version is still available if needed (iOS 4.3 or greater). As of version 1.2, CeedVocal follows Apple recommendations and links against LLVM’s version. This is the way forward and we recommend that you upgrade your project to remove dependency with GNU’s STL. We also provide an unsupported version of CeedVocal that links against GNU’s STL, in case you cannot remove GNU’s dependency with some part of your app (like if you are making use of other third party libs themselves linking against GNU’s). It is unsupported as we can’t guarantee that we’ll be able to update it depending on the evolution of developer tools.

##### For new projects built against iOS 7 SDK intended to be deployed on iOS 5.0 devices or greater, 
- LLVM is the compiler
- add libCeedVocal-universal.a to the target link phase
- add libc++.dylib to the target link phase

##### For a project intentionally using GNU’s STL to be deployed on iOS 4.3 or greater
- use any compiler
- add libCeedVocal-gnustdc++-universal.a to the target link phase
- add libstdc++6.0.9.dylib (iOS 7 SDK) or libstdc++.dylib (SDKs prior to iOS 7)

 <last update: 2013-11-07>