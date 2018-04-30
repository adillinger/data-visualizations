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

public class KeyPosition {

    public PVector position;
    public String[] keys;

    public KeyPosition(PVector position, String[] keys) {
        this.position = position;
        this.keys = keys;
    }

    private static List<KeyPosition> keyPositions = new ArrayList<KeyPosition>();

    static {
        try {
            String line;
            FileInputStream fstream = new FileInputStream("keys.dat");
            BufferedReader br = new BufferedReader(new InputStreamReader(fstream));

            while ((line = br.readLine()) != null) {
                String[] cols = line.split(" ");
                keyPositions.add(new KeyPosition(new PVector(Float.parseFloat(cols[0]), Float.parseFloat(cols[1])),
                        Arrays.copyOfRange(cols, 2, cols.length)));
                KeyPosition k = keyPositions.get(keyPositions.size() - 1);
            }
            br.close();
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
    }

    public static PVector getPosition(String key) {
        for (KeyPosition k : keyPositions) {
            if (Arrays.asList(k.keys).contains(key)) {
                return k.position;
            }
        }

        return null;
    }

    public static String[] getValues(String key) {
        for (KeyPosition k : keyPositions) {
            if (Arrays.asList(k.keys).contains(key)) {
                return k.keys;
            }
        }

        return new String[0];
    }
}