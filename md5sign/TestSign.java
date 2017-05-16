package io.lvyong1985.github.crypto;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.security.GeneralSecurityException;
import java.security.MessageDigest;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

/**
 * @author: lvyong1985
 */
public class TestSign {

    /**
     * @param args
     * @throws IOException
     */
    public static void main(String[] args) throws IOException {
        String appSecurity = "NhycYKdy7J0QqDXw";
        String appKey = "17f233b067464215b47ae45eea9e9fe8";

        HashMap<String, String> map = new HashMap<String, String>();
        map.put("app_key", appKey);
        map.put("method", "taobao.data.wifidevice.list");
        map.put("app_secret", appSecurity);
        map.put("ts", "1494671916");
        map.put("orderNo", "100000209");
        map.put("productInfo", "[{\"test\":1}]");
        String sign = signTopRequestNew(map, appSecurity, false);
        System.out.println("sign:" + sign);// 077646973bc192c3292f5e85a4ea2ab8
    }

    public static String signTopRequestNew(Map<String, String> params, String secret, boolean isHmac) throws IOException {
        String[] keys = (String[]) params.keySet().toArray(new String[0]);
        Arrays.sort(keys);
        StringBuilder query = new StringBuilder();
        if (!isHmac) {
            query.append(secret);
        }

        String[] bytes = keys;
        int len$ = keys.length;

        for (int i$ = 0; i$ < len$; ++i$) {
            String key = bytes[i$];
            String value = (String) params.get(key);
            if (areNotEmpty(new String[]{key, value})) {
                query.append(key).append(value);
            }
        }

        byte[] var10;
        if (isHmac) {
            var10 = encryptHMAC(query.toString(), secret);
        } else {
            query.append(secret);
            var10 = encryptMD5(query.toString());
        }

        return byte2hex(var10);
    }

    private static byte[] encryptHMAC(String data, String secret) throws IOException {
        try {
            SecretKeySpec gse = new SecretKeySpec(secret.getBytes("UTF-8"), "HmacMD5");
            Mac msg1 = Mac.getInstance(gse.getAlgorithm());
            msg1.init(gse);
            return msg1.doFinal(data.getBytes("UTF-8"));
        } catch (GeneralSecurityException var5) {
            String msg = getStringFromException(var5);
            throw new IOException(msg);
        }
    }

    public static byte[] encryptMD5(String data) throws IOException {
        return encryptMD5(data.getBytes("UTF-8"));
    }

    public static byte[] encryptMD5(byte[] data) throws IOException {
        Object bytes = null;

        try {
            MessageDigest gse = MessageDigest.getInstance("MD5");
            byte[] bytes1 = gse.digest(data);
            return bytes1;
        } catch (GeneralSecurityException var4) {
            String msg = getStringFromException(var4);
            throw new IOException(msg);
        }
    }

    public static String byte2hex(byte[] bytes) {
        StringBuilder sign = new StringBuilder();
        for (int i = 0; i < bytes.length; ++i) {
            String hex = Integer.toHexString(bytes[i] & 255);
            if (hex.length() == 1) {
                sign.append("0");
            }
            sign.append(hex.toLowerCase());
        }
        return sign.toString();
    }

    private static String getStringFromException(Throwable e) {
        String result = "";
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        PrintStream ps = new PrintStream(bos);
        e.printStackTrace(ps);

        try {
            result = bos.toString("UTF-8");
        } catch (IOException var5) {
            ;
        }

        return result;
    }

    public static boolean areNotEmpty(String... values) {
        boolean result = true;
        if (values != null && values.length != 0) {
            String[] arr$ = values;
            int len$ = values.length;

            for (int i$ = 0; i$ < len$; ++i$) {
                String value = arr$[i$];
                result &= !isEmpty(value);
            }
        } else {
            result = false;
        }

        return result;
    }

    public static boolean isEmpty(String value) {
        int strLen;
        if (value != null && (strLen = value.length()) != 0) {
            for (int i = 0; i < strLen; ++i) {
                if (!Character.isWhitespace(value.charAt(i))) {
                    return false;
                }
            }
            return true;
        } else {
            return true;
        }
    }
}
