//
//  VIdbConfig.h
//  VISQLite
//
//  Created by  Ashish Sudra on 7/18/09.
//  Copyright 2011 iCoderz ( http://www.icoderz.in ). All rights reserved.
//
#import "VIDatabase.h"

#define kDBName		@"BirdGame.sqlite"
VIDatabase			*db;
VIResultSet			*rs;

/*
// ----------------------------------------------------------------------------------------
// Step:1 Add "VISQLite" bundel in your Application
// Step:2 #import "VIdbConfig.h" When ever use "db" and "rs" object First in AppDelegate
// Step:3 Add below code in applicationDidFinishLaunching: method // Asign DBName and open it.
// Step:4 libsqlite3.0.dylib add
// Step:5 rs = [db executeQuery:@"select rowid,* from test"]; > [rs next]; > NSLog([rs stringForColumn:@"colName"]);
db = [VIDatabase databaseWithName:kDBName];
if (![db open]) {
	NSLog(@"Could not open db.");
}else {
	NSLog(@"Open db.");
}
//[db setShouldCacheStatements:NO]; //YES if you cache the all query or NO
// ----------------------------------------------------------------------------------------
*/

/*
 
 //--------------------------
 BEGIN:VCALENDAR
 PRODID:-//Google Inc//Google Calendar 70.9054//EN
 VERSION:2.0
 CALSCALE:GREGORIAN
 METHOD:PUBLISH
 X-WR-CALNAME:amitkvirtueinfo@gmail.com
 X-WR-TIMEZONE:Asia/Calcutta
 BEGIN:VEVENT
 UID:5
 SUMMARY:400John's Birthday
 DESCRIPTION:1DescriptionText
 LOCATION:Holtsville\, NY\, USA
 DTSTART:20090818T000000Z
 DTEND:20090818T020000Z
 END:VEVENT
 END:VCALENDAR
 //--------------------------
 
 
 BEGIN:VEVENT
 
 UID:5
 
 SEQUENCE:0
 TRANSP:OPAQUE
 STATUS:CONFIRMED
 CLASS:PUBLIC
 
 SUMMARY:400John's Birthday
 DESCRIPTION:1DescriptionText
 LOCATION:Holtsville\, NY\, USA
 
 DTSTART:20090818T000000Z
 DTEND:20090818T020000Z
 
 DTSTAMP:20081123T131853Z
 CREATED:20090820T062545Z
 LAST-MODIFIED:20090820T070914Z

 BEGIN:VALARM
 X-WR-ALARMUID:49DC6A8D-3BD8-4402-9BB3-6F99D24BA0DA
 ACTION:DISPLAY
 DESCRIPTION:Reminder
 TRIGGER:-PT15M
 
 END:VALARM 
 END:VEVENT 
 [db executeUpdate:@"CREATE  TABLE ical_meeting (
 ical_id					INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL, 
 ical_uid					VARCHAR DEFAULT '',
 
 ical_sequence				VARCHAR DEFAULT '0',
 ical_transp				VARCHAR DEFAULT 'OPAQUE',
 ical_status				VARCHAR DEFAULT 'CONFIRMED',
 ical_class					VARCHAR DEFAULT 'PUBLIC',
 
 ical_summary				VARCHAR DEFAULT '',
 ical_description			VARCHAR TEXT DEFAULT '',
 ical_note					VARCHAR TEXT DEFAULT '',
 ical_location				VARCHAR TEXT DEFAULT '', 
 ical_location_lat			double	DEFAULT 0,
 ical_location_lon			double	DEFAULT 0,
 ical_attendee				VARCHAR TEXT DEFAULT '',
 
 ical_dtstart_v				VARCHAR DEFAULT '',
 ical_dtend_v				VARCHAR DEFAULT '',
 ical_dtstart_d				double	DEFAULT 0,
 ical_dtend_d				double	DEFAULT 0,
 
 ical_dtstamp_d				double	DEFAULT 0,
 ical_dtcreated_d			double	DEFAULT 0,
 ical_dtlastmodified_d		double	DEFAULT 0	);"]; 
*/
/*
-(void) dateFormate:(NSString*) strDate {
	
	
	// - (NSTimeInterval)timeIntervalSinceDate:(NSDate *)anotherDate;
	// - (NSTimeInterval)timeIntervalSinceNow;
	// - (NSTimeInterval)timeIntervalSince1970;
	 
	//Monday Aug 3

 NSTimeInterval intervalNow	 = [[NSDate date] timeIntervalSince1970];
 NSTimeInterval intervalBWeek = intervalNow-604800;
 NSTimeInterval intervalAWeek = intervalNow+604800;
 
 NSDate *dateNow	= [NSDate dateWithTimeIntervalSince1970:intervalNow	];
 NSDate *dateBWeek	= [NSDate dateWithTimeIntervalSince1970:intervalBWeek];
 NSDate *dateAWeek	= [NSDate dateWithTimeIntervalSince1970:intervalAWeek];
 
 NSLog(@"\nintervalNow:%.0f \nintervalBWeek:%.0f \nintervalAWeek:%.0f \n\ndateNow:%@\ndateBWeek:%@\ndateAWeek:%@\n", intervalNow, intervalBWeek, intervalAWeek, dateNow, dateBWeek, dateAWeek);
 
 
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy"];
	int year = [[dateFormatter stringFromDate:[NSDate date]] intValue];
	NSString *currentDate = [[NSString alloc] initWithFormat:@"%@ %d", strDate, year];
	[dateFormatter setDateFormat:@"EEEE LLL d yyyy"];
	NSDate *startDate = [dateFormatter dateFromString:currentDate];
	
	
	NSTimeInterval interval	= [[NSDate date] timeIntervalSince1970];
	NSLog(@"1249563923 timeIntervalSince1970:%f",interval);
	interval	= [startDate timeIntervalSince1970];
	NSLog(@"1249563923 startDate timeIntervalSince1970:%0.0f",interval);	
	
	interval	= [startDate timeIntervalSinceNow];
	NSLog(@"1249563923 startDate timeIntervalSinceNow:%f",interval);
	
	interval	= [[NSDate date] timeIntervalSinceReferenceDate];
	NSLog(@"1249563923 timeIntervalSinceReferenceDate:%d",interval);
	
	NSLog(@"strDate:%@ currentDate:%@ = startDate:%@",strDate,currentDate, startDate);
	[dateFormatter release];	
 
	
 a:	AM/PM
 A:	0~86399999 (Millisecond of Day)
 
 c/cc:	1~7 (Day of Week)
 ccc:	Sun/Mon/Tue/Wed/Thu/Fri/Sat
 cccc:	Sunday/Monday/Tuesday/Wednesday/Thursday/Friday/Saturday
 
 d:	1~31 (0 padded Day of Month)
 D:	1~366 (0 padded Day of Year)
 
 e:	1~7 (0 padded Day of Week)
 E~EEE:	Sun/Mon/Tue/Wed/Thu/Fri/Sat
 EEEE:	Sunday/Monday/Tuesday/Wednesday/Thursday/Friday/Saturday
 
 F:	1~5 (0 padded Week of Month, first day of week = Monday)
 
 g:	Julian Day Number (number of days since 4713 BC January 1)
 G~GGG:	BC/AD (Era Designator Abbreviated)
 GGGG:	Before Christ/Anno Domini
 
 h:	1~12 (0 padded Hour (12hr))
 H:	0~23 (0 padded Hour (24hr))
 
 k:	1~24 (0 padded Hour (24hr)
 K:	0~11 (0 padded Hour (12hr))
 
 L/LL:	1~12 (0 padded Month)
 LLL:	Jan/Feb/Mar/Apr/May/Jun/Jul/Aug/Sep/Oct/Nov/Dec
 LLLL:	January/February/March/April/May/June/July/August/September/October/November/December
 
 m:	0~59 (0 padded Minute)
 M/MM:	1~12 (0 padded Month)
 MMM:	Jan/Feb/Mar/Apr/May/Jun/Jul/Aug/Sep/Oct/Nov/Dec
 MMMM:	January/February/March/April/May/June/July/August/September/October/November/December
 
 q/qq:	1~4 (0 padded Quarter)
 qqq:	Q1/Q2/Q3/Q4
 qqqq:	1st quarter/2nd quarter/3rd quarter/4th quarter
 Q/QQ:	1~4 (0 padded Quarter)
 QQQ:	Q1/Q2/Q3/Q4
 QQQQ:	1st quarter/2nd quarter/3rd quarter/4th quarter
 
 s:	0~59 (0 padded Second)
 S:	(rounded Sub-Second)
 
 u:	(0 padded Year)
 
 v~vvv:	(General GMT Timezone Abbreviation)
 vvvv:	(General GMT Timezone Name)
 
 w:	1~53 (0 padded Week of Year, 1st day of week = Sunday, NB: 1st week of year starts from the last Sunday of last year)
 W:	1~5 (0 padded Week of Month, 1st day of week = Sunday)
 
 y/yyyy:	(Full Year)
 yy/yyy:	(2 Digits Year)
 Y/YYYY:	(Full Year, starting from the Sunday of the 1st week of year)
 YY/YYY:	(2 Digits Year, starting from the Sunday of the 1st week of year)
 
 z~zzz:	(Specific GMT Timezone Abbreviation)
 zzzz:	(Specific GMT Timezone Name)
 Z:	+0000 (RFC 822 Timezone)
 
}
*/
// Use it like
//NSDate *date = [NSDate date];
//[db executeUpdate:@"create table datetest (a double, b double, c double)"];
//[db executeUpdate:@"insert into datetest (a, b, c) values (?, ?, 0)" , [NSNull null], date];
/*
[db executeUpdate:@"CREATE TABLE animals ( id INTEGER PRIMARY KEY, name VARCHAR(50), description TEXT, image VARCHAR(255) );"]; 
if ([db hadError]) {
	NSLog(@"2:Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
}
 rs = [db executeQuery:@"select * from datetest"];
 
 while ([rs next]) {
 
 NSDate *a = [rs dateForColumnIndex:0];
 NSDate *b = [rs dateForColumnIndex:1];
 NSDate *c = [rs dateForColumnIndex:2];
 
 if (a) {
 NSLog(@"Oh crap, the null date insert didn't work!");
 return 12;
 }
 
 if (!c) {
 NSLog(@"Oh crap, the 0 date insert didn't work!");
 return 12;
 }
 
 NSTimeInterval dti = fabs([b timeIntervalSinceDate:date]);
 
 if (floor(dti) > 0.0) {
 NSLog(@"Date matches didn't really happen... time difference of %f", dti);
 return 13;
 }
 
 
 dti = fabs([c timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:0]]);
 
 
 
 if (floor(dti) > 0.0) 
 {
	NSLog(@"Date matches didn't really happen... time difference of %f", dti);
	return 13;
 }
 }

[db executeUpdate:@"INSERT INTO animals (name, description, image) VALUES ('Elephant', 'The elephant is a very large animal that lives in Africa and Asia', 'http://dblog.com.au/wp-content/elephant.jpg');"];
NSLog(@"lastInsertRowId:%d",[db lastInsertRowId]);	
[db executeUpdate:@"INSERT INTO animals (name, description, image) VALUES ('Monkey', 'Monkies can be VERY naughty and often steal clothing from unsuspecting tourists', 'http://dblog.com.au/wp-content/monkey.jpg');"];
NSLog(@"lastInsertRowId:%d",[db lastInsertRowId]);

rs = [db executeQuery:@"select rowid,* from test where a = ?", @"hi'"];

rs = [db executeQuery:@"select rowid,* from test"];	
while ([rs next]) {
	// just print out what we've got in a number of formats.
	NSLog(@"%d %@ %@ %@ %@ %f %f",
		  [rs intForColumn:@"c"],
		  [rs stringForColumn:@"b"],
		  [rs stringForColumn:@"a"],
		  [rs stringForColumn:@"rowid"],
		  [rs dateForColumn:@"d"],
		  [rs doubleForColumn:@"d"],
		  [rs doubleForColumn:@"e"]);
	if (!([[rs columnNameForIndex:0] isEqualToString:@"rowid"] &&
		  [[rs columnNameForIndex:1] isEqualToString:@"a"])
		) {
		NSLog(@"WHOA THERE BUDDY, columnNameForIndex ISN'T WORKING!");
	}
}
[rs close];

rs = [db executeQuery:[NSString stringWithFormat:@"select * from animals WHERE id=%d",5]];
while ([rs next]) {		
	NSLog(@"%d - %@ %@ %@", 
		  [rs intForColumn:@"id"],
		  [rs stringForColumn:@"name"],
		  [rs stringForColumn:@"description"],
		  [rs stringForColumn:@"image"]);        
}
[rs close];
*/
