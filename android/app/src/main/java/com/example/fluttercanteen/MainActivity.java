package com.mqcanteen.fluttercanteen;

import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.BitmapFactory;
import android.os.SystemClock;
import android.renderscript.Allocation;
import android.renderscript.Element;
import android.renderscript.RenderScript;
import android.renderscript.ScriptIntrinsicYuvToRGB;
import android.renderscript.Type;
import android.util.Log;
import android.graphics.YuvImage;
import android.graphics.Rect;
import android.graphics.ImageFormat;
import android.os.Environment;
import android.os.Bundle;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Canvas;
import android.os.Bundle;
import android.os.Environment;
import static android.content.ContentValues.TAG;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;


import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.io.FileOutputStream;
import java.io.PrintWriter;
import java.io.PrintStream;
import java.io.FileNotFoundException;
import java.io.FileInputStream;
import java.io.File;
import java.io.ByteArrayOutputStream;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;


import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {
  private Context mContext;
  private static final String channel = "Flutterimage";
  private static MobileFaceNet mfn; // 人脸比对



  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    mContext = this;
    new MethodChannel(getFlutterView(),channel).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                if (methodCall.method.equals("SaveImages")) {
                  try {
                    new SaveImages((HashMap) methodCall.arguments, result);
                  } catch (Exception e) {
                    result.error("Failed to convertImage", e.getMessage(), e);
                  }
                } else if (methodCall.method.equals("GetImageLight")) {
                  try {
                    new GetImageLight((HashMap) methodCall.arguments, result);
                  } catch (Exception e) {
                    result.error("Failed to GetImageLight", e.getMessage(), e);
                  }
                }else if (methodCall.method.equals("LoadModel")) {
                    try {
                      mfn = new MobileFaceNet(getAssets());
                      result.success("Loadmodel success");
                    } catch (Exception e) {
                        System.out.println("load bbbbbbb");
                        result.error("Loadmodel", e.getMessage(), e);
                    }
                }else if (methodCall.method.equals("GetFeature")) {
                  try {
                    System.out.println("adgg1111111aaa");
                    //result.success("aaaaaadgfghfgh");
                    new GetFeature((HashMap) methodCall.arguments, result);
                  } catch (Exception e) {
                    System.out.println("11111232222222aaadfgfg");
                    result.error("GetFeature", e.getMessage(), e);
                  }
                }else if (methodCall.method.equals("EvaluateScore")) {
                  try {
                    new EvaluateScore((HashMap) methodCall.arguments, result);
                  } catch (Exception e) {
                    result.error("EvaluateScore", e.getMessage(), e);
                  }
                }else if (methodCall.method.equals("backDesktop")) {
                  result.success(true);
                  moveTaskToBack(false);
                }
                else {
                  result.notImplemented();
                }
              }
            }
    );

    GeneratedPluginRegistrant.registerWith(this);
  }

  private class SaveImages  {
    SaveImages(HashMap args, Result result) throws IOException {

      List<byte[]> bytesList = (ArrayList) args.get("bytesList");
      int imageHeight = (int) (args.get("imageHeight"));
      int imageWidth = (int) (args.get("imageWidth"));
      int rotation = (int) (args.get("rotation"));
      int faceX = (int) (args.get("faceX"));
      int faceY = (int) (args.get("faceY"));
      int faceWidth = (int) (args.get("faceWidth"));
      int faceHeight = (int) (args.get("faceHeight"));
      String imgpath = feedInputFrame(bytesList, imageHeight, imageWidth,  rotation,faceX,faceY,faceWidth,faceHeight);
      result.success(imgpath);
    }
  }

  private class GetImageLight{
    GetImageLight(HashMap args, Result result) throws IOException {

      List<byte[]> bytesList = (ArrayList) args.get("bytesList");
      int imageHeight = (int) (args.get("imageHeight"));
      int imageWidth = (int) (args.get("imageWidth"));
      int faceX = (int) (args.get("faceX"));
      int faceY = (int) (args.get("faceY"));
      int faceWidth = (int) (args.get("faceWidth"));
      int faceHeight = (int) (args.get("faceHeight"));
      int rotation = (int) (args.get("rotation"));
      String lightdegree = getImageLight(bytesList,imageHeight,imageWidth,rotation,faceX,faceY,faceWidth,faceHeight);
      result.success(lightdegree);
    }
  }

  private class GetFeature{
    GetFeature(HashMap args, Result result) throws IOException {
      System.out.println("特征提取1111111");
      long start = System.currentTimeMillis();
      List<byte[]> bytesList = (ArrayList) args.get("bytesList");
      int imageHeight = (int) (args.get("imageHeight"));
      int imageWidth = (int) (args.get("imageWidth"));
      int faceX = (int) (args.get("faceX"));
      int faceY = (int) (args.get("faceY"));
      int faceWidth = (int) (args.get("faceWidth"));
      int faceHeight = (int) (args.get("faceHeight"));
      int rotation = (int) (args.get("rotation"));

      ByteBuffer Y = ByteBuffer.wrap(bytesList.get(0));
      ByteBuffer U = ByteBuffer.wrap(bytesList.get(1));
      ByteBuffer V = ByteBuffer.wrap(bytesList.get(2));

      int Yb = Y.remaining();
      int Ub = U.remaining();
      int Vb = V.remaining();

      byte[] data = new byte[Yb + Ub + Vb];

      Y.get(data, 0, Yb);
      V.get(data, Yb, Vb);
      U.get(data, Yb + Vb, Ub);

      YuvImage yuvimage = new YuvImage(data, ImageFormat.NV21, imageWidth, imageHeight, null);

      ByteArrayOutputStream baos = new ByteArrayOutputStream();
      yuvimage.compressToJpeg(new Rect(0, 0, imageWidth,imageHeight), 100, baos);
      Bitmap bmp = BitmapFactory.decodeByteArray(baos.toByteArray(), 0, baos.toByteArray().length);

      Matrix matrix = new Matrix();
      matrix.preRotate(rotation);
      bmp = Bitmap.createBitmap(bmp ,0,0, bmp .getWidth(), bmp
              .getHeight(),matrix,true);

      Bitmap bmpface = Bitmap.createBitmap(bmp, faceX, faceY, faceWidth, faceHeight, null, false);
      System.out.println("特征提取2222222");
      float[] feature = mfn.getfeature(bmpface);
      System.out.println("特征提取3333333");
      String featurestr="";
      for(int i=0;i<feature.length;i++)
      {
        if(i!=feature.length-1)
        featurestr=featurestr+feature[i]+",";
        else
          featurestr=featurestr+feature[i];
      }
      long end = System.currentTimeMillis();
      System.out.println("特征提取耗时：" + (end - start));
      result.success(featurestr);
    }
  }

  private class EvaluateScore{
    EvaluateScore(HashMap args, Result result) throws IOException {
      long start = System.currentTimeMillis();
      String feature1 = (String) args.get("feature1");
      String feature2 = (String) args.get("feature2");

      float score=mfn.evaluate(feature1,feature2);
      String scorestr =""+score;
      long end = System.currentTimeMillis();
      System.out.println("特征比对耗时：" + (end - start));
      result.success(scorestr);
    }
  }





  public static String getImageLight(List<byte[]> bytesList, int imageHeight, int imageWidth,  int rotation,int faceX ,int faceY,int faceWidth, int faceHeight) throws IOException {
    ByteBuffer Y = ByteBuffer.wrap(bytesList.get(0));
    ByteBuffer U = ByteBuffer.wrap(bytesList.get(1));
    ByteBuffer V = ByteBuffer.wrap(bytesList.get(2));

    int Yb = Y.remaining();
    int Ub = U.remaining();
    int Vb = V.remaining();

    byte[] data = new byte[Yb + Ub + Vb];

    Y.get(data, 0, Yb);
    V.get(data, Yb, Vb);
    U.get(data, Yb + Vb, Ub);



    YuvImage yuvimage = new YuvImage(data, ImageFormat.NV21, imageWidth, imageHeight, null);

    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    yuvimage.compressToJpeg(new Rect(0, 0, imageWidth, imageHeight), 100, baos);
    Bitmap bmptemp = BitmapFactory.decodeByteArray(baos.toByteArray(), 0, baos.toByteArray().length);
    Bitmap bmp=rotateBitmap(bmptemp,rotation);
    int fulllight=getBright(bmp);
    //左右半脸检测，阴阳脸
    Bitmap bmpleftface = Bitmap.createBitmap(bmp, faceX, faceY, faceWidth/2, faceHeight, null, false);
    int leftfacelight=getBright(bmpleftface);
    Bitmap bmprightface = Bitmap.createBitmap(bmp, faceX+faceWidth/2, faceY, faceWidth/2, faceHeight, null, false);
    int rightfacelight=getBright(bmprightface);

    String light=+fulllight+","+leftfacelight+","+ rightfacelight;
    return  light;
  }

  public static Bitmap compressScale(Bitmap image,float width,float height) {
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    image.compress(Bitmap.CompressFormat.JPEG, 100, baos);
    // 判断如果图片大于1M,进行压缩避免在生成图片（BitmapFactory.decodeStream）时溢出
    if (baos.toByteArray().length / 1024 > 1024) {
      baos.reset();// 重置baos即清空baos
      image.compress(Bitmap.CompressFormat.JPEG, 80, baos);// 这里压缩50%，把压缩后的数据存放到baos中
    }
    ByteArrayInputStream isBm = new ByteArrayInputStream(baos.toByteArray());
    BitmapFactory.Options newOpts = new BitmapFactory.Options();
    // 开始读入图片，此时把options.inJustDecodeBounds 设回true了
    newOpts.inJustDecodeBounds = true;
    Bitmap bitmap = BitmapFactory.decodeStream(isBm, null, newOpts);
    newOpts.inJustDecodeBounds = false;
    int w = newOpts.outWidth;
    int h = newOpts.outHeight;
    Log.i("", w + "---------------" + h);
    // 现在主流手机比较多是800*480分辨率，所以高和宽我们设置为
    // float hh = 800f;// 这里设置高度为800f
    // float ww = 480f;// 这里设置宽度为480f
    float hh = width;
    float ww = height;
    // 缩放比。由于是固定比例缩放，只用高或者宽其中一个数据进行计算即可
    int be = 1;// be=1表示不缩放
    if (w > h && w > ww) {// 如果宽度大的话根据宽度固定大小缩放
      be = (int) (newOpts.outWidth / ww);
    } else if (w < h && h > hh) { // 如果高度高的话根据高度固定大小缩放
      be = (int) (newOpts.outHeight / hh);
    }
    if (be <= 0)
      be = 1;
    newOpts.inSampleSize = be; // 设置缩放比例
    // newOpts.inPreferredConfig = Config.RGB_565;//降低图片从ARGB888到RGB565
    // 重新读入图片，注意此时已经把options.inJustDecodeBounds 设回false了
    isBm = new ByteArrayInputStream(baos.toByteArray());
    bitmap = BitmapFactory.decodeStream(isBm, null, newOpts);
    return compressImage(bitmap);// 压缩好比例大小后再进行质量压缩
    //return bitmap;
  }

  public static Bitmap compressImage(Bitmap image) {
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    image.compress(Bitmap.CompressFormat.JPEG, 100, baos);// 质量压缩方法，这里100表示不压缩，把压缩后的数据存放到baos中
    int options = 90;
    while (baos.toByteArray().length / 1024 > 50) { // 循环判断如果压缩后图片是否大于100kb,大于继续压缩
      baos.reset(); // 重置baos即清空baos
      image.compress(Bitmap.CompressFormat.JPEG, options, baos);// 这里压缩options%，把压缩后的数据存放到baos中
      options -= 10;// 每次都减少10
    }
    ByteArrayInputStream isBm = new ByteArrayInputStream(baos.toByteArray());// 把压缩后的数据baos存放到ByteArrayInputStream中
    Bitmap bitmap = BitmapFactory.decodeStream(isBm, null, null);// 把ByteArrayInputStream数据生成图片
    return bitmap;
  }

  public static String feedInputFrame(List<byte[]> bytesList, int imageHeight, int imageWidth,  int rotation,int faceX ,int faceY,int faceWidth, int faceHeight) throws IOException {
    String successPath=getFilePath();
    File file = new File(successPath);
    if(!file.exists()){
      file.mkdir();

    }

    ByteBuffer Y = ByteBuffer.wrap(bytesList.get(0));
    ByteBuffer U = ByteBuffer.wrap(bytesList.get(1));
    ByteBuffer V = ByteBuffer.wrap(bytesList.get(2));

    int Yb = Y.remaining();
    int Ub = U.remaining();
    int Vb = V.remaining();

    byte[] data = new byte[Yb + Ub + Vb];

    Y.get(data, 0, Yb);
    V.get(data, Yb, Vb);
    U.get(data, Yb + Vb, Ub);

    YuvImage yuvimage = new YuvImage(data, ImageFormat.NV21, imageWidth, imageHeight, null);

    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    yuvimage.compressToJpeg(new Rect(0, 0, imageWidth,imageHeight), 100, baos);
    Bitmap bmp = BitmapFactory.decodeByteArray(baos.toByteArray(), 0, baos.toByteArray().length);

    Matrix matrix = new Matrix();
    matrix.preRotate(rotation);
    bmp = Bitmap.createBitmap(bmp ,0,0, bmp .getWidth(), bmp
            .getHeight(),matrix,true);

    //FileOutputStream outStream = null;
    String fullPath=successPath+"/fullPic.jpg";
    //outStream = new FileOutputStream(fullPath);
    //bmp.compress(Bitmap.CompressFormat.JPEG, 100, outStream);
    //outStream.write(baos.toByteArray());
    //outStream.close();

    Bitmap bmpfacetemp = Bitmap.createBitmap(bmp, faceX, faceY, faceWidth, faceHeight, null, false);
    //Bitmap bmpface = Bitmap.createScaledBitmap(bmpfacetemp, 200, 200, true);
    ByteArrayOutputStream baos2 = new ByteArrayOutputStream();
    bmpfacetemp.compress(Bitmap.CompressFormat.JPEG, 100, baos2);// 质量压缩方法，这里100表示不压缩，把压缩后的数据存放到baos中
    int options = 90;
    while (baos2.toByteArray().length / 1024 > 30) { // 循环判断如果压缩后图片是否大于100kb,大于继续压缩
      baos2.reset(); // 重置baos即清空baos
      bmpfacetemp.compress(Bitmap.CompressFormat.JPEG, options, baos2);// 这里压缩options%，把压缩后的数据存放到baos中
      options -= 10;// 每次都减少10
    }
    FileOutputStream outStreamface = null;
    String facePath=successPath+"/face.jpg";
    outStreamface = new FileOutputStream(facePath);
    outStreamface.write(baos2.toByteArray());
    outStreamface.close();

    String path=fullPath+","+facePath;
    System.out.println(path);
    return  path;

  }

  public static String getFilePath() {
    String directoryPath="";
//判断SD卡是否可用
    if ((Environment.MEDIA_MOUNTED.equals(Environment.getExternalStorageState()) )) {
      //directoryPath =context.getExternalFilesDir(dir).getAbsolutePath() ;
   directoryPath =Environment.getExternalStorageDirectory().getPath() ;
    }else{
//没内存卡就存机身内存
      directoryPath=Environment.getDataDirectory().getPath();
// directoryPath=context.getCacheDir()+File.separator+dir;
    }
    File file = new File(directoryPath);
    if(!file.exists()){//判断文件目录是否存在
      file.mkdirs();
    }
    System.out.println("filePath====>"+directoryPath);
    return directoryPath;
  }

  public Allocation renderScriptNV21ToRGBA888(int width, int height, byte[] nv21) {
    // https://stackoverflow.com/a/36409748
    RenderScript rs = RenderScript.create(this);
    ScriptIntrinsicYuvToRGB yuvToRgbIntrinsic = ScriptIntrinsicYuvToRGB.create(rs, Element.U8_4(rs));

    Type.Builder yuvType = new Type.Builder(rs, Element.U8(rs)).setX(nv21.length);
    Allocation in = Allocation.createTyped(rs, yuvType.create(), Allocation.USAGE_SCRIPT);

    Type.Builder rgbaType = new Type.Builder(rs, Element.RGBA_8888(rs)).setX(width).setY(height);
    Allocation out = Allocation.createTyped(rs, rgbaType.create(), Allocation.USAGE_SCRIPT);

    in.copyFrom(nv21);

    yuvToRgbIntrinsic.setInput(in);
    yuvToRgbIntrinsic.forEach(out);
    return out;
  }

  public static int getBright(Bitmap bm) {
    int width = bm.getWidth();
    int height = bm.getHeight();
    int r, g, b;
    int count = 0;
    int bright = 0;
    for(int i = 0; i < width; i++) {
      for(int j = 0; j < height; j++) {
        count++;
        int localTemp = bm.getPixel(i, j);
        r = (localTemp | 0xff00ffff) >> 16 & 0x00ff;
        g = (localTemp | 0xffff00ff) >> 8 & 0x0000ff;
        b = (localTemp | 0xffffff00) & 0x0000ff;
        bright = (int) (bright + 0.299 * r + 0.587 * g + 0.114 * b);
      }
    }
    return bright / count;
  }




    public static byte[] yuv2Jpeg(byte[] yuvBytes, int width, int height) {
      YuvImage yuvImage = new YuvImage(yuvBytes, ImageFormat.NV21, width, height, null);

      ByteArrayOutputStream baos = new ByteArrayOutputStream();
      yuvImage.compressToJpeg(new Rect(0, 0, width, height), 100, baos);

      return baos.toByteArray();
    }

    public static Bitmap rotateBitmap(Bitmap sourceBitmap, int degree) {
      Matrix matrix = new Matrix();
      matrix.setRotate(degree);
      //if(degree==270)
      //matrix.postScale(-1, 1);
      return Bitmap.createBitmap(sourceBitmap, 0, 0, sourceBitmap.getWidth(), sourceBitmap.getHeight(), matrix, true);
    }


    public static void saveBitmap(Bitmap bitmap, String path) {
      if(bitmap != null) {
        try {
          bitmap.compress(Bitmap.CompressFormat.JPEG, 100, new FileOutputStream(new File(path)));
        } catch (FileNotFoundException e) {
          e.printStackTrace();
        }
      }
    }



}

