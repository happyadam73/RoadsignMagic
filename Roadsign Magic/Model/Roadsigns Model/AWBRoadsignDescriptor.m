//
//  AWBRoadsignDescriptor.m
//  Roadsign Magic
//
//  Created by Adam Buckley on 05/12/2011.
//  Copyright (c) 2011 happyadam development. All rights reserved.
//

#import "AWBRoadsignDescriptor.h"
#import "FileHelpers.h"

@implementation AWBRoadsignDescriptor

@synthesize roadsignName, roadsignSaveDocumentsSubdirectory, createdDate, totalObjects, totalImageObjects, totalLabelObjects, totalImageMemoryBytes;

- (id)initWithRoadsignName:(NSString *)name documentsSubdirectory:(NSString *)subDirectory
{
    self = [super init];
    if (self) {
        [self setRoadsignName:name];
        [self setRoadsignSaveDocumentsSubdirectory:subDirectory];
        createdDate = [[NSDate alloc] init];
//        themeType = kAWBCollageThemeTypePlain;
        totalImageObjects = 0;
        totalLabelObjects = 0;
        totalImageMemoryBytes = 0;
//        addContentOnCreation = NO;
    }
    return self;
}

- (id)initWithRoadsignDocumentsSubdirectory:(NSString *)subDirectory
{
    return [self initWithRoadsignName:subDirectory documentsSubdirectory:subDirectory];
}

- (id)init
{
    return [self initWithRoadsignName:@"Roadsign 1" documentsSubdirectory:@"Roadsign 1"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        [self setRoadsignName:[decoder decodeObjectForKey:kAWBInfoKeyRoadsignName]];
        [self setRoadsignSaveDocumentsSubdirectory:[decoder decodeObjectForKey:kAWBInfoKeyRoadsignDocumentsSubdirectory]];
        createdDate = [[decoder decodeObjectForKey:kAWBInfoKeyRoadsignCreatedDate] retain];
//        [self setThemeType:[decoder decodeIntegerForKey:kAWBInfoKeyCollageThemeType]];
        [self setTotalImageObjects:[decoder decodeIntegerForKey:kAWBInfoKeyRoadsignTotalImageObjects]];
        [self setTotalLabelObjects:[decoder decodeIntegerForKey:kAWBInfoKeyRoadsignTotalLabelObjects]];
        [self setTotalImageMemoryBytes:[decoder decodeIntegerForKey:kAWBInfoKeyRoadsignTotalImageMemoryBytes]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:roadsignName forKey:kAWBInfoKeyRoadsignName];
    [encoder encodeObject:roadsignSaveDocumentsSubdirectory forKey:kAWBInfoKeyRoadsignDocumentsSubdirectory];
    [encoder encodeObject:createdDate forKey:kAWBInfoKeyRoadsignCreatedDate];
//    [encoder encodeInteger:themeType forKey:kAWBInfoKeyCollageThemeType];
    [encoder encodeInteger:totalImageObjects forKey:kAWBInfoKeyRoadsignTotalImageObjects];    
    [encoder encodeInteger:totalLabelObjects forKey:kAWBInfoKeyRoadsignTotalLabelObjects]; 
    [encoder encodeInteger:totalImageMemoryBytes forKey:kAWBInfoKeyRoadsignTotalImageMemoryBytes];
}

//- (CollageTheme *)theme
//{
//    return [CollageTheme themeWithThemeType:themeType];
//}

- (UIImageView *)roadsignThumbnailImageView
{
    UIImage *thumbnail = [UIImage imageWithContentsOfFile:AWBPathInDocumentSubdirectory(self.roadsignSaveDocumentsSubdirectory, @"thumbnail.png")];
    
//    if (!thumbnail) {
//        if (DEVICE_IS_IPAD) {
//            thumbnail = [UIImage imageNamed:@"defaultthumbnail.jpg"];
//        } else {
//            thumbnail = [UIImage imageNamed:@"defaultthumbnailsmall.jpg"];
//        }    
//    }
    
    CGFloat frameHeight = 92.0;
    CGFloat frameWidth = 138.0;
    CGFloat topMargin = 10.0;
    CGFloat leftMargin = 10.0;
    CGFloat shadowOffset = 5.0;
    
    if (DEVICE_IS_IPAD) {
        frameHeight = 184.0;
        frameWidth = 256.0;
        topMargin = 20.0;
        leftMargin = 44.0;
        shadowOffset = 10.0;
    }    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, frameWidth, frameHeight)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = thumbnail;    
    imageView.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    imageView.layer.shadowOpacity = 0.3;
    imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    
    imageView.autoresizingMask = UIViewAutoresizingNone;
    
    return [imageView autorelease];
}

- (UIView *)roadsignInfoHeaderView
{
    CGFloat frameHeight = 112.0;
    CGFloat frameWidth = 480.0;
    if (DEVICE_IS_IPAD) {
        frameHeight = 224.0;
        frameWidth = 768.0;
    }    
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, frameWidth, frameHeight)];
    [infoView addSubview:[self roadsignThumbnailImageView]];
    [infoView addSubview:[self roadsignNameLabel]];
    [infoView addSubview:[self roadsignCreatedDateLabel]];
    [infoView addSubview:[self roadsignUpdatedDateLabel]];
    return [infoView autorelease];
}

- (UILabel *)roadsignNameLabel
{
    CGFloat leftMargin = 160;
    CGFloat topMargin = 25.0;
    CGFloat frameWidth = 310;
    CGFloat frameHeight = 30;
    CGFloat fontSize = 24.0;
    
    if (DEVICE_IS_IPAD) {
        leftMargin = 330.0;
        topMargin = 50.0;
        frameWidth = 400.0;
        frameHeight = 60.0;
        fontSize = 24.0;
    } 
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, frameWidth, frameHeight)];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [nameLabel setText:self.roadsignName];
    return [nameLabel autorelease];
}

- (UILabel *)roadsignCreatedDateLabel
{
    CGFloat leftMargin = 160;
    CGFloat topMargin = 60.0;
    CGFloat frameWidth = 310;
    CGFloat frameHeight = 15;
    
    if (DEVICE_IS_IPAD) {
        leftMargin = 330.0;
        topMargin = 100.0;
        frameWidth = 400.0;
        frameHeight = 24.0;
    } 
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, frameWidth, frameHeight)];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    [dateLabel setFont:[UIFont systemFontOfSize:16.0]];
    [dateLabel setTextColor:[UIColor darkGrayColor]];
    [dateLabel setText:[NSString stringWithFormat:@"Created:\t%@", AWBDateStringForCurrentLocale(self.createdDate)]];
    return [dateLabel autorelease];    
}

- (UILabel *)roadsignUpdatedDateLabel
{
    CGFloat leftMargin = 160;
    CGFloat topMargin = 80.0;
    CGFloat frameWidth = 310;
    CGFloat frameHeight = 15;
    
    if (DEVICE_IS_IPAD) {
        leftMargin = 330.0;
        topMargin = 124.0;
        frameWidth = 400.0;
        frameHeight = 24.0;
    } 
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, frameWidth, frameHeight)];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    [dateLabel setFont:[UIFont systemFontOfSize:16.0]];
    [dateLabel setTextColor:[UIColor darkGrayColor]];
    [dateLabel setText:[NSString stringWithFormat:@"Updated:\t%@", AWBDocumentSubdirectoryModifiedDate(self.roadsignSaveDocumentsSubdirectory)]];
    return [dateLabel autorelease];    
}

- (NSUInteger)totalObjects
{
    return (totalImageObjects+totalLabelObjects);
}

- (void)dealloc
{
    [roadsignName release];
    [roadsignSaveDocumentsSubdirectory release];
    [createdDate release];
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (saved in %@), created %@", roadsignName, roadsignSaveDocumentsSubdirectory, createdDate];
}

@end
