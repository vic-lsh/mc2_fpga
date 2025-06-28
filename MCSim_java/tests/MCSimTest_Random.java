package tests; 
import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Random;
import java.util.Scanner;

import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;

import main.*;
import main.classes.*;

public class MCSimTest_Random {

    @Test
    //@Ignore
    public void RandomTest() {
        final int mem_size = 1024;
        final int len = 192;

        Random random = new Random();

        char[] memory = new char[mem_size];
        for (int i = 0; i < mem_size; i++) {
            memory[i] = (char)(random.nextInt(122 - 97 + 1) + 97);
        }

        char[] baseline = new char[mem_size];
        System.arraycopy(memory, 0, baseline, 0, mem_size);

        MCSim mcsim = new MCSim(memory);
        char[] memory_read = new char[mem_size];
        char[] memory_read_total = new char[mem_size];
        
        try {
          //File file = new File("ctt_entries.txt");
          //if (!file.createNewFile()) {
            // file already exists --> delete it and create a new one
            //file.delete();
            //file.createNewFile();
          //}
          BufferedWriter myWriter = new BufferedWriter(new FileWriter("ctt_entries.txt"));
          //myWriter.write("");

          for (int i = 1; i <= 100; i++) {
            // make sure randomly generated values are cache lined aligned
            int src = random.nextInt(mem_size - len + 1);
            int dst;
            while (true) {
              dst = ((random.nextInt(mem_size - len + 1) / 64) * 64);
              if (dst <= src) {
                if (dst + len <= src) {
                  break;
                }
              } else if (dst > src && dst >= src + len) {
                break;
              }

            }

            //FileWriter myWriter = new FileWriter("ctt_entries.txt");
            myWriter.append(src + "," + dst + "\n");
            myWriter.flush();

            mcsim.add_entry(src, dst, len);
            System.arraycopy(baseline, src, baseline, dst, len);

            System.out.println("src: " + src + " - " + (src + len - 1) + ", dst: " + dst + " - " + (dst + len - 1));
            System.out.println("CTT:");
            mcsim.CTT.printEntries();

            for (int j = 0; j < mem_size / 64; j++) {
              memory_read = mcsim.handle_mem_req(new Req(true, j * 64, 64, null));
              System.arraycopy(memory_read, 0, memory_read_total, j * 64, 64);
            }

            System.out.println("baseline memory: ");
            // System.out.println(Arrays.toString(baseline));
            printArray(baseline);
            System.out.println("mc2 memory: ");
            // System.out.println(Arrays.toString(memory_read_total));
            printArray(memory_read_total);
            System.out.println("--------------------------------------------------------");
            System.out.println();
            assertArrayEquals(baseline, memory_read_total);
          }

          //myWriter.close();
        } catch (IOException e) {
          System.out.println("An error occurred with writing to file");
          e.printStackTrace();
        }
    }

    @Test
    @Ignore
    public void replayPrevious() {
        final int mem_size = 1024;
        final int len = 192;

        Random random = new Random();

        char[] memory = new char[mem_size];
        for (int i = 0; i < mem_size; i++) {
            memory[i] = (char)(random.nextInt(122 - 97 + 1) + 97);
        }

        char[] baseline = new char[mem_size];
        System.arraycopy(memory, 0, baseline, 0, mem_size);

        MCSim mcsim = new MCSim(memory);
        char[] memory_read = new char[mem_size];
        char[] memory_read_total = new char[mem_size];
        
        ArrayList<Integer> src_addrs = new ArrayList<>();
        ArrayList<Integer> dst_addrs = new ArrayList<>();

        try {
          File myObj = new File("ctt_entries.txt");
          Scanner myReader = new Scanner(myObj);
          while (myReader.hasNextLine()) {
            String data = myReader.nextLine();
            String[] parts = data.split(",");
            src_addrs.add(Integer.parseInt(parts[0]));
            dst_addrs.add(Integer.parseInt(parts[1]));
          }
          myReader.close();
        } catch (FileNotFoundException e) {
          System.out.println("An error occurred reading from file");
          e.printStackTrace();
        }
 
       for(int i = 0; i < src_addrs.size(); i++){
          int src = src_addrs.get(i);
          int dst = dst_addrs.get(i);

          mcsim.add_entry(src, dst, len);
          System.arraycopy(baseline, src, baseline, dst, len);

          System.out.println("src: " + src + " - " + (src + len - 1) + ", dst: " + dst+ " - " + (dst + len - 1) );
          System.out.println("CTT:");
          mcsim.CTT.printEntries();

          for(int j = 0; j < mem_size/64; j++){
            memory_read = mcsim.handle_mem_req(new Req(true, j*64, 64, null));
            System.arraycopy(memory_read, 0, memory_read_total, j*64, 64);
          }
          
        
          System.out.println("baseline memory: ");
          //System.out.println(Arrays.toString(baseline));
          printArray(baseline);
          System.out.println("mc2 memory: ");
          //System.out.println(Arrays.toString(memory_read_total));
          printArray(memory_read_total);
          System.out.println("--------------------------------------------------------");
          System.out.println();
          assertArrayEquals(baseline, memory_read_total);
       }
        
    }

    public void printArray(char[] arr){
      String result = "[";
      for(int i = 0; i < arr.length; i++){
        result += "" + i + ": " + arr[i];
        if(i != arr.length - 1){
          result += ", ";
        }
      }
      result += "]";
      System.out.println(result);
    }
}
