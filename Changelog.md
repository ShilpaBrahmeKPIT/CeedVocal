#### version 1.2 — 2014-02
- Full support for 32 and 64-bit ARM (in addition to armv7 & armv7s)
- Full support for 32 and 64-bit iOS Simulator (x86)
- Built for iOS SDK 7.0 (compatible with 5.0 or higher. 4.3 still possible but with limitations, see doc.)
- Updated documentation with special considerations for C++ STL (LLVM vs. GNU)

#### version 1.1.6 — 2012-09
- built for iOS SDK 6.0 (still compatible with iOS4.3 devices with armv7 arch)
- drop of the armv6 arch (iPhone 3G not supported)
- support for the following archs: armv7, armv7s, i386

#### version 1.1.5 — 2011-12
- built for iOS SDK 5.0 (still compatible with iOS4 devices)

#### version 1.1.4 — 2011-07
- built for iOS SDK 4.3

#### version 1.1.3 — 2011-02
- built for iOS SDK 4.2

#### version 1.1.2 — 2010-09
- fixed duplicate arch symbols in lib

#### version 1.1.1 — 2010-07
- fixed results ordering

#### version 1.1 — 2010-06
- better termination of audio threads
- support for universal iOS4 development: 
	- armv6 for iPhone <= 3G 
	- armv7 for iPhone >= 3GS, iPad
	- i386 for Simulator
- support for realtime processing
- bug fixes
- better acoustic models (FR, DE, IT, ES)

#### version 1.0.5 — 2009-11
- new API for notifying start of speech processing
- fixed a bug occurring when stopping/restarting recognizer with changed phrases.

#### version 1.0.4 — 2009-10
- initial support for keyword spotting

#### version 1.0.3 — 2009-08
- additional info in the documentation

#### version 1.0.2 — 2009-07
- small fixes

#### version 1.0.1 — 2009-07
- exposed audio buffers

#### version 1.0 — 2009-07
- initial release of CeedVocal SDK, based on Julius and FLite.
- CeedVocal SDK is based on a modified version of Julius 4.0.2/4.1. These modifications were made by Creaceed SPRL on 2008-07-01 and revised on 2008-12-01.