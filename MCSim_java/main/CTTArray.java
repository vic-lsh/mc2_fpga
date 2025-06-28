package main;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.Queue;
import main.classes.*;

public class CTTArray {
  public static final int SIZE = 1000;

  public CTTEntry array[];
  public Queue<Integer> empty_slots;
  public int index;
  public int size;

  public CTTArray(){
    array = new CTTEntry[SIZE];
    empty_slots = new LinkedList<>();
    index = 0;
    size = 0;
  }

  public CTTEntry getEntry(int index){
    return array[index];
  }

  public void addEntry(CTTEntry entry){
    if (index == SIZE && empty_slots.isEmpty()) {
      throw new IllegalStateException("CTT is full. Cannot add more entries.");
    }

    if(!empty_slots.isEmpty()){
      int slot = empty_slots.remove();
      array[slot] = entry;
    }else{
      array[index] = entry;
      index++;
    }
    size++;
  }

  public void removeEntry(int index){
    array[index] = null;
    empty_slots.add(index);
    size--;
  }

  public boolean containsEntry(int src, int dst, int len){
    for(int i = 0; i < index; i++){
      if(array[i].src == src && array[i].dst.addr == dst && array[i].dst.len == len){
        return true;
      }
    }
    return false;
  }

  public boolean in_src(Req req){
    for(CTTEntry entry : array){
      if(entry == null){
        continue;
      }
      Destination dst = entry.dst;
      int src = entry.src;
      // check if in src
      if(req.addr <= src){
        if(req.addr + req.size > src){
          return true;
        }
      }else if(req.addr > src && req.addr < src + dst.len){
        return true;
      }
    }
    return false;
  }
 
  public Integer[] in_dst(Req req) {
    //int[] result = new int[2];
    ArrayList<Integer> result = new ArrayList<>();

    for(int i = 0; i < index; i++){
      CTTEntry entry = array[i];
      if(entry == null){
        continue;
      }
      Destination dst = entry.dst;
      // check if in dst
      if(req.addr <= dst.addr){
        if(req.addr + req.size > dst.addr){
          result.add(i);
          /* 
          if(result[0] == -1){
            result[0] = i;
          }else{
            result[1] = i;
          }
            */
          //return i;
         }
      }else if(req.addr > dst.addr && req.addr < dst.addr + dst.len){
        result.add(i);
        /* 
        if(result[0] == -1){
          result[0] = i;
        }else{
          result[1] = i;
        }
          */
        //return i;
       }
    }
    
    Integer[] result_array = new Integer[result.size()];

    for(int i = 0; i < result_array.length; i++){
      result_array[i] = result.get(i);
    }

    return result_array;
  }
    


  public void printEntries(){
    String result = "[";
    for(int i = 0; i < index; i++){
      if(array[i] != null){
        result += array[i].toString();
        if(i != index - 1){
          result += ", ";
        }
      }
    }
    result += "]";
    System.out.println(result);
  }
}
