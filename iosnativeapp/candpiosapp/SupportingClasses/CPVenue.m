//
//  CPPlace.m
//  candpiosapp
//
//  Copyright (c) 2012 Coffee and Power Inc. All rights reserved.
//

#import "CPVenue.h"
#import <CoreLocation/CoreLocation.h>
#import "VenueInfoViewController.h"

@implementation CPVenue

@synthesize name = _name;
@synthesize icon = _icon;
@synthesize foursquareID = _foursquareID;
@synthesize address = _address;
@synthesize city = _city;
@synthesize state = _state;
@synthesize zip = _zip;
@synthesize formattedPhone = _formattedPhone;
@synthesize phone = _phone;
@synthesize photoURL = _photoURL;
@synthesize lat = _lat;
@synthesize lng = _lng;
@synthesize distanceFromUser = _distanceFromUser;
@synthesize checkinCount = _checkinCount;
@synthesize weeklyCheckinCount = _weeklyCheckinCount;
@synthesize intervalCheckinCount = _monthlyCheckinCount;
@synthesize coordinate = _coordinate;
@synthesize activeUsers = _activeUsers;

// override setters here to that when we parse JSON to set values we don't set things to null


// TODO: find out if there is a JSON parser that will just set these values to nil or empty strings so we don't have to do this everywhere
- (void)setAddress:(NSString *)address
{
    if (![address isKindOfClass:[NSNull class]]) {
        _address = address;
    } else {
        _address = @"";
    }
}

- (void)setCity:(NSString *)city
{
    if (![city isKindOfClass:[NSNull class]]) {
        _city = city;
    } else {
        _city = @"";
    }
}

- (void)setState:(NSString *)state
{
    if (![state isKindOfClass:[NSNull class]]) {
        _state = state;
    } else {
        _state = @"";
    }
}

- (void)setZip:(NSString *)zip
{
    if (![zip isKindOfClass:[NSNull class]]) {
        _zip = zip;
    } else {
        _zip = @"";
    }
}

- (void)setPhone:(NSString *)phone
{
    if (![phone isKindOfClass:[NSNull class]]) {
        _phone = phone;
    } else {
        _phone = @"";
    }
}

- (void)setFormattedPhone:(NSString *)formattedPhone
{
    if (![formattedPhone isKindOfClass:[NSNull class]]) {
        _formattedPhone = formattedPhone;
    } else {
        _formattedPhone = @"";
    }
}

- (void)setPhotoURL:(NSString *)photoURL
{
    if (![photoURL isKindOfClass:[NSNull class]]) {
        _photoURL = photoURL;
    } else {
        _photoURL = nil;
    }
    
}

- (NSMutableDictionary *)activeUsers
{
    if (!_activeUsers) {
        _activeUsers = [NSMutableDictionary dictionary];
    }
    return _activeUsers;
}

- (CPVenue *)initFromDictionary:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        self.name = [json objectForKey:@"name"];
        self.address = [json objectForKey:@"address"];
        self.city = [json objectForKey:@"city"];
        self.state = [json objectForKey:@"state"];
        self.phone = [json objectForKey:@"phone"];
        self.formattedPhone = [json objectForKey:@"formatted_phone"];
        self.distanceFromUser = [[json objectForKey:@"distance"] doubleValue];
        self.foursquareID = [json objectForKey:@"foursquare"];
        self.checkinCount = [[json objectForKey:@"checkins"] integerValue];
        self.weeklyCheckinCount = [[json objectForKey:@"checkins_for_week"] integerValue];
        self.intervalCheckinCount = [[json objectForKey:@"checkins_for_interval"] integerValue];
        self.photoURL = [json objectForKey:@"photo_url"];
        
        self.lat = [[json objectForKey:@"lat"] doubleValue];
        self.lng = [[json objectForKey:@"lng"] doubleValue];
        self.coordinate = CLLocationCoordinate2DMake(self.lat, self.lng);
        
        self.activeUsers = [json objectForKey:@"users"];
        
        // if this is the venue being shown by the places tab then let's update it's data
//        VenueInfoViewController *venueVC = [[[CPAppDelegate tabBarController].viewControllers objectAtIndex:1] rootViewController];
//        if (self.foursquareID == venueVC.venue.foursquareID) {
//            venueVC.venue = self;
//        }
               
    }
    return self;
}

// this method is used in CheckInListTableViewController to sort the array of places
// by the distance of each place from the user
// might be a faster way to accomplish this (sorting while inserting the foursquare returned
// data) but this seems to be quite quick anyways, as we aren't displaying a ton of places
- (NSComparisonResult)sortByDistanceToUser:(CPVenue *)place
{
    if (self.distanceFromUser < place.distanceFromUser) {
        return NSOrderedAscending;
    } else if (self.distanceFromUser > place.distanceFromUser) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (NSString *)checkinCountString {
    if (1 == self.checkinCount) { 
        return @"1 checkin";
    }
    
    return [NSString stringWithFormat:@"%d checkins", self.checkinCount];
}

- (NSString*) formattedAddress {
    // format the address from available address components
    NSMutableArray *addressComponents = [NSMutableArray array];
    if (self.address && self.address.length > 0) { 
        [addressComponents addObject:self.address];
    }
    if (self.city && self.city.length > 0) { 
        [addressComponents addObject:self.city];
    }
    if (self.state && self.state.length > 0) {
        [addressComponents addObject:self.state];
    }
    return [addressComponents componentsJoinedByString:@", "];
}

// title method implemented for MKAnnotation protocol
- (NSString *)title {
    return self.name;
}

- (NSString *)subtitle {
    NSString *subtitleString;
    if (self.checkinCount > 0) {
        subtitleString = [NSString stringWithFormat:@"%d %@ here now", self.checkinCount, self.checkinCount > 1 ? @"people" : @"person"];
    } else {
        subtitleString = [NSString stringWithFormat:@"%d %@ in the last week", self.weeklyCheckinCount, self.weeklyCheckinCount > 1 ? @"checkins" : @"checkin"];
    }
    return subtitleString;
}

@end