//
//  CVSpeechRecognizer.h
//  Ceed Vocal SDK
//
//  Created by Raphael on 20/05/08.
//  Copyright 2008 Creaceed SPRL. All rights reserved.

#import <Foundation/Foundation.h>

// The `CVRecognitionMode` constants define the main behavior of the recognizer.
typedef enum
{
	CV_ISOLATED_PHRASES = 0, 	// default mode, only the provided phrases will be recognized
	CV_KEYWORD_SPOTTING = 1,	// same as isolated phrases but a garbage model is provided, words are recognized in the stream of speech
	CV_GRAMMAR = 2,				// grammar given by user, need to provide grammar and vocabulary (not yet available)
} CVRecognitionMode;

// The `CVRecognitionLanguage` allows you to choose speech recognition language.
typedef enum CVRecognitionLanguage
{
	CV_LANGUAGE_ENGLISH=0,
	CV_LANGUAGE_FRENCH=1,
	CV_LANGUAGE_SPANISH=2,
	CV_LANGUAGE_GERMAN=3,
	CV_LANGUAGE_DUTCH=4,
	CV_LANGUAGE_ITALIAN=5
} CVRecognitionLanguage;

// NSNumber with boolean. A value of YES means that speech recognition processing starts during the recording. NO means that speech recognition is made at the end of the recording. Default is YES
extern NSString * const kCVSpeechRecognizerRealtimeProcessingOptionKey;

@class CVSpeechRecognizer;

// Informal protocol for `CVSpeechRecognizer` delegate.
@interface NSObject (CVSpeechRecognizerDelegation)

// Implement this method in your delegate to be notified whenever an audio buffer is received. You can use this for instance to compute/display a waveform in your app.
// @warning this method is executed from internal audio thread and should return as soon as possible. Also, as it not invoked from the main thread, you can't interact with the UI.
- (void)speechRecognizerDidReceiveAudioBuffer:(const int16_t*)buf sampleCount:(uint32_t)count;
// Implement this method in your delegate to be notified whenever speech is being processed.
// @warning this method is executed from internal audio thread and should return as soon as possible. Also, as it not invoked from the main thread, you can't interact with the UI.
- (void)speechRecognizerDidStartProcessingSpeech:(CVSpeechRecognizer*)recognizer;
// Implement this method to process speech recognition results. You can further query the recognizer using the `-recognizedPhrases` and `-scoreForRecognizedPhrase:` methods (see below).
// @warning this method is executed from internal audio thread and should return as soon as possible. Also, as it not invoked from the main thread, you can't interact with the UI nor with the recognizer itself (except for the methods mentionned above).
- (void)speechRecognizerDidRecognizeSpeech:(CVSpeechRecognizer*)recognizer;
@end

struct CVSpeechRecognizerPrivateData;

// The `CVSpeechRecognizer` class gives access to speech recognition capabilities to your app.
@interface CVSpeechRecognizer : NSObject {
	struct CVSpeechRecognizerPrivateData *_privateData;
}

// Recognizer delegate. See methods above.
@property (readwrite, assign) id delegate;
// Set the maximum number of returned recognition results.
@property (readwrite) uint32_t numberOfRequestedResults;
// Whether speech recognition should vibrate when its ready to process speech.
@property (readwrite) BOOL vibratesWhenReady;
// Whether the speech recognition has already been started
@property (readonly) BOOL recognitionStarted;
// Tells how much audio has been going through this recognizer. 0 on init, then always increasing
@property (readonly) float audioStreamDuration;
// Tells how much speech audio (identified as such by the recognizer) has been going through this recognizer. 0 on init, then always increasing
@property (readonly) float speechStreamDuration;

// License (either eval or full) must be set prior to any other API calls.
+ (void)setLicense:(NSString*)license;
// Release any audio resources used by the library. These are automatically recreated if needed at a later time.
+ (void)terminateAudioQueue;

#pragma mark - Creating a new speech recognizer -
- (CVSpeechRecognizer*)initWithLanguage:(CVRecognitionLanguage)lang acousticModel:(NSString*)modelpath;
- (CVSpeechRecognizer*)initWithLanguage:(CVRecognitionLanguage)lang acousticModel:(NSString*)modelpath mode:(CVRecognitionMode)mode;
- (CVSpeechRecognizer*)initWithLanguage:(CVRecognitionLanguage)lang acousticModel:(NSString*)modelpath mode:(CVRecognitionMode)mode options:(NSDictionary*)options;

#pragma mark - Setting up phrases to recognize -
// Adding & removing phrase (with a stopped recognizer & prior to `-prepareRecognizer`)
- (void)removeAllPhrases;
- (void)addPhrase:(NSString*)phrase;
- (void)addPhrases:(NSArray*)phrases;

#pragma mark - Obtaining recognition information -
// Returns an array containing the recognized phrases.
// @warning This method may only be directly invoked within the `-speechRecognizerDidRecognizeSpeech:` method.
- (NSArray*)recognizedPhrases;
// Returns the recognition score of a particular recognized phrases obtained from `-recognizedPhrases`.
// @warning This method may only be directly invoked within the `-speechRecognizerDidRecognizeSpeech:` method.
- (float)scoreForRecognizedPhrase:(NSString*)phrase;

#pragma mark - Managing recognizer state -
// Invoke this method on a stopped recognizer, after adding/removing phrases, and before starting the recognition.
- (void)prepareRecognizer;
// Start speech recognition with previously added phrases.
- (void)startRecognition;
// Stop speech recognition. That triggers the recognition if there's any pending unprocessed speech.
- (void)stopRecognition;

@end
