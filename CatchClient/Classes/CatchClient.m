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
//  CatchClient.m
//  CatchClient
//
//  Created by Jeff Meininger on 11/8/10.
//

#import "CatchClient.h"
#import "CatchApiException.h"
#import "CatchApiNote.h"
#import "CatchApiNoteRef.h"
#import "CatchApiComment.h"
#import "CatchApiNote+CatchClientPrivate.h"
#import "CatchApiComment+CatchClientPrivate.h"
#import "NSDictionary+TypeChecked.h"
#import "NSNumber+OSTypes.h"
#import "NSData+JsonParanoia.h"
#import "NSObject+JsonParanoia.h"
#import "GTMBase64.h"
#import "GTMNSDictionary+URLArguments.h"
#import "NSString+SBJSON.h"
#import "NSObject+SBJSON.h"
#import "ASIFormDataRequest.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import "GTMSystemVersion.h"
#endif

#include <sys/types.h>
#include <sys/sysctl.h>


static NSString * const APP_NAME = @"CatchClient";

static NSString * const API_SCHEME = @"https";
static NSString * const API_SERVER = @"catch.com";


NSDateFormatter *CatchApiRfc3339Formatter__ = nil;



@interface CatchClient ()

- (NSString *)composeUserAgent;

@end



@implementation CatchClient

@synthesize appName = appName_;
@synthesize appVersion = appVersion_;
@synthesize appUrl = appUrl_;
@synthesize accessToken = accessToken_;
@synthesize logDelegate = logDelegate_;
@synthesize apiScheme = apiScheme_;
@synthesize apiServer = apiServer_;
@synthesize userAgent = userAgent_;



- (id)initWithAppName:(NSString *)appName 
              version:(NSString *)appVersion 
                  url:(NSString *)appUrl
{
    // library entry point
    if (!CatchApiRfc3339Formatter__) {
        // set global variables
        CatchApiRfc3339Formatter__ = [[NSDateFormatter alloc] init];
        [CatchApiRfc3339Formatter__ setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:
                                                @"en_US_POSIX"] autorelease]];
        [CatchApiRfc3339Formatter__ setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
        [CatchApiRfc3339Formatter__ setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        
        // configure ASIHTTPRequest
        [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
    }
    
    // back to normal object initialization
    if ((self = [super init])) {
        self.appName = appName;
        self.appVersion = appVersion;
        self.appUrl = appUrl;
        
        self.apiScheme = API_SCHEME;
        self.apiServer = API_SERVER;
        self.userAgent = [self composeUserAgent];
    }
    
    return self;
}


- (id)init
{
    return [self initWithAppName:APP_NAME version:nil url:nil];
}


- (void)dealloc
{
    self.appName = nil;
    self.appVersion = nil;
    self.appUrl = nil;
    self.accessToken = nil;
    self.apiScheme = nil;
    self.apiServer = nil;
    self.userAgent = nil;
    
    [super dealloc];
}



- (void)signIn:(NSString *)usernameOrEmail password:(NSString *)password
{
    NSDictionary *params = [NSDictionary dictionaryWithObject:@"dummy" 
                                                       forKey:@"dummy"];
    ASIHTTPRequest *request = [self requestForMethod:@"POST" 
                                            endpoint:@"/v2/user" 
                                          parameters:params];
    [request addBasicAuthenticationHeaderWithUsername:usernameOrEmail 
                                          andPassword:password];
    NSData *data = [self executeRequest:request];
    NSDictionary *response = [NSData dictionaryFromJsonData:data];
    
    NSDictionary *dict = [response dictionaryForKey:@"user"];
    NSString *token = [dict stringForKey:@"access_token"];
    if (!token) [CatchApiException throwBadJsonException];
    self.accessToken = token;
}


- (CatchAccount *)getAccountInfo
{
    NSData *data = [self executeHttpMethod:@"GET" 
                                  endpoint:@"/v2/user" 
                                parameters:[self authenticatedParameters:nil]];
    NSDictionary *response = [NSData dictionaryFromJsonData:data];
    
    NSDictionary *dict = [response dictionaryForKey:@"user"];
    CatchAccount *ret = [[CatchAccount alloc] initWithJsonDict:dict];
    if (!ret) [CatchApiException throwBadJsonException];
    return [ret autorelease];
}


- (NSArray *)getAllNoteRefs
{
    NSData *data = [self executeHttpMethod:@"GET" 
                                  endpoint:@"/v2/notes" 
                                parameters:[self authenticatedParameters:nil]];
    NSDictionary *response = [NSData dictionaryFromJsonData:data];
    
    NSArray *refDicts = [response arrayForKey:@"notes"];
    if (!refDicts) [CatchApiException throwBadJsonException];
    
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:[refDicts count]];
    for (NSDictionary *dict in refDicts) {
        [NSObject verifyJsonObject:dict isOfClass:[NSDictionary class]];
        CatchApiNoteRef *ref = [[CatchApiNoteRef alloc] initWithJsonDict:dict];
        if (!ref) [CatchApiException throwBadJsonException];
        [ret addObject:[ref autorelease]];
    }
    
    return ret;
}


- (NSArray *)getNotesForNoteRefs:(NSArray *)noteRefs
{
    NSMutableArray *noteIds = [NSMutableArray arrayWithCapacity:[noteRefs count]];
    for (CatchApiNoteRef *ref in noteRefs) {
        [noteIds addObject:ref.noteId];
    }
    
    return [self getNotesForNoteIds:noteIds];
}


- (NSArray *)getNotesForNoteIds:(NSArray *)noteIds
{
    if ([noteIds count] == 0) return [NSArray array];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:noteIds forKey:@"notes"];
    NSString *json = [dict JSONRepresentation];
    if (!json) [CatchApiException throwBadJsonException];
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:json forKey:@"bulk"];
    NSData *data = [self executeHttpMethod:@"POST" endpoint:@"/v2/bulk_notes" 
                                parameters:[self authenticatedParameters:params]];
    NSDictionary *response = [NSData dictionaryFromJsonData:data];
    
    NSArray *noteDicts = [response arrayForKey:@"notes"];
    if (!noteDicts) [CatchApiException throwBadJsonException];
    
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:[noteDicts count]];
    for (NSDictionary *dict in noteDicts) {
        [ret addObject:[CatchApiNote noteFromDict:dict]];
    }
    
    return ret;
}


- (NSArray *)getCommentsForNoteId:(NSString *)noteId
{
    NSData *data = [self executeHttpMethod:@"GET" 
                                  endpoint:[NSString stringWithFormat:@"/v2/comments/%@", noteId] 
                                parameters:[self authenticatedParameters:nil]];
    NSDictionary *response = [NSData dictionaryFromJsonData:data];
    
    NSArray *commentDicts = [response arrayForKey:@"notes"];
    if (!commentDicts) [CatchApiException throwBadJsonException];
    
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:[commentDicts count]];
    for (NSDictionary *dict in commentDicts) {
        [ret addObject:[CatchApiComment commentFromDict:dict parentId:noteId]];
    }
    
    return ret;
}


- (NSData *)getMediaWithId:(NSString *)mediaId 
             forNoteWithId:(NSString *)noteId 
                parameters:(NSDictionary *)params
{
    return [self executeHttpMethod:@"GET" 
                          endpoint:[NSString stringWithFormat:@"/v2/media/%@/%@", noteId, mediaId] 
                        parameters:[self authenticatedParameters:params]];
}


- (NSData *)getImageWithId:(NSString *)mediaId 
             forNoteWithId:(NSString *)noteId 
                    ofSize:(CatchImageSize)size
{
    NSArray *sizes = [NSArray arrayWithObjects:
                      @"small", @"medium", @"large", @"original", nil];
    NSAssert(size < [sizes count], @"Image size option out-of-bounds.");
    
    return [self getMediaWithId:mediaId 
                  forNoteWithId:noteId 
                     parameters:[NSDictionary dictionaryWithObject:
                                 [sizes objectAtIndex:size] forKey:@"size"]];
}


- (NSData *)getMediaWithId:(NSString *)mediaId forNoteWithId:(NSString *)noteId
{
    return [self getMediaWithId:mediaId forNoteWithId:noteId parameters:nil];
}



// called by addNote
- (void)populateStandardNoteFields:(CatchApiNote *)note
{
    if (self.appName && !note.source) note.source = self.appName;
    if (self.appUrl && !note.sourceUrl) note.sourceUrl = self.appUrl;
    if ((note.created == NOT_SET_S64) || (note.modified == NOT_SET_S64)) {
        SInt64 now = [[NSDate date] timeIntervalSince1970]*1000.0;
        if (note.created == NOT_SET_S64) note.created = now;
        if (note.modified == NOT_SET_S64) note.modified = now;
    }
}


- (CatchApiNote *)addNote:(CatchApiNote *)note
{
    // ensure some note fields are set
    [self populateStandardNoteFields:note];
    
    // add the note
    NSDictionary *params = [note httpArgsForAdd];
    NSData *data = [self executeHttpMethod:@"POST" 
                                  endpoint:@"/v2/notes" 
                                parameters:[self authenticatedParameters:params]];
    NSDictionary *response = [NSData dictionaryFromJsonData:data];
    
    NSArray *noteDicts = [response arrayForKey:@"notes"];
    if (!noteDicts || [noteDicts count] < 1) [CatchApiException throwBadJsonException];
    return [CatchApiNote noteFromDict:[noteDicts objectAtIndex:0]];
}



- (CatchApiNote *)commonUpdateNote:(CatchApiNote *)note params:(NSDictionary *)params
{
    NSAssert(note.noteId != nil, @"You cannot edit a note without a noteId.");
    
    NSData *data = [self executeHttpMethod:@"POST" 
                                  endpoint:[NSString stringWithFormat:@"/v2/notes/%@", note.noteId] 
                                parameters:[self authenticatedParameters:params]];
    NSDictionary *response = [NSData dictionaryFromJsonData:data];
    
    NSArray *noteDicts = [response arrayForKey:@"notes"];
    if (!noteDicts || [noteDicts count] < 1) [CatchApiException throwBadJsonException];
    return [CatchApiNote noteFromDict:[noteDicts objectAtIndex:0]];
}


- (CatchApiNote *)forceUpdateNote:(CatchApiNote *)note
{
    return [self commonUpdateNote:note params:[note httpArgsForForceUpdate]];
}


- (void)forceDeleteNoteWithId:(NSString *)noteId
{
    [self executeHttpMethod:@"DELETE" 
                   endpoint:[NSString stringWithFormat:@"/v2/notes/%@", noteId] 
                 parameters:[self authenticatedParameters:nil]];
}



// called by forceAddComment
- (void)populateStandardCommentFields:(CatchApiComment *)comment
{
    if (self.appName && !comment.source) comment.source = self.appName;
    if (self.appUrl && !comment.sourceUrl) comment.sourceUrl = self.appUrl;
    if ((comment.created == NOT_SET_S64) || (comment.modified == NOT_SET_S64)) {
        SInt64 now = [[NSDate date] timeIntervalSince1970]*1000.0;
        if (comment.created == NOT_SET_S64) comment.created = now;
        if (comment.modified == NOT_SET_S64) comment.modified = now;
    }
}


- (CatchApiComment *)forceAddComment:(CatchApiComment *)comment
{
    // ensure some comment fields are set
    [self populateStandardCommentFields:comment];
    
    // add the comment
    NSDictionary *params = [comment httpArgsForAdd];
    NSData *data = [self executeHttpMethod:@"POST" 
                                  endpoint:[NSString stringWithFormat:@"/v2/comments/%@", comment.parentId] 
                                parameters:[self authenticatedParameters:params]];
    NSDictionary *response = [NSData dictionaryFromJsonData:data];
    
    NSArray *noteDicts = [response arrayForKey:@"notes"];
    if (!noteDicts || [noteDicts count] < 1) [CatchApiException throwBadJsonException];
    return [CatchApiComment commentFromDict:[noteDicts objectAtIndex:0] 
                               parentId:comment.parentId];
}


- (CatchApiComment *)commonUpdateComment:(CatchApiComment *)comment 
                                  params:(NSDictionary *)params
{
    NSAssert(comment.parentId != nil, @"You cannot edit a comment without a parentId.");
    NSAssert(comment.commentId != nil, @"You cannot edit a comment without a commentId.");
    
    NSData *data = [self executeHttpMethod:@"POST" 
                                  endpoint:[NSString stringWithFormat:@"/v2/comment/%@", comment.parentId] 
                                parameters:[self authenticatedParameters:params]];
    NSDictionary *response = [NSData dictionaryFromJsonData:data];
    
    NSArray *noteDicts = [response arrayForKey:@"notes"];
    if (!noteDicts || [noteDicts count] < 1) [CatchApiException throwBadJsonException];
    return [CatchApiComment commentFromDict:[noteDicts objectAtIndex:0] 
                               parentId:comment.parentId];
}


- (CatchApiComment *)forceUpdateComment:(CatchApiComment *)comment
{
    return [self commonUpdateComment:comment 
                              params:[comment httpArgsForForceUpdate]];
}


- (void)forceDeleteCommentWithId:(NSString *)commentId fromNoteWithId:(NSString *)noteId
{
    NSDictionary *params = [NSDictionary dictionaryWithObject:commentId 
                                                       forKey:@"comment"];
    
    [self executeHttpMethod:@"DELETE" 
                   endpoint:[NSString stringWithFormat:@"/v2/comment/%@", noteId] 
                 parameters:[self authenticatedParameters:params]];
}



- (CatchApiMediaRef *)forceAddMedia:(NSData *)media 
                             ofType:(NSString *)mimeType 
                              named:(NSString *)filename 
                       toNoteWithId:(NSString *)noteId 
                             params:(NSDictionary *)params
{
    NSData *data = [self executeHttpPostAttachment:media 
                                            ofType:mimeType 
                                             named:filename 
                                          endpoint:[NSString stringWithFormat:@"/v2/media/%@", noteId] 
                                        parameters:[self authenticatedParameters:params]];
    NSDictionary *response = [NSData dictionaryFromJsonData:data];
    
    CatchApiMediaRef *ret = [[CatchApiMediaRef alloc] initWithJsonDict:response];
    if (!ret) [CatchApiException throwBadJsonException];
    return [ret autorelease];
}


- (CatchApiMediaRef *)forceAddMedia:(NSData *)media 
                             ofType:(NSString *)mimeType 
                              named:(NSString *)filename 
                          createdAt:(SInt64)created 
                       toNoteWithId:(NSString *)noteId
{
    NSDictionary *params = [NSDictionary dictionaryWithObject:[NSNumber numberWithSInt64:created] 
                                                       forKey:@"created_at"];
    return [self forceAddMedia:media 
                        ofType:mimeType 
                         named:filename 
                  toNoteWithId:noteId 
                        params:params];
}


- (CatchApiMediaRef *)forceAddVoice:(NSData *)media 
                             ofType:(NSString *)mimeType 
                              named:(NSString *)filename 
                          createdAt:(SInt64)created 
                       toNoteWithId:(NSString *)noteId
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithSInt64:created], @"created_at", 
                            [NSNumber numberWithBool:YES], 
                            @"voicenote_hint", nil];
    return [self forceAddMedia:media 
                        ofType:mimeType 
                         named:filename 
                  toNoteWithId:noteId 
                        params:params];
}


- (void)forceDeleteMediaWithId:(NSString *)mediaId 
                fromNoteWithId:(NSString *)noteId
{
    [self executeHttpMethod:@"DELETE" 
                   endpoint:[NSString stringWithFormat:@"/v2/media/%@/%@", noteId, mediaId] 
                 parameters:[self authenticatedParameters:nil]];
}





- (NSString *)composeUserAgent
{
    // OS name and version
    NSString *osName = nil;
    NSString *osVersion = nil;
#if TARGET_OS_IPHONE
    osName = @"iOS";
    osVersion = [UIDevice currentDevice].systemVersion;
#else
    osName = @"MacOS";
    SInt32 osvMajor = 0;
    SInt32 osvMinor = 0;
    SInt32 osvBugfix = 0;
    [GTMSystemVersion getMajor:&osvMajor minor:&osvMinor bugFix:&osvBugfix];
    osVersion = [NSString stringWithFormat:@"%d.%d.%d", osvMajor, osvMinor, osvBugfix];
#endif
    
    // hardware type
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0); 
    char *name = malloc(size);
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    NSString *machine = [NSString stringWithCString:name encoding:NSASCIIStringEncoding];
    free(name);
    
    // locale
    NSString *localeName = [[[NSLocale currentLocale] localeIdentifier] 
                            stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
    
    return [NSString stringWithFormat:@"%@/%@ (%@; %@; Apple; %@; %@)", 
            [self.appName stringByReplacingOccurrencesOfString:@" " withString:@""], 
            self.appVersion, osName, osVersion, machine, localeName];
}


@end




@implementation CatchClient (LibraryPrivate)


- (NSDictionary *)authenticatedParameters:(NSDictionary *)parameters
{
    if (self.accessToken) {
        NSMutableDictionary *mp = (parameters ? 
                                   [[parameters mutableCopy] autorelease] : 
                                   [NSMutableDictionary dictionaryWithCapacity:1]);
        [mp setValue:self.accessToken forKey:@"access_token"];
        parameters = [[mp copy] autorelease];
    }
    
    return parameters;
}


- (NSData *)executeHttpPostAttachment:(NSData *)attachment 
                               ofType:(NSString *)mimeType 
                                named:(NSString *)filename 
                             endpoint:(NSString *)endpoint 
                           parameters:(NSDictionary *)parameters
{
#if TARGET_OS_IPHONE
    // FIXME: without this throttle, image upload is faster but unreliable.
    // (NSURLConnection reports false ENOMEM, ASIHTTPRequest reports bogus SSL errors)
    [ASIHTTPRequest throttleBandwidthForWWANUsingLimit:ASIWWANBandwidthThrottleAmount*5];
#endif
    
    NSData *ret = nil;
    @try {
        ASIHTTPRequest *genreq = [self requestForMethod:@"POST" 
                                               endpoint:endpoint 
                                             parameters:parameters];
        NSAssert([genreq isKindOfClass:[ASIFormDataRequest class]], 
                 @"Expected ASIFormDataRequest type from requestForMethod!");
        ASIFormDataRequest *request = (ASIFormDataRequest*)genreq;
        
        [request setData:attachment 
            withFileName:filename 
          andContentType:mimeType 
                  forKey:@"data"];
        ret = [self executeRequest:request];
    }
    @catch (NSException *e) {
        @throw;
    }
    @finally {
#if TARGET_OS_IPHONE
        [ASIHTTPRequest setShouldThrottleBandwidthForWWAN:NO];
#endif
    }
    
    return ret;
}


- (NSData *)executeHttpMethod:(NSString *)method 
                     endpoint:(NSString *)endpoint 
                   parameters:(NSDictionary *)parameters
{
    ASIHTTPRequest *request = [self requestForMethod:method 
                                            endpoint:endpoint 
                                          parameters:parameters];
    return [self executeRequest:request];
}


- (ASIHTTPRequest *)requestForMethod:(NSString *)method 
                            endpoint:(NSString *)endpoint 
                          parameters:(NSDictionary *)parameters
{
    NSURL *endpointURL = [[[NSURL alloc] initWithScheme:self.apiScheme host:self.apiServer path:endpoint] autorelease];
    ASIHTTPRequest *ret = nil;
    if ([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"]) {
        NSString *accessToken = [parameters stringForKey:@"access_token"];
        NSURL *url = nil;
        if (accessToken) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?access_token=%@", endpointURL, accessToken]];
        } else {
            url = endpointURL;
        }
        ASIFormDataRequest *poster = [ASIFormDataRequest requestWithURL:url];
        ret = poster;
        
        if (parameters) {
            NSEnumerator *enumerator = [parameters keyEnumerator];
            id key = nil;
            while ((key = [enumerator nextObject])) {
                if ([key isEqualToString:@"access_token"]) {
                    // it's in the query string
                    continue;
                }
                [poster setPostValue:[parameters objectForKey:key] forKey:key];
            }
        }
        
    } else {
        NSURL *url = endpointURL;
        if ([parameters count]) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",  endpointURL, 
                                        [parameters gtm_httpArgumentsString]]];
        }
        
        ret = [ASIHTTPRequest requestWithURL:url];
    }
    
    [ret setRequestMethod:method];
    [ret addRequestHeader:@"User-Agent" value:self.userAgent];
    ret.shouldAttemptPersistentConnection = NO;
    ret.timeOutSeconds = 60;
    
    return ret;
}


// called by executeRequest
- (void)logAndThrowExceptionForRequest:(ASIHTTPRequest *)request 
                                  name:(NSString *)eName 
                                reason:(NSString *)eReason
{
    NSString *method = request.requestMethod;
    NSString *endpoint = [request.url absoluteString];
    
    if (self.logDelegate) {
        [self.logDelegate catchClient:self didExecuteHttpMethod:method 
                             endpoint:endpoint 
                           logMessage:[NSString stringWithFormat:@"**FAILED**: %@", eReason]];
    }
    
    CatchApiException *e = [CatchApiException exceptionWithName:eName 
                                                         reason:[eReason stringByAppendingFormat:
                                                                 @" (%@ %@)", method, endpoint] 
                                                       userInfo:nil];
    @throw e;
}


// called by executeRequest
+ (void)setName:(NSString **)eName 
      andReason:(NSString **)eReason 
  forStatusCode:(NSInteger)statusCode
{
    if (statusCode == 401) {
        *eName = CATCH_API_EXCEPTION_NOT_AUTHENTICATED;
        *eReason = CatchClientLocalize(@"Not authenticated with Catch.com server.");
        
    } else if (statusCode == 402) {
        *eName = CATCH_API_EXCEPTION_PAYMENT_REQUIRED;
        *eReason = CatchClientLocalize(@"Catch.com account upload quota exceeded.");
        
    } else if (statusCode == 415) {
        *eName = CATCH_API_EXCEPTION_UNSUPPORTED_MEDIA_TYPE;
        *eReason = CatchClientLocalize(@"Account level doesn't support this media type.");
    }
}


- (NSData *)executeRequest:(ASIHTTPRequest *)request
{
    [request startSynchronous];
    NSInteger statusCode = request.responseStatusCode;
    NSError *error = [request error];
    
    if (error) {
        NSString *eName = CATCH_API_EXCEPTION_UNKNOWN;
        NSString *eReason = CatchClientLocalize(@"Unknown error.");
        NSString *errorStr = [error localizedDescription];
        if (errorStr && [errorStr length]) {
            eReason = errorStr;
        }
        
        [CatchClient setName:&eName andReason:&eReason forStatusCode:statusCode];
        [self logAndThrowExceptionForRequest:request name:eName reason:eReason];
    }
    
    if (statusCode != 200) {
        NSString *eName = CATCH_API_EXCEPTION_HTTP_ERROR;
        NSString *eReason = [NSString stringWithFormat:
                             CatchClientLocalize(@"Unexpected HTTP status code: %d."), statusCode];
        
        [CatchClient setName:&eName andReason:&eReason forStatusCode:statusCode];
        [self logAndThrowExceptionForRequest:request name:eName reason:eReason];
    }
    
    if (self.logDelegate) {
        NSString *method = request.requestMethod;
        NSString *endpoint = [request.url absoluteString];
        [self.logDelegate catchClient:self didExecuteHttpMethod:method 
                             endpoint:endpoint 
                           logMessage:@"OK"];
    }
    
    return [request responseData];
}



+ (SInt64)parse3339:(NSString *)dateStr
{
    if (!dateStr) return NOT_SET_S64;
    
    NSAssert(CatchApiRfc3339Formatter__, 
             @"You must create an instance of CatchClient first!");
    
    @synchronized(CatchApiRfc3339Formatter__) {
        NSDate *d = [CatchApiRfc3339Formatter__ dateFromString:dateStr];
        if (d) return [d timeIntervalSince1970]*1000.0;
    }
    return NOT_SET_S64;
}

@end


