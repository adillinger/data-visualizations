import processing.core.*;
import processing.data.*;

import java.util.Map;
import java.util.Iterator;

import java.io.FileInputStream;
import java.io.BufferedInputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.util.Arrays;
import java.util.HashMap;

public class Key implements Comparable {

    public static Key[] keys = new Key[] {};

    static {
        loadKeys();

        for (Key key : keys) {
            System.out.println(key.value + " : " + key.amount);
        }
    }

    public Integer amount;
    public String value;
    public PVector position;

    public Key(String value, Integer amount) {
        this.value = value;
        this.amount = amount;
        this.position = getPosition(value);
    }

    public Key increment() {
        this.amount++;
        return this;
    }

    public static PVector getPosition(String value) {
        return new PVector(0, 0);
    }

    private static void loadKeys() {
        Map<String, Key> keyMap = new HashMap<String, Key>();

        try {
            FileInputStream fstream = new FileInputStream("keylogger.csv");
            BufferedReader br = new BufferedReader(new InputStreamReader(fstream));

            String value;

            while ((value = br.readLine()) != null) {
                Key key = keyMap.get(value);
                key = key == null ? new Key(value, 1) : key.increment();
                keyMap.put(value, key);
            }
            br.close();
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }

        keys = keyMap.values().toArray(new Key[0]);
        Arrays.sort(keys);
    }

    @Override
    public int compareTo(Object k) {
        return this.amount - ((Key) k).amount;
    }
}