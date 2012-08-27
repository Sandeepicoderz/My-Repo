//
//  VIResultSet.m
//  VISQLite
//
//  Created by  Ashish Sudra on 7/18/09.
//  Copyright 2011 iCoderz ( http://www.icoderz.in ). All rights reserved.
//

#import "VIResultSet.h"
#import "VIDatabase.h"
#import "unistd.h"

@interface VIResultSet (Private)
- (NSMutableDictionary *)columnNameToIndexMap;
- (void)setColumnNameToIndexMap:(NSMutableDictionary *)value;
@end

@implementation VIResultSet

+ (id) resultSetWithStatement:(VIStatement *)statement usingParentDatabase:(VIDatabase*)aDB {
    
    VIResultSet *rs = [[VIResultSet alloc] init];
    
    [rs setStatement:statement];
    [rs setParentDB:aDB];
    
    return rs;
	//return [rs autorelease];
}

- (void)dealloc {
    [self close];
    //NSLog(@"VIResultSet dealloc");
    [query release];
    query = nil;
    
    [columnNameToIndexMap release];
    columnNameToIndexMap = nil;
    
	[super dealloc];
}

- (void) close {
    
    [statement reset];
    [statement release];
    statement = nil;
    
    // we don't need this anymore... (i think)
    //[parentDB setInUse:NO];
    parentDB = nil;
}

- (void) setupColumnNames {
    
    if (!columnNameToIndexMap) {
        [self setColumnNameToIndexMap:[NSMutableDictionary dictionary]];
    }	
    
    int columnCount = sqlite3_column_count(statement.statement);
    
    int columnIdx = 0;
    for (columnIdx = 0; columnIdx < columnCount; columnIdx++) {
        [columnNameToIndexMap setObject:[NSNumber numberWithInt:columnIdx]
                                 forKey:[[NSString stringWithUTF8String:sqlite3_column_name(statement.statement, columnIdx)] lowercaseString]];
    }
    columnNamesSetup = YES;
}

- (void) kvcMagic:(id)object {
    
    int columnCount = sqlite3_column_count(statement.statement);
    
    int columnIdx = 0;
    for (columnIdx = 0; columnIdx < columnCount; columnIdx++) {
        
        const char *c = (const char *)sqlite3_column_text(statement.statement, columnIdx);
        
        // check for a null row
        if (c) {
            NSString *s = [NSString stringWithUTF8String:c];
            
            [object setValue:s forKey:[NSString stringWithUTF8String:sqlite3_column_name(statement.statement, columnIdx)]];
        }
    }
}

- (NSMutableArray*) getIds:(NSString*)icdColum {  //Amit
	NSString *isSelect = [query stringByPaddingToLength:6 withString:nil startingAtIndex:0];
	////NSLog(@"RS noOfRow:%@:%@",isSelect,query);
	NSMutableArray* allIDs = [[NSMutableArray alloc] init];
	if([isSelect caseInsensitiveCompare:@"SELECT"] == 0) {
		VIResultSet *tmpRs = [parentDB executeQuery:query];	
		while ([tmpRs next]) {			
			[allIDs addObject:[NSString stringWithFormat:@"%d",[tmpRs intForColumn:icdColum]]];			
		}
	}
	return allIDs;
}

- (int) noOfRow {  //Amit
	int noOfRow=0;
	NSString *isSelect = [query stringByPaddingToLength:6 withString:nil startingAtIndex:0];
	//NSLog(@"RS noOfRow:%@:%@",isSelect,query);
	
	if([isSelect caseInsensitiveCompare:@"SELECT"] == 0) {
		VIResultSet *tmpRs = [parentDB executeQuery:query];	
		while ([tmpRs next]) {
			noOfRow++;
		}
	}
	return noOfRow;
}

- (BOOL) next {
    
    int rc;
    BOOL retry;
    int numberOfRetries = 0;
    do {
		////NSLog(@"[rs next] do{}while:");
        retry = NO;
        
        rc = sqlite3_step(statement.statement);
        
        if (SQLITE_BUSY == rc) {
            // this will happen if the db is locked, like if we are doing an update or insert.
            // in that case, retry the step... and maybe wait just 10 milliseconds.
            retry = YES;
            usleep(20);
            
            if ([parentDB busyRetryTimeout] && (numberOfRetries++ > [parentDB busyRetryTimeout])) {
                
                //NSLog(@"%s:%d Database busy (%@)", __FUNCTION__, __LINE__, [parentDB databasePath]);
                //NSLog(@"Database busy");
                break;
            }
        }
        else if (SQLITE_DONE == rc || SQLITE_ROW == rc) {
            // all is well, let's return.
        }
        else if (SQLITE_ERROR == rc) {
            //NSLog(@"Error calling sqlite3_step (%d: %s) rs", rc, sqlite3_errmsg([parentDB sqliteHandle]));
            break;
        } 
        else if (SQLITE_MISUSE == rc) {
            // uh oh.
            //NSLog(@"Error calling sqlite3_step (%d: %s) rs", rc, sqlite3_errmsg([parentDB sqliteHandle]));
            break;
        }
        else {
            // wtf?
            //NSLog(@"Unknown error calling sqlite3_step (%d: %s) rs", rc, sqlite3_errmsg([parentDB sqliteHandle]));
            break;
        }
        
    } while (retry);
    
    
    if (rc != SQLITE_ROW) {
        [self close];
    }
    
    return (rc == SQLITE_ROW);
}

- (BOOL) hasAnotherRow {
    return sqlite3_errcode([parentDB sqliteHandle]) == SQLITE_ROW;
}

- (int) columnIndexForName:(NSString*)columnName {
    
    if (!columnNamesSetup) {
        [self setupColumnNames];
    }
    
    columnName = [columnName lowercaseString];
    
    NSNumber *n = [columnNameToIndexMap objectForKey:columnName];
    
    if (n) { return [n intValue];   }
    
    //NSLog(@"Warning: I could not find the column named '%@'.", columnName);
    
    return -1;
}
- (int) intForColumn:(NSString*)columnName {
    return [self intForColumnIndex:[self columnIndexForName:columnName]];
}

- (int) intForColumnIndex:(int)columnIdx {
    return sqlite3_column_int(statement.statement, columnIdx);
}

- (long) longForColumn:(NSString*)columnName {
    return [self longForColumnIndex:[self columnIndexForName:columnName]];
}

- (long) longForColumnIndex:(int)columnIdx {
    return (long)sqlite3_column_int64(statement.statement, columnIdx);
}

- (long long int) longLongIntForColumn:(NSString*)columnName {
    return [self longLongIntForColumnIndex:[self columnIndexForName:columnName]];
}

- (long long int) longLongIntForColumnIndex:(int)columnIdx {
    return sqlite3_column_int64(statement.statement, columnIdx);
}

- (BOOL) boolForColumn:(NSString*)columnName {
    return [self boolForColumnIndex:[self columnIndexForName:columnName]];
}

- (BOOL) boolForColumnIndex:(int)columnIdx {
    return ([self intForColumnIndex:columnIdx] != 0);
}

- (double) doubleForColumn:(NSString*)columnName {
    return [self doubleForColumnIndex:[self columnIndexForName:columnName]];
}

- (double) doubleForColumnIndex:(int)columnIdx {
    return sqlite3_column_double(statement.statement, columnIdx);
}

- (NSString*) stringForColumnIndex:(int)columnIdx {    
    if (sqlite3_column_type(statement.statement, columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
		return nil;
	}    
    const char *c = (const char *)sqlite3_column_text(statement.statement, columnIdx);
    
    if (!c) {
        // null row.
        return nil;
    }    
    return [NSString stringWithUTF8String:c];
}

- (NSString*) stringForColumn:(NSString*)columnName {
    return [self stringForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSDate*) dateForColumn:(NSString*)columnName {
    return [self dateForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSDate*) dateForColumnIndex:(int)columnIdx {
    
    if (sqlite3_column_type(statement.statement, columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
		return nil;
	}
    
    return [NSDate dateWithTimeIntervalSince1970:[self doubleForColumnIndex:columnIdx]];
}

- (NSData*) dataForColumn:(NSString*)columnName {
    return [self dataForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSData*) dataForColumnIndex:(int)columnIdx {
    
    if (sqlite3_column_type(statement.statement, columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
		return nil;
	}
    
    int dataSize = sqlite3_column_bytes(statement.statement, columnIdx);
    
    NSMutableData *data = [NSMutableData dataWithLength:dataSize];
    
    memcpy([data mutableBytes], sqlite3_column_blob(statement.statement, columnIdx), dataSize);
    
    return data;
}

- (NSData*) dataNoCopyForColumn:(NSString*)columnName {
    return [self dataNoCopyForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSData*) dataNoCopyForColumnIndex:(int)columnIdx {
    
    if (sqlite3_column_type(statement.statement, columnIdx) == SQLITE_NULL || (columnIdx < 0)) {
		return nil;
	}
    
    int dataSize = sqlite3_column_bytes(statement.statement, columnIdx);
    
    NSData *data = [NSData dataWithBytesNoCopy:(void *)sqlite3_column_blob(statement.statement, columnIdx) length:dataSize freeWhenDone:NO];
    
    return data;
}

- (BOOL) columnIndexIsNull:(int)columnIdx {
    return sqlite3_column_type(statement.statement, columnIdx) == SQLITE_NULL;
}

- (BOOL) columnIsNull:(NSString*)columnName {
    return [self columnIndexIsNull:[self columnIndexForName:columnName]];
}

// returns autoreleased NSString containing the name of the column in the result set
- (NSString*) columnNameForIndex:(int)index {
	return [NSString stringWithUTF8String: sqlite3_column_name(statement.statement, index)];
}

- (void)setParentDB:(VIDatabase *)newDb {
    parentDB = newDb;
}

- (NSString *)query {
    return query;
}

- (void)setQuery:(NSString *)value {
    [value retain];
    [query release];
    query = value;
}

- (NSMutableDictionary *)columnNameToIndexMap {
    return columnNameToIndexMap;
}

- (void)setColumnNameToIndexMap:(NSMutableDictionary *)value {
    [value retain];
    [columnNameToIndexMap release];
    columnNameToIndexMap = value;
}

- (VIStatement *) statement {
    return statement;
}

- (void)setStatement:(VIStatement *)value {
    if (statement != value) {
        [statement release];
        statement = [value retain];
    }
}

@end