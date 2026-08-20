/*! @file OIDErrorUtilitiesTests.m
 @brief AppAuth iOS SDK
 @copyright
        Copyright 2026 The AppAuth for iOS Authors. All Rights Reserved.
 @copydetails
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <XCTest/XCTest.h>

#if SWIFT_PACKAGE
@import AppAuthCore;
#else
#import "Sources/AppAuthCore/OIDErrorUtilities.h"
#endif

@interface OIDErrorUtilitiesTests : XCTestCase
@end
@implementation OIDErrorUtilitiesTests

- (void)testErrorWithCodeUsesCustomDescription {
  NSError *error = [OIDErrorUtilities errorWithCode:OIDErrorCodeNetworkError
                                    underlyingError:nil
                                        description:@"Custom description."];
  XCTAssertEqualObjects(error.domain, OIDGeneralErrorDomain, @"");
  XCTAssertEqual(error.code, OIDErrorCodeNetworkError, @"");
  XCTAssertEqualObjects(error.localizedDescription, @"Custom description.", @"");
}

- (void)testErrorWithCodePopulatesDescriptionFromCode {
  NSError *error = [OIDErrorUtilities errorWithCode:OIDErrorCodeUserCanceledAuthorizationFlow
                                    underlyingError:nil
                                        description:nil];
  XCTAssertEqualObjects(error.localizedDescription,
                        @"The authorization flow was canceled by the user.",
                        @"");
}

- (void)testErrorWithCodePopulatesDescriptionForEachCode {
  NSArray<NSNumber *> *codes = @[
    @(OIDErrorCodeInvalidDiscoveryDocument),
    @(OIDErrorCodeUserCanceledAuthorizationFlow),
    @(OIDErrorCodeProgramCanceledAuthorizationFlow),
    @(OIDErrorCodeNetworkError),
    @(OIDErrorCodeServerError),
    @(OIDErrorCodeJSONDeserializationError),
    @(OIDErrorCodeTokenResponseConstructionError),
    @(OIDErrorCodeSafariOpenError),
    @(OIDErrorCodeBrowserOpenError),
    @(OIDErrorCodeTokenRefreshError),
    @(OIDErrorCodeRegistrationResponseConstructionError),
    @(OIDErrorCodeJSONSerializationError),
    @(OIDErrorCodeIDTokenParsingError),
    @(OIDErrorCodeIDTokenFailedValidationError),
    @(OIDErrorCodeURLMismatch),
    @(OIDErrorCodeInvalidAuthorizationFlow),
  ];
  for (NSNumber *code in codes) {
    NSError *error = [OIDErrorUtilities errorWithCode:[code integerValue]
                                      underlyingError:nil
                                          description:nil];
    XCTAssertNotNil(error.userInfo[NSLocalizedDescriptionKey],
                    @"Missing description for error code %@", code);
    XCTAssertGreaterThan(error.localizedDescription.length, (NSUInteger)0,
                         @"Empty description for error code %@", code);
    XCTAssertFalse([error.localizedDescription containsString:@"unknown error"],
                   @"Generic description for error code %@", code);
  }
}

- (void)testErrorWithCodePopulatesFallbackDescriptionForUnknownCode {
  NSError *error = [OIDErrorUtilities errorWithCode:(OIDErrorCode)-12345
                                    underlyingError:nil
                                        description:nil];
  XCTAssertEqualObjects(error.localizedDescription, @"An unknown error occurred.", @"");
}

- (void)testErrorWithCodeSetsUnderlyingError {
  NSError *underlyingError = [NSError errorWithDomain:NSURLErrorDomain
                                                 code:NSURLErrorTimedOut
                                             userInfo:nil];
  NSError *error = [OIDErrorUtilities errorWithCode:OIDErrorCodeNetworkError
                                    underlyingError:underlyingError
                                        description:nil];
  XCTAssertEqualObjects(error.userInfo[NSUnderlyingErrorKey], underlyingError, @"");
}

@end
