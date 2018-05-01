import processing.core.*;
import processing.data.*;

import java.util.Map;
import java.util.Iterator;
import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Scanner;

import java.io.FileInputStream;
import java.io.BufferedInputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.File;

public class Key implements Comparable {

    public static Key[] keys = new Key[] {};
    public static int min, max;

    static {
        loadKeys();
        min = keys[0].amount;
        max = keys[keys.length - 1].amount;
    }

    public Integer amount;
    public String value;
    public PVector position;

    public Key(String value, Integer amount, PVector position) {
        this.value = value;
        this.amount = amount;
        this.position = position;
    }

    public Key increment() {
        this.amount++;
        return this;
    }

    public static Key getKeyWithValue(String value) {
        for (String v : KeyPosition.getValues(value)) {
            for (Key key : keys) {
                if (Arrays.asList(v).contains(key.value)) {
                    return key;
                }
            }
        }
        return null;
    }

    private static void loadKeys() {
        Map<String, Key> keyMap = new HashMap<String, Key>();

        try {
            FileInputStream fstream = new FileInputStream("keylogger.csv");
            BufferedReader br = new BufferedReader(new InputStreamReader(fstream));

            String line;
            while ((line = br.readLine()) != null) {
                boolean found = false;
                for (String value : KeyPosition.getValues(line)) {
                    Key key = keyMap.get(value);
                    if (key != null) {
                        keyMap.put(value, key.increment());
                        found = true;
                        break;
                    }
                }

                if (!found) {
                    PVector position = KeyPosition.getPosition(line);
                    if (position != null) {
                        keyMap.put(line, new Key(line, 1, position));
                    }
                }
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

    @Override
    public String toString() {
        return this.value + " " + this.amount + " " + this.position.x + ", " + this.position.y;
    }
}