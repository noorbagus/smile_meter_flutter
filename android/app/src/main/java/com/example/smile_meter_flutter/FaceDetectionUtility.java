// android/app/src/main/java/com/example/smile_meter_flutter/FaceDetectionUtility.java
package com.example.smile_meter_flutter;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.ImageFormat;
import android.graphics.Rect;
import android.graphics.YuvImage;
import android.media.Image;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;

public class FaceDetectionUtility {
    
    // Convert CameraImage YUV_420_888 to NV21 format which is required by ML Kit
    public static byte[] convertYUV420ToNV21(byte[] planes0, byte[] planes1, byte[] planes2, int width, int height, int yRowStride, int uvRowStride, int uvPixelStride) {
        byte[] nv21 = new byte[width * height * 3 / 2];
        int ySize = width * height;
        int uvSize = width * height / 4;

        // Copy Y plane
        System.arraycopy(planes0, 0, nv21, 0, ySize);

        // Copy UV data
        for (int row = 0; row < height / 2; row++) {
            for (int col = 0; col < width / 2; col++) {
                int uvIndex = col * uvPixelStride + row * uvRowStride;
                nv21[ySize + row * width + col * 2] = planes1[uvIndex];
                nv21[ySize + row * width + col * 2 + 1] = planes2[uvIndex];
            }
        }

        return nv21;
    }
    
    // Convert NV21 format to Bitmap
    public static Bitmap nv21ToBitmap(byte[] nv21, int width, int height) {
        YuvImage yuvImage = new YuvImage(nv21, ImageFormat.NV21, width, height, null);
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        yuvImage.compressToJpeg(new Rect(0, 0, width, height), 100, out);
        byte[] imageBytes = out.toByteArray();
        return BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.length);
    }
}