//
//  VIDatabase.h
//  VISQLite
//
//  Created by  Ashish Sudra on  7/18/09.
//  Copyright 2011 iCoderz ( http://www.icoderz.in ). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "VIResultSet.h"

@interface VIDatabase : NSObject 
{
	sqlite3*    db;
	NSString*   databasePath;
    BOOL        logsErrors;
    BOOL        crashOnErrors;
    BOOL        inUse;
    BOOL        inTransaction;
    BOOL        traceExecution;
    BOOL        checkedOut;
    int         busyRetryTimeout;
    BOOL        shouldCacheStatements;
    NSMutableDictionary *cachedStatements;
}

+ (id)databaseWithPath:(NSString*)inPath;
+ (id)databaseWithName:(NSString*)dbName;
- (id)initWithPath:(NSString*)inPath;

- (BOOL) open;
- (void) close;
- (BOOL) goodConnection;
- (void) clearCachedStatements;

// encryption methods.  You need to have purchased the sqlite encryption extensions for these to work.
- (BOOL) setKey:(NSString*)key;
- (BOOL) rekey:(NSString*)key;


- (NSString *) databasePath;

- (NSString*) lastErrorMessage;

- (int) lastErrorCode;
- (BOOL) hadError;
- (sqlite_int64) lastInsertRowId;

- (sqlite3*) sqliteHandle;

- (BOOL) executeUpdate:(NSString *)sql arguments:(va_list)args;
- (BOOL) executeUpdate:(NSString*)sql, ...;


- (id) executeQuery:(NSString *)sql arguments:(va_list)args;
- (id) executeQuery:(NSString*)sql, ...;

- (BOOL) rollback;
- (BOOL) commit;
- (BOOL) beginTransaction;
- (BOOL) beginDeferredTransaction;

- (BOOL)logsErrors;
- (void)setLogsErrors:(BOOL)flag;

- (BOOL)crashOnErrors;
- (void)setCrashOnErrors:(BOOL)flag;

- (BOOL)inUse;
- (void)setInUse:(BOOL)value;

- (BOOL)inTransaction;
- (void)setInTransaction:(BOOL)flag;

- (BOOL)traceExecution;
- (void)setTraceExecution:(BOOL)flag;

- (BOOL)checkedOut;
- (void)setCheckedOut:(BOOL)flag;

- (int)busyRetryTimeout;
- (void)setBusyRetryTimeout:(int)newBusyRetryTimeout;

- (BOOL)shouldCacheStatements;
- (void)setShouldCacheStatements:(BOOL)value;

- (NSMutableDictionary *)cachedStatements;
- (void)setCachedStatements:(NSMutableDictionary *)value;

+ (NSString*) sqliteLibVersion;


- (int)changes;

@end

@interface VIStatement : NSObject {
    sqlite3_stmt *statement;
    NSString *query;
    long useCount;
}


- (void) close;
- (void) reset;

- (sqlite3_stmt *)statement;
- (void)setStatement:(sqlite3_stmt *)value;

- (NSString *)query;
- (void)setQuery:(NSString *)value;

- (long)useCount;
- (void)setUseCount:(long)value;


@end

