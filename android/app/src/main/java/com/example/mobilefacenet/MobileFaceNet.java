package com.mqcanteen.fluttercanteen;

import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import androidx.annotation.NonNull;
import java.nio.MappedByteBuffer;
import java.io.FileInputStream;
import java.nio.channels.FileChannel;
import java.io.IOException;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.Tasks;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.ml.common.FirebaseMLException;
import com.google.firebase.ml.custom.FirebaseCustomLocalModel;
import com.google.firebase.ml.custom.FirebaseModelDataType;
import com.google.firebase.ml.custom.FirebaseModelInputOutputOptions;
import com.google.firebase.ml.custom.FirebaseModelInputs;
import com.google.firebase.ml.custom.FirebaseModelInterpreter;
import com.google.firebase.ml.custom.FirebaseModelInterpreterOptions;
import com.google.firebase.ml.custom.FirebaseModelOutputs;

/**
 * 人脸比对
 */
public class MobileFaceNet {
    //private static final String MODEL_FILE = "MobileFaceNet.tflite";
    private static final String MODEL_FILE = "mobilenet.tflite";

    private FirebaseModelInterpreter firebaseInterpreter;
    private FirebaseModelInputOutputOptions dataOptions;


    public static final int INPUT_IMAGE_SIZE = 112; // 需要feed数据的placeholder的图片宽高
    public static final float THRESHOLD = 0.8f; // 设置一个阙值，大于这个值认为是同一个人
    public float[][] embeddings1=new float[1][512];


    public MobileFaceNet(AssetManager assetManager) throws IOException {
        FirebaseCustomLocalModel localModel = new FirebaseCustomLocalModel.Builder().setAssetFilePath(MODEL_FILE).build();
        try {
            FirebaseModelInterpreterOptions options = new FirebaseModelInterpreterOptions.Builder(localModel).build();
            firebaseInterpreter = FirebaseModelInterpreter.getInstance(options);
            dataOptions=new FirebaseModelInputOutputOptions.Builder()
                    .setInputFormat(0, FirebaseModelDataType.FLOAT32, new int[]{1,INPUT_IMAGE_SIZE, INPUT_IMAGE_SIZE, 3})
                    .setOutputFormat(0, FirebaseModelDataType.FLOAT32, new int[]{1,512})
                    .build();
        } catch (FirebaseMLException e) {
            // ...
        }
    }

    public  float[] getfeature(Bitmap bitmap1)
    {
        // 将人脸resize为112X112大小的，因为下面需要feed数据的placeholder的形状是(1, 112, 112, 3)
        Bitmap bitmapScale1 = Bitmap.createScaledBitmap(bitmap1, INPUT_IMAGE_SIZE, INPUT_IMAGE_SIZE, true);
        float[][][][] datasets1 = new float[1][INPUT_IMAGE_SIZE][INPUT_IMAGE_SIZE][3];
        datasets1 = getImageDatasets(bitmapScale1);
        try {
            FirebaseModelInputs inputs = new FirebaseModelInputs.Builder().add(datasets1).build();
            Task<FirebaseModelOutputs> getfeatureTask = firebaseInterpreter.run(inputs, dataOptions).addOnSuccessListener(
                    new OnSuccessListener<FirebaseModelOutputs>() {
                        @Override
                        public void onSuccess(FirebaseModelOutputs result) {
                            System.out.println("444444444444");
                        }
                    }).addOnFailureListener(
                    new OnFailureListener() {
                        @Override
                        public void onFailure(@NonNull Exception e) {
                            System.out.println("555555555");

                        }
                    });
            try {
                for(int i=0;i<10;i++) {
                    if(getfeatureTask.isSuccessful()) break;
                    Thread.sleep(100*3);
                    Tasks.await(getfeatureTask);
                }
            } catch(Exception e){
                System.out.println("666666aaaaa");
                //handle error
            }

            float[][] output = getfeatureTask.getResult().getOutput(0);
            l2Normalize(output, 1e-10);
            embeddings1 = output;

        }catch (FirebaseMLException e) {
            System.out.println("GET FEATURE FAIL");
            // ...
        }

        System.out.println("66666666666bbbbbbb");
        return  embeddings1[0];

    }

    public float compare(Bitmap bitmap1, Bitmap bitmap2) {
        float[] feature1=getfeature(bitmap1);
        System.out.println(feature1);
        float[] feature2=getfeature(bitmap2);
        System.out.println(feature2);
        return evaluate(feature1,feature2);
    }

    /**
     * 计算两张图片的相似度
     * @param feature1
     * @param feature2
     * @return
     */
    private float evaluate(float[] feature1,float[] feature2) {
        float dist = 0;
        for (int i = 0; i < 512; i++) {
            dist += Math.pow(feature1[i] - feature2[i], 2);
        }
        float same = 0;
        for (int i = 0; i < 400; i++) {
            float threshold = 0.01f * (i + 1);
            if (dist < threshold) {
                same += 1.0 / 400;
            }
        }
        return same;
    }

    public float getMold(String [] feature)
    {
        int n=feature.length;
        float sum=(float) 0.0;
        for (int i=0;i<n;i++)
        {
            sum+=Float.parseFloat(feature[i])*Float.parseFloat(feature[i]);
        }
        return (float)Math.sqrt(sum);
    }

    /**
     * 计算两张图片的相似度
     * @param feature1
     * @param feature2
     * @return
     */
    public float evaluate(String feature1,String feature2) {
        System.out.println(feature1);
        System.out.println(feature2);
        String [] feature1list=null;
        String [] feature2list=null;
        feature1list=feature1.split(",");
        feature2list=feature2.split(",");
        if(feature1list.length!=feature2list.length||feature1list.length==0)
            return (float) 0.0;


        int n=feature1list.length;
        float temp= (float)0.0;
        for (int i=0;i<n;i++)
        {
            temp+=Float.parseFloat(feature1list[i])*Float.parseFloat(feature2list[i]);
        }

        return  temp/(getMold(feature1list)*getMold(feature2list));
    }

    /**
     * 转换两张图片为归一化后的数据
     * @param bitmap1
     * @param bitmap2
     * @return
     */
    private float[][][][] getTwoImageDatasets(Bitmap bitmap1,Bitmap bitmap2) {
        Bitmap[] bitmaps = {bitmap1,bitmap2};

        int[] ddims = {bitmaps.length, INPUT_IMAGE_SIZE, INPUT_IMAGE_SIZE, 3};
        float[][][][] datasets = new float[ddims[0]][ddims[1]][ddims[2]][ddims[3]];

        for (int i = 0; i < ddims[0]; i++) {
            Bitmap bitmap = bitmaps[i];
            datasets[i] = normalizeImage(bitmap);
        }
        return datasets;
    }

    private float[][][][] getImageDatasets(Bitmap bitmap1) {
        int[] ddims = {1,INPUT_IMAGE_SIZE, INPUT_IMAGE_SIZE, 3};
        float[][][][] datasets = new float[ddims[0]][ddims[1]][ddims[2]][ddims[3]];

        datasets[0] = normalizeImage(bitmap1);
        return datasets;
    }

    /**
     * l2正则化
     * @param embeddings
     * @param epsilon 惩罚项
     * @return
     */
    public static void l2Normalize(float[][] embeddings, double epsilon) {
        for (int i = 0; i < embeddings.length; i++) {
            float squareSum = 0;
            for (int j = 0; j < embeddings.length; j++) {
                squareSum += Math.pow(embeddings[i][j], 2);
            }
            //float xInvNorm = (float) Math.sqrt(squareSum);
            float xInvNorm = (float) Math.sqrt(Math.max(squareSum, epsilon));
            for (int j = 0; j < embeddings.length; j++) {
                embeddings[i][j] = embeddings[i][j] / xInvNorm;
            }
        }
    }


    /**
     * 归一化图片到[-1, 1]
     * @param bitmap
     * @return
     */
    public static float[][][] normalizeImage(Bitmap bitmap) {
        int h = bitmap.getHeight();
        int w = bitmap.getWidth();
        float[][][] floatValues = new float[h][w][3];

        float imageMean = 127.5f;
        float imageStd = 128;

        int[] pixels = new int[h * w];
        bitmap.getPixels(pixels, 0, bitmap.getWidth(), 0, 0, w, h);
        for (int i = 0; i < h; i++) { // 注意是先高后宽
            for (int j = 0; j < w; j++) {
                final int val = pixels[i * w + j];
                float r = (((val >> 16) & 0xFF)) ;
                float g = (((val >> 8) & 0xFF) ) ;
                float b = ((val & 0xFF) ) ;
                float[] arr = {r, g, b};
                floatValues[i][j] = arr;
            }
        }
        return floatValues;
    }

}
