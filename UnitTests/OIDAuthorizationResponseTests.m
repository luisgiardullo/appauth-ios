/*! @file OIDAuthorizationResponseTests.m
    @brief AppAuth iOS SDK
    @copyright
        Copyright 2015 Google Inc. All Rights Reserved.
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

#import "OIDAuthorizationResponseTests.h"

#import "OIDAuthorizationRequestTests.h"

#if SWIFT_PACKAGE
@import AppAuthCore;
#else
#import "Sources/AppAuthCore/OIDAuthorizationRequest.h"
#import "Sources/AppAuthCore/OIDAuthorizationResponse.h"
#import "Sources/AppAuthCore/OIDGrantTypes.h"
#import "Sources/AppAuthCore/OIDTokenRequest.h"
#endif

// Ignore warnings about "Use of GNU statement expression extension" which is raised by our use of
// the XCTAssert___ macros.
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wgnu"

/*! @brief Test value for the @c authorizationCode property.
 */
static NSString *const kTestAuthorizationCode = @"Code";

/*! @brief Test value for the @c authorizationCodeVerifier property.
 */
static NSString *const kTestAuthorizationCodeVerifier = @"Verifier";

/*! @brief Test key for the @c additionalParameters property.
 */
static NSString *const kTestAdditionalParameterKey = @"A";

/*! @brief Test value for the @c additionalParameters property.
 */
static NSString *const kTestAdditionalParameterValue = @"1";

/*! @brief Test value for the @c state property.
 */
static NSString *const kTestState = @"State";

/*! @brief Test value for the @c accessToken property.
 */
static NSString *const kTestAccessToken = @"Access Token";

/*! @brief Test value for the @c accessTokenExpirationDate property.
 */
static long long const kTestExpirationSeconds = 60;

/*! @brief Test value for the @c idToken property.
 */
static NSString *const kTestIDToken = @"ID Token";

/*! @brief Test value for the @c tokenType property.
 */
static NSString *const kTestTokenType = @"Token Type";

/*! @brief Test value for the @c scopes property.
 */
static NSString *const kTestScope = @"Scope";

/*! @brief Test key for an entry in the @c additionalParameters property of the token exchange
        request.
 */
static NSString *const kTestTokenExchangeParameterKey = @"B";

/*! @brief Test value for an entry in the @c additionalParameters property of the token exchange
        request.
 */
static NSString *const kTestTokenExchangeParameterValue = @"2";

/*! @brief Test key for an entry in the @c additionalHeaders property of the token exchange
        request.
 */
static NSString *const kTestTokenExchangeHeaderKey = @"C";

/*! @brief Test value for an entry in the @c additionalHeaders property of the token exchange
        request.
 */
static NSString *const kTestTokenExchangeHeaderValue = @"3";

@implementation OIDAuthorizationResponseTests

+ (OIDAuthorizationResponse *)testInstance {
  OIDAuthorizationRequest *request = [OIDAuthorizationRequestTests testInstance];
  OIDAuthorizationResponse *response =
      [[OIDAuthorizationResponse alloc] initWithRequest:request parameters:@{
        @"code" : kTestAuthorizationCode,
        @"code_verifier" : kTestAuthorizationCodeVerifier,
        @"state" : kTestState,
        @"access_token" : kTestAccessToken,
        @"expires_in" : @(kTestExpirationSeconds),
        @"id_token" : kTestIDToken,
        @"token_type" : kTestTokenType,
        @"scope" : kTestScope,
        kTestAdditionalParameterKey : kTestAdditionalParameterValue
      }];
  return response;
}

+ (OIDAuthorizationResponse *)testInstanceCodeFlow {
  OIDAuthorizationRequest *request = [OIDAuthorizationRequestTests testInstanceCodeFlow];
  OIDAuthorizationResponse *response =
      [[OIDAuthorizationResponse alloc] initWithRequest:request parameters:@{
        @"code" : kTestAuthorizationCode,
        @"code_verifier" : kTestAuthorizationCodeVerifier,
        @"state" : kTestState,
        @"token_type" : OIDGrantTypeAuthorizationCode,
        kTestAdditionalParameterKey : kTestAdditionalParameterValue
      }];
  return response;
}

+ (OIDAuthorizationResponse *)testInstanceCodeFlowClientAuth {
  OIDAuthorizationRequest *request = [OIDAuthorizationRequestTests testInstanceCodeFlowClientAuth];
  OIDAuthorizationResponse *response =
      [[OIDAuthorizationResponse alloc] initWithRequest:request parameters:@{
        @"code" : kTestAuthorizationCode,
        @"code_verifier" : kTestAuthorizationCodeVerifier,
        @"state" : kTestState,
        @"token_type" : OIDGrantTypeAuthorizationCode,
        kTestAdditionalParameterKey : kTestAdditionalParameterValue
      }];
  return response;
}

/*! @brief Tests the @c NSCopying implementation by round-tripping an instance through the copying
        process and checking to make sure the source and destination instances are equivalent.
 */
- (void)testCopying {
  OIDAuthorizationResponse *response = [[self class] testInstance];
  XCTAssertEqualObjects(response.authorizationCode, kTestAuthorizationCode, @"");
  XCTAssertEqualObjects(response.state, kTestState, @"");
  XCTAssertEqualObjects(response.accessToken, kTestAccessToken, @"");
  XCTAssertEqualObjects(response.idToken, kTestIDToken, @"");
  XCTAssertEqualObjects(response.tokenType, kTestTokenType, @"");
  XCTAssertEqualObjects(response.scope, kTestScope, @"");
  XCTAssertEqualObjects(response.additionalParameters[kTestAdditionalParameterKey],
                        kTestAdditionalParameterValue, @"");

  // Should be ~ kTestExpirationSeconds seconds. Avoiding swizzling NSDate here for certainty
  // to keep dependencies down, and simply making an assumption that this check will be executed
  // relatively quickly after the initialization above (less than 5 seconds.)
  NSTimeInterval expiration = [response.accessTokenExpirationDate timeIntervalSinceNow];
  XCTAssert(expiration > kTestExpirationSeconds - 5 && expiration <= kTestExpirationSeconds, @"");

  OIDAuthorizationResponse *responseCopy = [response copy];

  XCTAssertEqualObjects(responseCopy.request, response.request, @"");
  XCTAssertEqualObjects(responseCopy.authorizationCode, response.authorizationCode, @"");
  XCTAssertEqualObjects(responseCopy.state, response.state, @"");
  XCTAssertEqualObjects(responseCopy.accessToken, response.accessToken, @"");
  XCTAssertEqualObjects(responseCopy.accessTokenExpirationDate,
                        response.accessTokenExpirationDate, @"");
  XCTAssertEqualObjects(responseCopy.idToken, response.idToken, @"");
  XCTAssertEqualObjects(responseCopy.tokenType, response.tokenType, @"");
  XCTAssertEqualObjects(responseCopy.scope, response.scope, @"");
  XCTAssertEqualObjects(responseCopy.additionalParameters,
                        response.additionalParameters, @"");
}

/*! @brief Tests the @c NSSecureCoding by round-tripping an instance through the coding process and
        checking to make sure the source and destination instances are equivalent.
 */
- (void)testSecureCoding {
  OIDAuthorizationResponse *response = [[self class] testInstance];
  NSError *error;
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:response
                                       requiringSecureCoding:YES
                                                       error:&error];
  OIDAuthorizationResponse *responseCopy =
      [NSKeyedUnarchiver unarchivedObjectOfClass:[OIDAuthorizationResponse class]
                                        fromData:data
                                           error:&error];

  // Not a full test of the request deserialization, but should be sufficient as a smoke test
  // to make sure the request IS actually getting serialized and deserialized in the
  // NSSecureCoding implementation. We'll leave it up to the OIDAuthorizationRequest tests to make
  // sure the NSSecureCoding implementation of that class is correct.
  XCTAssertNotNil(responseCopy.request, @"");
  XCTAssertEqualObjects(responseCopy.request.clientID, response.request.clientID, @"");

  XCTAssertEqualObjects(responseCopy.authorizationCode, kTestAuthorizationCode, @"");
  XCTAssertEqualObjects(responseCopy.state, kTestState, @"");
  XCTAssertEqualObjects(responseCopy.accessToken, kTestAccessToken, @"");
  XCTAssertEqualObjects(responseCopy.idToken, kTestIDToken, @"");
  XCTAssertEqualObjects(responseCopy.tokenType, kTestTokenType, @"");
  XCTAssertEqualObjects(responseCopy.scope, kTestScope, @"");
  XCTAssertEqualObjects(responseCopy.accessTokenExpirationDate, response.accessTokenExpirationDate,
                        @"");
  XCTAssertEqualObjects(responseCopy.additionalParameters[kTestAdditionalParameterKey],
                        kTestAdditionalParameterValue, @"");
}

/*! @brief Tests that @c OIDAuthorizationResponse.tokenExchangeRequest creates a token request
        with the correct parameters from the authorization response and its originating request.
 */
- (void)testTokenExchangeRequest {
  OIDAuthorizationResponse *response = [[self class] testInstanceCodeFlow];
  OIDTokenRequest *tokenExchangeRequest = [response tokenExchangeRequest];

  XCTAssertEqualObjects(tokenExchangeRequest.configuration, response.request.configuration, @"");
  XCTAssertEqualObjects(tokenExchangeRequest.grantType, OIDGrantTypeAuthorizationCode, @"");
  XCTAssertEqualObjects(tokenExchangeRequest.authorizationCode, response.authorizationCode, @"");
  XCTAssertEqualObjects(tokenExchangeRequest.redirectURL, response.request.redirectURL, @"");
  XCTAssertEqualObjects(tokenExchangeRequest.clientID, response.request.clientID, @"");
  XCTAssertNil(tokenExchangeRequest.clientSecret, @"");
  XCTAssertNil(tokenExchangeRequest.scope, @"");
  XCTAssertNil(tokenExchangeRequest.refreshToken, @"");
  XCTAssertEqualObjects(tokenExchangeRequest.codeVerifier, response.request.codeVerifier, @"");
  XCTAssertEqual(tokenExchangeRequest.additionalParameters.count, 0, @"");
  XCTAssertEqual(tokenExchangeRequest.additionalHeaders.count, 0, @"");
}

/*! @brief Tests that a token exchange request created from an authorization response whose
        originating request used client authentication carries over the client secret.
 */
- (void)testTokenExchangeRequestClientAuth {
  OIDAuthorizationResponse *response = [[self class] testInstanceCodeFlowClientAuth];
  OIDTokenRequest *tokenExchangeRequest = [response tokenExchangeRequest];

  XCTAssertNotNil(response.request.clientSecret, @"");
  XCTAssertEqualObjects(tokenExchangeRequest.clientSecret, response.request.clientSecret, @"");
}

/*! @brief Tests that additional parameters and headers passed to @c
        OIDAuthorizationResponse.tokenExchangeRequestWithAdditionalParameters:additionalHeaders:
        are set on the token request.
 */
- (void)testTokenExchangeRequestAdditionalParametersAndHeaders {
  OIDAuthorizationResponse *response = [[self class] testInstanceCodeFlow];
  OIDTokenRequest *tokenExchangeRequest =
      [response tokenExchangeRequestWithAdditionalParameters:
          @{ kTestTokenExchangeParameterKey : kTestTokenExchangeParameterValue }
                                           additionalHeaders:
          @{ kTestTokenExchangeHeaderKey : kTestTokenExchangeHeaderValue }];

  XCTAssertEqualObjects(tokenExchangeRequest.authorizationCode, response.authorizationCode, @"");
  XCTAssertEqualObjects(tokenExchangeRequest.additionalParameters,
                        @{ kTestTokenExchangeParameterKey : kTestTokenExchangeParameterValue },
                        @"");
  XCTAssertEqualObjects(tokenExchangeRequest.additionalHeaders,
                        @{ kTestTokenExchangeHeaderKey : kTestTokenExchangeHeaderValue },
                        @"");
}

/*! @brief Tests that attempting to create a token exchange request from an authorization
        response with no authorization code throws an exception.
 */
- (void)testTokenExchangeRequestNoAuthorizationCode {
  OIDAuthorizationRequest *request = [OIDAuthorizationRequestTests testInstanceCodeFlow];
  OIDAuthorizationResponse *response =
      [[OIDAuthorizationResponse alloc] initWithRequest:request
                                             parameters:@{ @"state" : kTestState }];

  XCTAssertNil(response.authorizationCode, @"");
  XCTAssertThrows([response tokenExchangeRequest], @"");
  XCTAssertThrows([response tokenExchangeRequestWithAdditionalParameters:nil], @"");
  XCTAssertThrows([response tokenExchangeRequestWithAdditionalParameters:nil
                                                       additionalHeaders:nil], @"");
}

@end

#pragma GCC diagnostic pop
