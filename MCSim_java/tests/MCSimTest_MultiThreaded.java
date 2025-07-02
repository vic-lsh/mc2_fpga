package tests;

import static org.junit.Assert.assertArrayEquals;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.Random;
import java.util.Scanner;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.*;

import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;

import main.*;
import main.classes.*;

public class MCSimTest_MultiThreaded {
  private static final int mem_size = 1024;
  private static final int len = 192;

  BufferedWriter myWriter;

  char[] baseline = new char[mem_size];
  MCSim mcsim;

  private Object lock = new Object();

  @Test
  //@Ignore
  public void MultiThreaded_Test(){
    Random random = new Random();
    char[] memory = new char[mem_size];
    for (int i = 0; i < mem_size; i++) {
        memory[i] = (char)(random.nextInt(122 - 97 + 1) + 97);
    }

    //char[] baseline = new char[mem_size];
    System.arraycopy(memory, 0, baseline, 0, mem_size);

    //MCSim mcsim = new MCSim(memory);
    mcsim = new MCSim(memory);

    try{
      myWriter = new BufferedWriter(new FileWriter("ctt_entries_multithreaded.txt"));
    } catch (Exception e) {
      System.out.println("error opening file");
      e.printStackTrace();
    }

    RW_addEntries thread1 = new RW_addEntries();
    Perform_Copies thread2 = new Perform_Copies();

    thread1.start();
    thread2.start();

    try{
      thread1.join();
      //thread2.join();
      myWriter.close();
    } catch (Exception e) {
      System.out.println("test not completed");
      e.printStackTrace();
    }
  }

  class RW_addEntries extends Thread {
     public void run() {
        Random random = new Random();

        char[] memory_read = new char[mem_size];
        char[] memory_read_total = new char[mem_size];
        
        try {
          //BufferedWriter myWriter = new BufferedWriter(new FileWriter("ctt_entries_multithreaded.txt"));
          long curr_time;

          long start_time = System.nanoTime();
          int prev_i = 1;

          for (int i = 1; i <= 10000; i++) {
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
            synchronized(lock){
             // myWriter.append(src + "," + dst + "," + len + "\n");
             
              

              boolean result = mcsim.add_entry(src, dst, len);
              while(!result){
                System.out.println("RW_addEntries thread is waiting : copy");
                lock.wait();
                result = mcsim.add_entry(src, dst, len);
              }

              myWriter.write(src + "," + dst + "," + len + "\n");
              myWriter.flush();

              System.arraycopy(baseline, src, baseline, dst, len);

              lock.notify();

              int write_addr = ((random.nextInt(mem_size - len + 1) / 64) * 64);

              //myWriter.append(write_addr + "," + len +  "\n");
              

              char[] random_arr = generateRandomArray(len);
              char[] result2 = mcsim.handle_mem_req(new Req(false, write_addr, len, random_arr));

              while(result2 == null){
                System.out.println("RW_addEntries thread is waiting : write");
                lock.wait();
                result2 = mcsim.handle_mem_req(new Req(false, write_addr, len, random_arr));
              }

              System.arraycopy(random_arr, 0, baseline, write_addr, len);

              myWriter.write(write_addr + "," + len +  "\n");
              myWriter.flush();

              System.out.println("src: " + src + " - " + (src + len - 1) + ", dst: " + dst + " - " + (dst + len - 1));
              System.out.println("write: " + write_addr + "-" + (write_addr + len - 1));
              System.out.println("CTT:");
              mcsim.CTT.printEntries();

              for (int j = 0; j < mem_size / 64; j++) {
                memory_read = mcsim.handle_mem_req(new Req(true, j * 64, 64, null));
                System.arraycopy(memory_read, 0, memory_read_total, j * 64, 64);
              }

              System.out.println("baseline memory: ");
              printArray(baseline);
              System.out.println("mc2 memory: ");
              printArray(memory_read_total);
              System.out.println("--------------------------------------------------------");
              System.out.println();
              assertArrayEquals(baseline, memory_read_total);

              curr_time = System.nanoTime();

              if(TimeUnit.NANOSECONDS.toMillis(curr_time - start_time) % 1000 == 0){
                //System.out.println("time: " + (TimeUnit.NANOSECONDS.toMillis(curr_time - start_time)/1000) + ", iterations = " + (i - prev_i));
                prev_i = i;
              }
            }
          }
          //myWriter.close();
        } catch (Exception e) {
          System.out.println("An error occurred with RW_addEntries Thread");
          e.printStackTrace();
        }
    }
  }

  class Perform_Copies extends Thread {
    public void run(){
      try{
        //BufferedWriter myWriter = new BufferedWriter(new FileWriter("ctt_entries_multithreaded.txt"));
        while(true){
          synchronized(lock){
            while(mcsim.CTT.size == 0){
              System.out.println("Perform_Copies thread is waiting");
              lock.wait();
            }

            //myWriter.append("mc_lazy\n");
            myWriter.write("mc_lazy\n");
            myWriter.flush();
            mcsim.mc_lazy();

            System.out.println("CTT:");
            mcsim.CTT.printEntries();
            System.out.println("--------------------------------------------------------");

            lock.notify();
          }
        }
      }catch(Exception e){
        System.out.println("An error occurred with Perform_Copies thread");
        e.printStackTrace();
      }
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
      memory[i] = (char) (random.nextInt(122 - 97 + 1) + 97);
    }

    char[] baseline = new char[mem_size];
    System.arraycopy(memory, 0, baseline, 0, mem_size);

    MCSim mcsim = new MCSim(memory);
    char[] memory_read = new char[mem_size];
    char[] memory_read_total = new char[mem_size];

    ArrayList<Integer> src_addrs = new ArrayList<>();
    ArrayList<Integer> dst_addrs = new ArrayList<>();

    try {
      File myObj = new File("ctt_entries_multithreaded.txt");
      Scanner myReader = new Scanner(myObj);
      while (myReader.hasNextLine()) {
        String data = myReader.nextLine();
        if(data.contains(",")){
          String[] parts = data.split(",");
          if(parts.length == 3){
            src_addrs.add(Integer.parseInt(parts[0]));
            dst_addrs.add(Integer.parseInt(parts[1]));
          }else{
            src_addrs.add(-1);
            dst_addrs.add(Integer.parseInt(parts[0]));
          }
        }else{
          src_addrs.add(-1);
          dst_addrs.add(-1);
        }
      }
      myReader.close();
    } catch (FileNotFoundException e) {
      System.out.println("An error occurred reading from file");
      e.printStackTrace();
    }

    for (int i = 0; i < src_addrs.size(); i++) {
      int src = src_addrs.get(i);
      int dst = dst_addrs.get(i);

      System.out.println("src: " + src + ", dst: " + dst);

      if(src == -1 && dst == -1){
        mcsim.mc_lazy();
        System.out.println("CTT:");
        mcsim.CTT.printEntries();
        System.out.println("--------------------------------------------------------");
        continue;
      }

      if(src == -1){
        char[] random_arr = generateRandomArray(len);
        mcsim.handle_mem_req(new Req(false, dst, len, random_arr));
        System.arraycopy(random_arr, 0, baseline, dst, len);

        for (int j = 0; j < mem_size / 64; j++) {
          memory_read = mcsim.handle_mem_req(new Req(true, j * 64, 64, null));
          System.arraycopy(memory_read, 0, memory_read_total, j * 64, 64);
        }

        System.out.println("src: " + src_addrs.get(i-1) + " - " + (src_addrs.get(i-1) + len - 1) + ", dst: " + dst_addrs.get(i-1) + " - " + (dst_addrs.get(i-1) + len - 1));
        System.out.println("write: " + dst + "-" + (dst + len - 1));
        System.out.println("CTT:");
        mcsim.CTT.printEntries();
        System.out.println("baseline memory: ");
        printArray(baseline);
        System.out.println("mc2 memory: ");
        printArray(memory_read_total);
        System.out.println("--------------------------------------------------------");
        System.out.println();
        assertArrayEquals(baseline, memory_read_total);
        continue;
      }

      mcsim.add_entry(src, dst, len);
      System.arraycopy(baseline, src, baseline, dst, len);

      //assertArrayEquals(baseline, memory_read_total);
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

  public char[] generateRandomArray(int len){
    Random random = new Random();
    char[] array = new char[len];
    for (int i = 0; i < len; i++) {
        array[i] = (char)(random.nextInt(122 - 97 + 1) + 97);
    }
    return array;
  }
}