#import "FileHelpers.h"

#define JPEG_COMPRESSION 0.8

NSString *AWBDocumentDirectory(void)
{
	// Get list of document directories in sandbox
	NSArray *documentDirectories = 
	NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	// Get one and only document directory from that list
	return [documentDirectories objectAtIndex:0];
}

NSString *AWBDocumentSubdirectory(NSString *docsSubdirectory)
{
	// Get list of document directories in sandbox
	NSArray *documentDirectories = 
	NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	// Get one and only document directory from that list
	NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    //now create full path
	return [documentDirectory stringByAppendingPathComponent:docsSubdirectory];
}

NSString *AWBPathInDocumentDirectory(NSString *fileName)
{
	// Get list of document directories in sandbox
	NSArray *documentDirectories = 
	NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	// Get one and only document directory from that list
	NSString *documentDirectory = [documentDirectories objectAtIndex:0];
	
	// Append passed in file name to that directory, return it
	return [documentDirectory stringByAppendingPathComponent:fileName];
}

NSString *AWBDocumentSubdirectoryModifiedDate(NSString *docsSubdirectory)
{
	NSString *directoryPath = AWBDocumentSubdirectory(docsSubdirectory);
    BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:directoryPath];    
    NSDate *modifiedDate = nil;
    if (directoryExists) {
        NSDictionary *info = [[NSFileManager defaultManager] attributesOfItemAtPath:directoryPath error:NULL];
        modifiedDate = [info fileModificationDate];
    }
    return AWBDateStringForCurrentLocale(modifiedDate);
}

NSString *AWBDocumentSubdirectoryCreatedDate(NSString *docsSubdirectory)
{
	NSString *directoryPath = AWBDocumentSubdirectory(docsSubdirectory);
    BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:directoryPath];    
    NSDate *createdDate = nil;
    if (directoryExists) {
        NSDictionary *info = [[NSFileManager defaultManager] attributesOfItemAtPath:directoryPath error:NULL];
        createdDate = [info objectForKey:NSFileCreationDate];
    }
    return AWBDateStringForCurrentLocale(createdDate);
}

NSString *AWBDateStringForCurrentLocale(NSDate *date)
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateStyle:(DEVICE_IS_IPAD ? NSDateFormatterMediumStyle : NSDateFormatterShortStyle)];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:date];
}

NSUInteger AWBDocumentSubdirectoryFolderSize(NSString *docsSubdirectory)
{
	NSString *directoryPath = AWBDocumentSubdirectory(docsSubdirectory);
    BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:directoryPath];    
    NSUInteger totalSizeBytes = 0;
    if (directoryExists) {
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:NULL];
        for(NSString *filename in files)
        {
            NSString *fullPath = AWBPathInDocumentSubdirectory(docsSubdirectory, filename);
            NSDictionary *info = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:NULL];
            totalSizeBytes += [info fileSize];
        }
    }
    return totalSizeBytes;
}

NSString *AWBFileSizeIntToString(NSUInteger bytes)
{
    NSString *units;
    CGFloat count;
    NSUInteger numFractionDigits = 0;
    
    if (bytes < 1024) {
        count = (CGFloat)bytes;
        units = @"Bytes";
    } else if (bytes < (1048576)) {
        count = (CGFloat)bytes/1024.0;
        units = @"KB";
    } else if (bytes < (1073741824)) {
        count = (CGFloat)bytes/1048576.0;
        numFractionDigits = 1;
        units = @"MB";
    } else {
        count = (CGFloat)bytes/1073741824.0;
        numFractionDigits = 2;
        units = @"GB";
    }
    
    NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMinimumFractionDigits:numFractionDigits];
    [formatter setMaximumFractionDigits:numFractionDigits];
    
    return [NSString stringWithFormat:@"%@ %@", [formatter stringFromNumber:[NSNumber numberWithFloat:count]], units];
}

NSString *AWBPathInDocumentSubdirectory(NSString *docsSubdirectory, NSString *fileName)
{
	NSString *directoryPath = AWBDocumentSubdirectory(docsSubdirectory);
    
    BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:directoryPath];    
    if (!directoryExists) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
	// Append passed in file name to that directory, return it
	return [directoryPath stringByAppendingPathComponent:fileName];
}

NSString *AWBGetImageKeyFromDocumentSubdirectory(NSString *docsSubdirectory, NSString *fileName)
{
	NSString *directoryPath = AWBDocumentSubdirectory(docsSubdirectory);
    
    BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:directoryPath];    
    if (!directoryExists) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
	// Append passed in file name to that directory, return it
	return [docsSubdirectory stringByAppendingPathComponent:fileName];    
}

void AWBSaveImageWithKey(UIImage *image, NSString *imageKey)
{
    NSString *documentsPath = AWBDocumentDirectory();
    NSString *path = [documentsPath stringByAppendingPathComponent:imageKey];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    if (!fileExists) {
        NSData *imageData = UIImageJPEGRepresentation(image, JPEG_COMPRESSION);
        
        if (imageData) {
            [imageData writeToFile:path atomically:YES];            
        }
    }
}

UIImage *AWBLoadImageWithKey(NSString *imageKey)
{
    NSString *documentsPath = AWBDocumentDirectory();
    NSString *path = [documentsPath stringByAppendingPathComponent:imageKey];

    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    UIImage *result = nil;
    
    if (fileExists) {
        result = [UIImage imageWithContentsOfFile:path];
    }  
    
    return result;
}

void AWBRemoveImageWithKey(NSString *imageKey)
{
    NSString *documentsPath = AWBDocumentDirectory();
    NSString *path = [documentsPath stringByAppendingPathComponent:imageKey];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    if (fileExists) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    }  
}

BOOL AWBCopyBundleFolderToDocumentsFolder(NSString *bundleSubdirectory, NSString *docsSubdirectory)
{
    NSString *bundleSubdirectoryPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:bundleSubdirectory];
    NSString *docsSubdirectoryPath = [AWBDocumentDirectory() stringByAppendingPathComponent:docsSubdirectory];
    
    BOOL success = NO;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:bundleSubdirectoryPath];
    if (fileExists) {
        success = [[NSFileManager defaultManager] copyItemAtPath:bundleSubdirectoryPath toPath:docsSubdirectoryPath error:nil];
    }
    
    return success;
}

BOOL AWBCopyBundleItemAtPathToDocumentsFolder(NSString *bundleSubdirectory, NSString *filename)
{
    NSString *bundleSubdirectoryPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:bundleSubdirectory];
    NSString *fullBundlePath = [bundleSubdirectoryPath stringByAppendingPathComponent:filename];
    
    BOOL success = NO;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fullBundlePath];
    if (fileExists) {
        NSString *destPath = [AWBDocumentDirectory() stringByAppendingPathComponent:filename];
        success = [[NSFileManager defaultManager] copyItemAtPath:fullBundlePath toPath:destPath error:nil];
    }
    
    return success;
}


NSString *AWBPathInMainBundleSubdirectory(NSString *bundleSubdirectory, NSString *filename)
{
    NSString *bundleSubdirectoryPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:bundleSubdirectory];
    NSString *fullBundlePath = [bundleSubdirectoryPath stringByAppendingPathComponent:filename];

	return fullBundlePath;
}

BOOL AWBCopyRoadsignHelpFilesForDevice(void)
{
    NSString *bundleSubdirectory = (DEVICE_IS_IPAD ? @"Help Files/iPad" : @"Help Files/iPhone");
    BOOL success = AWBCopyBundleItemAtPathToDocumentsFolder(bundleSubdirectory, @"Roadsign 1");
    success = success && AWBCopyBundleItemAtPathToDocumentsFolder(bundleSubdirectory, @"roadsignDescriptors.data");
    
    return success;
}



