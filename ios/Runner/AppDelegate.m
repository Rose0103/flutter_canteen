#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@import Firebase;

void SaveImages(NSDictionary* args, FlutterResult result);
void GetImageLight(NSDictionary* args, FlutterResult result);
void loadModel(NSDictionary* args, FlutterResult result);
void GetFeature(NSDictionary* args, FlutterResult result);
void EvaluateScore(NSDictionary* args, FlutterResult result);

FIRModelInterpreter *interpreter ;
FIRModelInputOutputOptions *ioOptions;
NSError *error;
@implementation AppDelegate
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    
    FlutterViewController *controller = (FlutterViewController *)self.window.rootViewController;
    FlutterMethodChannel *imageChannel = [FlutterMethodChannel
                                            methodChannelWithName:@"Flutterimage"
                                            binaryMessenger:controller.binaryMessenger];
    
    __weak typeof(self) weakSelf = self;
    [imageChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        // Note: this method is invoked on the UI thread.
        if ([@"getBatteryLevel" isEqualToString:call.method])
        {
            int batteryLevel = [weakSelf getBatteryLevel];
            if (batteryLevel == -1) {
                result([FlutterError errorWithCode:@"UNAVAILABLE" message:@"Battery info unavailable" details:nil]);
            } else {
                result(@(batteryLevel));
            }
            
        }else if ([@"SaveImages" isEqualToString:call.method])
        {
            @try {
                SaveImages(call.arguments,result);
            } @catch (NSException *exception) {
                result(exception.reason);
            }
        }else if ([@"GetImageLight" isEqualToString:call.method])
        {
            @try {
                GetImageLight(call.arguments,result);
            } @catch (NSException *exception) {
                result(exception.reason);
            }
        }else if ([@"LoadModel" isEqualToString:call.method])
        {
            NSLog(@"caf success");
            @try {
                loadModel(call.arguments,result);
            } @catch (NSException *exception) {
                result(exception.reason);
            }
        }else if ([@"GetFeature" isEqualToString:call.method])
        {
            @try {
                GetFeature(call.arguments,result);
            } @catch (NSException *exception) {
                result(exception.reason);
            }
        }else if ([@"EvaluateScore" isEqualToString:call.method])
        {
            @try {
                EvaluateScore(call.arguments,result);
            } @catch (NSException *exception) {
                result(exception.reason);
            }
        }
    }];
    [GeneratedPluginRegistrant registerWithRegistry:self];
    
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (int)getBatteryLevel {
    UIDevice* device = UIDevice.currentDevice;
    device.batteryMonitoringEnabled = YES;
    if (device.batteryState == UIDeviceBatteryStateUnknown) {
        return -1;
    } else {
        return (int)(device.batteryLevel * 100);
    }
}

//根据图片名将图片保存到ImageFile文件夹中
NSString* imageSavedPath(NSString * imageName)
{
  //获取Documents文件夹目录
  NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentPath = [path objectAtIndex:0];
  //获取文件管理器
  NSFileManager *fileManager = [NSFileManager defaultManager];
  //指定新建文件夹路径
  NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"FaceImage"];
  //创建ImageFile文件夹
  [fileManager createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
  //返回保存图片的路径（图片保存在ImageFile文件夹下）
  NSString * imagePath = [imageDocPath stringByAppendingPathComponent:imageName];
  return imagePath;
}

UIImage* imageFromBRGABytes(unsigned char *imageBytes,CGSize imageSize) {
    CGImageRef imageRef = imageRefFromBGRABytes(imageBytes ,imageSize);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

CGImageRef imageRefFromBGRABytes(unsigned char *imageBytes ,CGSize imageSize) {
 
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(imageBytes,
                                                imageSize.width,
                                                imageSize.height,
                                                8,
                                                imageSize.width * 4,
                                                colorSpace,
                                                kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return imageRef;
}

unsigned char * pixelBRGABytesFromImage(UIImage * image) {
    return pixelBRGABytesFromImageRef(image.CGImage);
}

unsigned char * pixelBRGABytesFromImageRef(CGImageRef imageRef ){
    
    NSUInteger iWidth = CGImageGetWidth(imageRef);
    NSUInteger iHeight = CGImageGetHeight(imageRef);
    NSUInteger iBytesPerPixel = 4;
    NSUInteger iBytesPerRow = iBytesPerPixel * iWidth;
    NSUInteger iBitsPerComponent = 8;
    unsigned char *imageBytes = malloc(iWidth * iHeight * iBytesPerPixel);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(imageBytes,
                                                 iWidth,
                                                 iHeight,
                                                 iBitsPerComponent,
                                                 iBytesPerRow,
                                                 colorspace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGRect rect = CGRectMake(0 , 0 , iWidth , iHeight);
    CGContextDrawImage(context , rect ,imageRef);
    CGColorSpaceRelease(colorspace);
    CGContextRelease(context);
    return imageBytes;
}

NSData *compressWithMaxLength(UIImage *image,NSUInteger maxLength){
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    //NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
    if (data.length < maxLength) return data;

    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 4; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        //NSLog(@"Compression = %.1f", compression);
        //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
    if (data.length < maxLength) return data;
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        //NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
    }
    //NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
    return data;
}

void SaveImages(NSDictionary* args, FlutterResult result) {
  const FlutterStandardTypedData* typedData = args[@"bytesList"][0];
  const int image_height = [args[@"imageHeight"] intValue];
  const int image_width = [args[@"imageWidth"] intValue];
  const int rotation = [args[@"rotation"] intValue];
  const int faceX = [args[@"faceX"] intValue];
  const int faceY = [args[@"faceY"] intValue];
  const int faceWidth = [args[@"faceWidth"] intValue];
  const float faceHeight = [args[@"faceHeight"] intValue];
  NSMutableArray* empty = [@[] mutableCopy];
  uint8_t* imageData = (uint8_t*)[[typedData data] bytes];
    
  CGSize size={image_width,image_height};
  UIImage *image = imageFromBRGABytes(imageData,size);
  //UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
  NSString* imagePath =imageSavedPath(@"total.jpg");
  NSData *leftfaceimageData = UIImageJPEGRepresentation(image,0.5);
  BOOL br = [leftfaceimageData writeToFile:imagePath atomically:YES];
  if (br) NSLog(@"caf success");
  else NSLog(@"caf fail");

  CGRect rect =  CGRectMake(faceX, faceY, faceWidth, faceHeight);//要裁减的区域
  CGImageRef cgimg = CGImageCreateWithImageInRect([image CGImage], rect);
  image = [UIImage imageWithCGImage:cgimg];
  CGImageRelease(cgimg);
  CGSize size2={faceWidth,faceHeight};
  UIImage *image2 = scaleToSize(image ,size2);
  //UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
  NSData *faceimageData =compressWithMaxLength(image2,16384);
  //NSData *faceimageData = UIImageJPEGRepresentation(image2, 0.3);
  NSString* faceimagePath =imageSavedPath(@"face.jpg");
  BOOL facebr = [faceimageData writeToFile:faceimagePath atomically:YES];
  NSString *returestr = [NSString stringWithFormat:@"%@,%@", imagePath, faceimagePath];
  if (facebr)
  {
      NSLog(@"caf success");
      result(returestr);
  }
  else
  {
      NSLog(@"caf fail");
      result(empty);
  }
}

int getlight(uint8_t* imageData,const int image_width,const int image_height )
{
    int sum = image_width * image_height;
    float Y = 0;
      for (int x=0; x<image_width; x++) {
          for (int y=0; y<image_height; y++) {
              int offset = 4*(x*y);
              int red = imageData[offset];
              int green = imageData[offset+1];
              int blue = imageData[offset+2];
              Y += 0.299*red + 0.587*green + 0.144*blue;
          }
      }
    return Y/sum;
}

void GetImageLight(NSDictionary* args, FlutterResult result) {
  const FlutterStandardTypedData* typedData = args[@"bytesList"][0];
  const int image_height = [args[@"imageHeight"] intValue];
  const int image_width = [args[@"imageWidth"] intValue];
  const int rotation = [args[@"rotation"] intValue];
  const int faceX = [args[@"faceX"] intValue];
  const int faceY = [args[@"faceY"] intValue];
  const int faceWidth = [args[@"faceWidth"] intValue];
  const int faceHeight = [args[@"faceHeight"] intValue];
  NSMutableArray* empty = [@[] mutableCopy];
  uint8_t* imageData = (uint8_t*)[[typedData data] bytes];
    
  CGSize size={image_width,image_height};
  UIImage *image = imageFromBRGABytes(imageData,size);
  //UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
  NSString* imagePath =imageSavedPath(@"face.jpg");
  NSData *leftfaceimageData = UIImagePNGRepresentation(image);
  BOOL br = [leftfaceimageData writeToFile:imagePath atomically:YES];
  if (br) NSLog(@"caf success");
  else NSLog(@"caf fail");
  //全图

  int totalLig=getlight(imageData,image_width,image_height);
  NSString *totallight = [NSString stringWithFormat:@"%d",totalLig];

  //左脸
  UIImage *Imageleft = imageFromBRGABytes(imageData,size);
  CGRect rectleft =  CGRectMake(faceX, faceY, faceWidth/2, faceHeight);//要裁减的区域
  CGImageRef cgimgleft = CGImageCreateWithImageInRect([Imageleft CGImage], rectleft);
  Imageleft = [UIImage imageWithCGImage:cgimgleft];
  CGImageRelease(cgimgleft);
  unsigned char *leftimageBytes = pixelBRGABytesFromImage(Imageleft);
  int leftLig=getlight(leftimageBytes,faceWidth/2,faceHeight);
  NSString *leftlight = [NSString stringWithFormat:@"%d",leftLig];
  free(leftimageBytes);
  //右脸
  UIImage *Imageright = imageFromBRGABytes(imageData,size);
  CGRect rectright =  CGRectMake(faceX+faceWidth/2, faceY, faceWidth/2, faceHeight);//要裁减的区域
  CGImageRef cgimglright = CGImageCreateWithImageInRect([Imageright CGImage], rectright);
  Imageright = [UIImage imageWithCGImage:cgimglright];
  CGImageRelease(cgimglright);
  unsigned char *rightimageBytes = pixelBRGABytesFromImage(Imageright);
  int rightLig=getlight(rightimageBytes,faceWidth/2,faceHeight);
  NSString *rightlight = [NSString stringWithFormat:@"%d",rightLig];
  free(rightimageBytes);
 
  NSString *returestr = [NSString stringWithFormat:@"%@,%@,%@", totallight, leftlight, rightlight];
  result(returestr);
}

double max(double num1 ,double num2){
    double result;
    if (num1 > num2)
    {
       result = num1;
    }
    else
    {
       result = num2;
    }
    return result;
 }

UIImage* scaleToSize(UIImage *image ,CGSize size)
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


void GetFeature(NSDictionary* args, FlutterResult result) {
  const FlutterStandardTypedData* typedData = args[@"bytesList"][0];
  const int image_height = [args[@"imageHeight"] intValue];
  const int image_width = [args[@"imageWidth"] intValue];
  const int rotation = [args[@"rotation"] intValue];
  const int faceX = [args[@"faceX"] intValue];
  const int faceY = [args[@"faceY"] intValue];
  const int faceWidth = [args[@"faceWidth"] intValue];
  const float faceHeight = [args[@"faceHeight"] intValue];
  NSMutableArray* empty = [@[] mutableCopy];
  
  uint8_t* imagebytes = (uint8_t*)[[typedData data] bytes];
  CGSize size={image_width,image_height};
  UIImage *image = imageFromBRGABytes(imagebytes,size);
  CGRect rect =  CGRectMake(faceX, faceY, faceWidth, faceHeight);//要裁减的区域
  CGImageRef cgimg = CGImageCreateWithImageInRect([image CGImage], rect);
  image = [UIImage imageWithCGImage:cgimg];
  //UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
  CGImageRelease(cgimg);
    // 将人脸resize为112X112大小的，因为下面需要feed数据的placeholder的形状是(1, 112, 112, 3)
  CGSize size2={112,112};
  UIImage *image2 = scaleToSize(image ,size2);
  //UIImageWriteToSavedPhotosAlbum(image2,nil,nil,nil);
    
  unsigned char *imageData = pixelBRGABytesFromImage(image2);
    
  FIRModelInputs *inputs = [[FIRModelInputs alloc] init];
  NSMutableData *inputData = [[NSMutableData alloc] initWithCapacity:0];
  NSError *error;

  for (int row = 0; row < 112; row++) {
    for (int col = 0; col < 112; col++) {
      long offset = 4 * (row * 112 + col);  //官网demo上row和col写反
      Float32 red = (imageData[offset+1]);
      Float32 green = (imageData[offset+2]) ;
      Float32 blue = (imageData[offset+3]);

      [inputData appendBytes:&red length:sizeof(red)];
      [inputData appendBytes:&green length:sizeof(green)];
      [inputData appendBytes:&blue length:sizeof(blue)];
    }
  }

  //归一化
    [inputs addInput:inputData error:&error];
    if (error != nil) { return ; }
    
    [interpreter runWithInputs:inputs
                       options:ioOptions
                    completion:^(FIRModelOutputs * _Nullable outputs,
                                 NSError * _Nullable error) {
      if (error != nil || outputs == nil) {
        return;
      }
      NSError *outputError;
      NSArray *probabilites = [outputs outputAtIndex:0 error:&outputError][0];
        
        //l2正则化
        double epsilon=1e-10;
        double squareSum = 0;
        for (int j = 0; j < probabilites.count; j++) {
            squareSum += pow([[probabilites objectAtIndex:j]  doubleValue], 2);
        }
        float xInvNorm = (float) sqrt(max(squareSum, epsilon));
        NSMutableArray *probabilitesnew=[NSMutableArray arrayWithCapacity:probabilites.count];
        for (int j = 0; j < probabilites.count; j++) {
            float temp=([[probabilites objectAtIndex:j]  floatValue] / xInvNorm);
            [probabilitesnew insertObject:[NSNumber numberWithFloat:temp] atIndex:j];
        }
        //l2正则化
        
      NSString *tempString = [probabilitesnew componentsJoinedByString:@","];
        result(tempString);
    }];

}

void loadModel(NSDictionary* args, FlutterResult result) {
    NSString *modelPath = [NSBundle.mainBundle pathForResource:@"mobilenet"
                                                        ofType:@"tflite"
                                                   inDirectory:@"ResourceBundle.bundle"];
    FIRCustomLocalModel *localModel =[[FIRCustomLocalModel alloc] initWithModelPath:modelPath];
    interpreter =[FIRModelInterpreter modelInterpreterForLocalModel:localModel];
    ioOptions = [[FIRModelInputOutputOptions alloc] init];
    NSError *error;
    [ioOptions setInputFormatForIndex:0
                                 type:FIRModelElementTypeFloat32
                           dimensions:@[@1, @112, @112, @3]
                                error:&error];
    if (error != nil) {
        result(error);
        return; }
    [ioOptions setOutputFormatForIndex:0
                                  type:FIRModelElementTypeFloat32
                            dimensions:@[@1, @512]
                                 error:&error];
    if (error != nil) {
        result(error);
        return; }
        result(modelPath);
}




float getMold(NSArray *aArray)
{
        int n=aArray.count;
        float sum=0;
        for (int i=0;i<n;i++)
        {
            sum+=[[aArray objectAtIndex:i]  floatValue]*[[aArray objectAtIndex:i]  floatValue];
        }
        return sqrt(sum);
}

void EvaluateScore(NSDictionary* args, FlutterResult result)
{
    const NSString *feature1 = args[@"feature1"];
    const NSString *feature2 = args[@"feature2"];
    NSArray *aArray1 = [feature1 componentsSeparatedByString:@","];
    NSArray *aArray2 = [feature2 componentsSeparatedByString:@","];
    if(aArray1.count!=aArray2.count||aArray1.count==0)
    {
       NSString *samestr= [NSString stringWithFormat:@"%f",0.0];
           result(samestr);
    }

    int n=aArray1.count;
    float temp=0;
    for (int i=0;i<n;i++)
    {
        temp+=[[aArray1 objectAtIndex:i]  floatValue]*[[aArray2 objectAtIndex:i]  floatValue];
    }
    float score=temp/(getMold(aArray1)*getMold(aArray2));

    NSString *samestr= [NSString stringWithFormat:@"%f",score];
    result(samestr);
}



@end
