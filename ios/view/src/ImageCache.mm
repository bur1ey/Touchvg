//! \file ImageCache.mm
//! \brief 实现图像对象缓存类 ImageCache
// Copyright (c) 2012-2013, https://github.com/rhcad/touchvg

#import "ImageCache.h"
#ifdef USE_SVGKIT
#import "SVGKImage.h"
#endif

@implementation ImageCache

@synthesize imagePath;
@synthesize playPath;

- (id)init {
    self = [super init];
    if (self) {
        _images = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)dealloc {
    [_images RELEASE];
    [super DEALLOC];
}

- (void)clearCachedData {
    [_images removeAllObjects];
}

- (UIImage *)loadImage:(NSString *)name {
    UIImage *image = name ? [_images objectForKey:name] : nil;
    
    if (!image && name && [name length] > 1) {
        if ([name hasPrefix:@"png:"]) {
            [self addPNGFromResource:[name substringFromIndex:4] :&name];
        }
        else if ([name hasPrefix:@"svg:"]) {
            [self addSVGFromResource:[name substringFromIndex:4] :&name];
        }
        else {
            if ([self addImageFromPath:self.playPath :&name].width < 1) {
                [self addImageFromPath:self.imagePath :&name];
            }
        }
        image = [_images objectForKey:name];
    }
    
    return image;
}

- (CGSize)addImageFromPath:(NSString *)path :(NSString**)name {
    path = path ? [path stringByAppendingPathComponent:*name] : path;
    return path ? [self addImageFromFile:path :name] : CGSizeZero;
}

- (CGSize)getImageSize:(NSString *)name {
    UIImage *image = name ? [_images objectForKey:name] : nil;
    return image ? image.size : CGSizeZero;
}

- (CGSize)addPNGFromResource:(NSString*)name :(NSString **)key {
    name = [name stringByDeletingPathExtension];
    *key = [@"png:" stringByAppendingString:name];
    CGSize size = [self getImageSize:*key];
    
    if (size.width < 1 && *key && [name length] > 1) {
        NSString *resname = [name stringByAppendingString:@".png"];
        UIImage *image = [UIImage imageNamed:resname];
        if (image && image.size.width > 1) {
            [_images setObject:image forKey:*key];
            size = image.size;
        } else {
            NSLog(@"Fail to load image resource: %@", resname);
        }
    }
    
    return size;
}

#ifdef USE_SVGKIT
+ (UIImage *)renderSVG:(SVGKImage*)svgimg {
    if (!svgimg || ![svgimg hasSize])
        return nil;
    
    UIGraphicsBeginImageContextWithOptions(svgimg.size, NO, 0);
    [svgimg.CALayerTree renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
#endif

- (CGSize)addSVGFromResource:(NSString *)name :(NSString **)key {
    name = [name stringByDeletingPathExtension];
    *key = [@"svg:" stringByAppendingString:name];
    CGSize size = [self getImageSize:*key];
    
    if (size.width < 1 && *key && [name length] > 1) {
#ifdef USE_SVGKIT
        NSString *resname = [name stringByAppendingString:@".svg"];
        @try {
            UIImage *image = [ImageCache renderSVG:[SVGKImage imageNamed:resname]];
            
            if (image && image.size.width > 1) {
                [_images setObject:image forKey:*key];
                size = image.size;
            } else {
                NSLog(@"Fail to load image resource: %@", resname);
            }
        }
        @catch (NSException *e) {
            NSLog(@"Fail to parse %@ due to %@", resname, [e name]);
        }
#endif
    }
    
    return size;
}

+ (UIImage *)getImageFromSVGFile:(NSString *)filename maxSize:(CGSize)size {
    UIImage *image = nil;
#ifdef USE_SVGKIT
    SVGKImage* svgimg = nil;
    
    @try {
        svgimg = [[SVGKImage alloc]initWithContentsOfFile:filename];
        image = [ImageCache renderSVG:svgimg];
    }
    @catch (NSException *e) {
        NSLog(@"Fail to parse SVG file due to %@: %@", [e name], filename);
    }
    
    if (image && (svgimg.size.width > size.width || svgimg.size.height > size.height)) {
        [svgimg scaleToFitInside:size];
        
        UIGraphicsBeginImageContextWithOptions(svgimg.size, NO, image.scale);
        [image drawInRect:CGRectMake(0, 0, svgimg.size.width, svgimg.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    [svgimg RELEASE];
#endif
    
    return image;
}

// TODO: 暂时直接从SVGKImage得到UIImage，应当在GiCanvasAdapter中从SVGKImage获取CALayer渲染
- (CGSize)addImageFromFile:(NSString *)filename :(NSString**)name {
    *name = [[filename lastPathComponent]lowercaseString]; // 无路径的小写文件名
    CGSize size = [self getImageSize:*name];
    
    if (size.width < 1 && *name && [filename length] > 1) {
        UIImage *image = nil;
        
        if ([*name hasPrefix:@"svg:"]) {
#ifdef USE_SVGKIT
            SVGKImage* svgimg = nil;
            @try {
                svgimg = [[SVGKImage alloc]initWithContentsOfFile:filename];
                image = [ImageCache renderSVG:svgimg];
            }
            @catch (NSException *e) {
                NSLog(@"Fail to parse SVG file due to %@: %@", [e name], filename);
            }
            if (image && image.size.width > 1) {
                [_images setObject:image forKey:*name];
                size = image.size;
            }
            [svgimg RELEASE];
#endif
        }
        else {
            image = [[UIImage alloc]initWithContentsOfFile:filename];
            if (image && image.size.width > 1) {
                [_images setObject:image forKey:*name];
                [image RELEASE];
                size = image.size;
            }
        }
    }
    if (size.width < 1) {
        NSLog(@"Fail to load image file: %@", filename);
    }
    
    return size;
}

@end
