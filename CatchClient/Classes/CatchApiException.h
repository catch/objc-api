//
//  Copyright 2011 Catch.com, Inc.
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//      http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

//
//  CatchApiException.h
//  CatchClient
//
//  Created by Jeff Meininger on 11/9/10.
//

#import "CatchClientDefines.h"


static NSString * const CATCH_API_EXCEPTION_UNKNOWN = @"CatchApiExceptionUnknown";

static NSString * const CATCH_API_EXCEPTION_NOT_AUTHENTICATED = 
    @"CatchApiExceptionNotAuthenticated";

static NSString * const CATCH_API_EXCEPTION_PAYMENT_REQUIRED = 
    @"CatchApiExceptionPaymentRequired";

static NSString * const CATCH_API_EXCEPTION_UNSUPPORTED_MEDIA_TYPE = 
    @"CatchApiExceptionUnsupportedMediaType";

static NSString * const CATCH_API_EXCEPTION_HTTP_ERROR = 
    @"CatchApiExceptionHttpError";

static NSString * const CATCH_API_EXCEPTION_ENCODING = @"CatchApiExceptionEncoding";

static NSString * const CATCH_API_EXCEPTION_BAD_JSON = @"CatchApiExceptionBadJson";



/**
 NSException subclass thrown by many library methods.
 
 Exception names used include...
 
 - `CATCH_API_EXCEPTION_UNKNOWN` - Generic / unknown error.
 - `CATCH_API_EXCEPTION_NOT_AUTHENTICATED` - Problem with sign-in.  
 See [CatchClient accessToken].
 - `CATCH_API_EXCEPTION_PAYMENT_REQUIRED` - Account's level of service is 
 insufficient to perform the operation.
 - `CATCH_API_EXCEPTION_UNSUPPORTED_MEDIA_TYPE` - Catch.com does not support 
 this type of file.
 - `CATCH_API_EXCEPTION_HTTP_ERROR` - There was a problem communicating with the 
 server.
 - `CATCH_API_EXCEPTION_ENCODING` - Unexpected encoding received from the server.
 - `CATCH_API_EXCEPTION_BAD_JSON` - Unexpected data format received from the 
 server.
 */
@interface CatchApiException : NSException

+ (CatchApiException *)exceptionWithName:(NSString *)name 
                                 reason:(NSString *)reason 
                               userInfo:(NSDictionary *)userInfo;

- (id)initWithName:(NSString *)name 
            reason:(NSString *)reason 
          userInfo:(NSDictionary *)userInfo;


// throws CATCH_API_EXCEPTION_BAD_JSON with reason "Bad JSON."
+ (void)throwBadJsonException;

// throws CATCH_API_EXCEPTION_BAD_JSON with supplied reason
+ (void)throwBadJsonExceptionWithReason:(NSString *)reason;

@end
