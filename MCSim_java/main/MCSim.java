package main;

import java.lang.Math;
import java.util.Arrays;

import main.classes.*;

public class MCSim {

  public char[] data;
  // src -> (dst, len)
  public CTTArray CTT;

  public MCSim (char[] data){
    CTT = new CTTArray();
    this.data = data;
  }
 
  //public void mc_lazy(int src, int dst, int len) {
  public void mc_lazy() {
    int index = CTT.nextSlot();
    CTTEntry entry = CTT.getEntry(index);

    for(int i = 0; i < entry.dst.len; i++){
      data[entry.dst.addr + i] = data[entry.src + i];
    }

    CTT.removeEntry(index);
  }

  public boolean add_entry(int src, int dst_addr, int len){
    // new dst overlaps with old src --> ok to add if executing CTT entries in order
    if(CTT.in_src(new Req(false, dst_addr, len, null))){
      return false;
    }

    Integer[] indexes_dst = CTT.in_dst(new Req(false, dst_addr, len, null));

    Arrays.sort(indexes_dst, (i, j) -> Integer.compare(CTT.getEntry(i).dst.addr, CTT.getEntry(j).dst.addr));

    int start = dst_addr;
    int end = 0;
    for(int i = 0; i < indexes_dst.length; i++){
      if(i == indexes_dst.length - 1){
        end = dst_addr + len - 1;
      }else{
        end = CTT.getEntry(indexes_dst[i + 1]).dst.addr - 1;
      }

      dst_dst(src + start - dst_addr, start, end - start + 1, indexes_dst[i]);
      start = end + 1;
    }

    Integer[] indexes_src = CTT.in_dst(new Req(false, src, len, null));
    
    //System.out.println("indexes_dst: " + Arrays.toString(indexes_dst));
    //System.out.println("indexes_src: " + Arrays.toString(indexes_src));

    if(indexes_src.length == 0){
      CTT.addEntry(new CTTEntry(src, dst_addr, len));
      return true;
    }

    Arrays.sort(indexes_src, (i, j) -> Integer.compare(CTT.getEntry(i).dst.addr, CTT.getEntry(j).dst.addr));

    start = src;
    end = 0;
    for(int i = 0; i < indexes_src.length; i++){
      if(i == indexes_src.length - 1){
        end = src + len - 1;
      }else{
        end = CTT.getEntry(indexes_src[i + 1]).dst.addr - 1;
      }

      dst_src(start, dst_addr + start - src, end - start + 1, indexes_src[i]);
      start = end + 1;
    }

    return true;
  }

  private void dst_dst(int src, int dst_addr, int len, int index_dst){
    //System.out.println("in dst_dst");
    int start = CTT.getEntry(index_dst).dst.addr;
    int end = CTT.getEntry(index_dst).dst.addr + CTT.getEntry(index_dst).dst.len - 1;
    int src_addr = CTT.getEntry(index_dst).src;

    if (dst_addr <= start) {
      //System.out.println("entry less than overlap");
      if (dst_addr + len - 1 >= end) {
        //System.out.println("removing entire entry");
        CTT.removeEntry(index_dst);
      } else {
        CTT.removeEntry(index_dst);
        CTT.addEntry(new CTTEntry(src_addr + dst_addr + len - start, dst_addr + len,
                end - (dst_addr + len) + 1));
      }
    } else {
      //System.out.println("entry greater than overlap");
      if (dst_addr + len - 1 >= end) {
        //System.out.println("end of new entry greater than end of old entry");
        CTT.removeEntry(index_dst);
        CTT.addEntry(new CTTEntry(src_addr, start, dst_addr - start));
      } else {
        CTT.removeEntry(index_dst);
        CTT.addEntry(new CTTEntry(src_addr, start, dst_addr - start));
        CTT.addEntry(new CTTEntry(src_addr + dst_addr + len - start,
            dst_addr + len, end - (dst_addr + len) + 1));
      }
    }
    //CTT.addEntry(new CTTEntry(src, dst_addr, len));
  }

  private void dst_src(int src, int dst_addr, int len, int index_src){
    int start = CTT.getEntry(index_src).dst.addr;
    int end = CTT.getEntry(index_src).dst.addr + CTT.getEntry(index_src).dst.len - 1;
    int src_addr = CTT.getEntry(index_src).src;

    if(src < start){
      if(src + len - 1 <= end){
        CTT.addEntry(new CTTEntry(src, dst_addr, start - src));
        CTT.addEntry(new CTTEntry(src_addr, dst_addr + start - src, src + len - start));
      }else{
        CTT.addEntry(new CTTEntry(src, dst_addr, start - src));
        CTT.addEntry(new CTTEntry(src_addr, dst_addr + start - src, end - start + 1));
        CTT.addEntry(new CTTEntry(end + 1, dst_addr + end - src + 1, src + len - end - 1));
      }
    }else{
      if(src + len - 1 <= end){
        CTT.addEntry(new CTTEntry(src_addr + src - start, dst_addr, len));
      }else{
        CTT.addEntry(new CTTEntry(src_addr + src - start, dst_addr, end - src + 1));
        CTT.addEntry(new CTTEntry(end + 1, dst_addr + end - src + 1, src + len - end - 1));
      }
    }
  }
   
  // return void if write, read data if read request
  public char[] handle_mem_req(Req req) {
    if (req.is_read) {
      return handle_read(req);
    } else {
      if(!handle_write(req)){
        return null;
      }else{
        char[] result = new char[1];
        result[0] = 'a';
        return result;
      }
    }
  }

  public boolean handle_write(Req req){
    boolean src_overlap = CTT.in_src(req);

    while(src_overlap){
      return false;
    }

    Integer[] indexes = CTT.in_dst(req);

    if(indexes.length == 0){
      writeData(req.addr, req.size, req.data);
      return true;
    }

    if(indexes.length == 1){
      handle_write_helper(req, indexes[0]);
      return true;
    }

    Arrays.sort(indexes, (i, j) -> Integer.compare(CTT.getEntry(i).dst.addr, CTT.getEntry(j).dst.addr));

    int start = req.addr;
    int end = 0;
    char[] result = new char[req.size];
    for(int i = 0; i < indexes.length; i++){
      if(i == indexes.length - 1){
        end = req.addr + req.size - 1;
      }else{
        end = CTT.getEntry(indexes[i + 1]).dst.addr - 1;
      }

      char[] partial_data = new char[end - start + 1];
      System.arraycopy(req.data, start - req.addr, partial_data, 0, partial_data.length);
      Req req1 = new Req(false, start, end - start + 1, partial_data); 
      handle_write_helper(req1, indexes[i]);
      start = end + 1;
    }

   /* 
   int smaller_index, larger_index;
   if(CTT.getEntry(indexes[0]).dst.addr < CTT.getEntry(indexes[0]).dst.addr){
      smaller_index = indexes[0];
      larger_index = indexes[1];
   }else{
      smaller_index = indexes[1];
      larger_index = indexes[0];
   }

   CTTEntry larger_entry = CTT.getEntry(larger_index);
   char[] partial_data = new char[larger_entry.dst.addr - req.addr];
   System.arraycopy(req.data, 0, partial_data, 0, partial_data.length);
   Req req1 = new Req(false, req.addr, larger_entry.dst.addr - req.addr, partial_data);

   handle_write_helper(req1, smaller_index);

   partial_data = new char[req.addr + req.size - larger_entry.dst.addr];
   System.arraycopy(req.data, larger_entry.dst.addr - req.addr, partial_data, 0, partial_data.length);
   req1 = new Req(false, larger_entry.dst.addr, req.addr + req.size - larger_entry.dst.addr, partial_data);
   handle_write_helper(req1, larger_index);
   */
   return true;
  }
   
  public char[] handle_write_helper(Req req, int index) {
    // can req be part of src and dst?

    int start = CTT.getEntry(index).dst.addr;
    int end = CTT.getEntry(index).dst.addr + CTT.getEntry(index).dst.len - 1;
    int src_addr = CTT.getEntry(index).src;

    CTT.removeEntry(index);
    if (req.addr <= start) {
      if (req.addr + req.size - 1 < end) {
        CTT.addEntry(new CTTEntry(src_addr + req.addr + req.size - start,
            req.addr + req.size, end - (req.addr + req.size) + 1));
      }
    } else {
      if (req.addr + req.size - 1 >= end) {
        CTT.addEntry(new CTTEntry(src_addr, start, req.addr - start));
      } else {
        CTT.addEntry(new CTTEntry(src_addr, start, req.addr - start));
        CTT.addEntry(new CTTEntry(src_addr + req.addr + req.size - start,
            req.addr + req.size, end - (req.addr + req.size) + 1));
      }
    }
    writeData(req.addr, req.size, req.data);
    
    return null;
  }

  public char[] handle_read(Req req){
    //System.out.println("handle read: " + req.addr + "-" + (req.addr + req.size - 1));
    Integer[] indexes = CTT.in_dst(req);

    if(indexes.length == 0){
      return getData(req.addr, req.size);
   }

   if(indexes.length == 1){
    return handle_read_helper(req, indexes[0]);
   }
   
    
   Arrays.sort(indexes, (i, j) -> Integer.compare(CTT.getEntry(i).dst.addr, CTT.getEntry(j).dst.addr));

    int start = req.addr;
    int end = 0;
    char[] result = new char[req.size];
    for(int i = 0; i < indexes.length; i++){
      if(i == indexes.length - 1){
        end = req.addr + req.size - 1;
      }else{
        end = CTT.getEntry(indexes[i + 1]).dst.addr - 1;
      }

      //System.out.println("start: " + start + ", end: " + end);
      Req req1 = new Req(true, start, end - start + 1, null); 
      char[] partial_result = handle_read_helper(req1, indexes[i]);
      System.arraycopy(partial_result, 0, result, start - req.addr, partial_result.length);
      start = end + 1;
    }
/* 
   char[] result = new char[req.size];
   char[] partial_result;

   CTTEntry larger_entry = CTT.getEntry(larger_index);
   Req req1 = new Req(true, req.addr, larger_entry.dst.addr - req.addr, null);
   System.out.println("indexes: " + Arrays.toString(indexes));
   partial_result = handle_read_helper(req1, smaller_index);
   System.arraycopy(partial_result, 0, result, 0, partial_result.length);

   req1 = new Req(true, larger_entry.dst.addr, req.addr + req.size - larger_entry.dst.addr, null);
   partial_result = handle_read_helper(req1, larger_index);
   System.arraycopy(partial_result, 0, result, larger_entry.dst.addr - req.addr, partial_result.length);
   */

  //System.out.println(req.addr + "-" + (req.addr + req.size - 1) + ": overlaps with multiple entries");

   return result;
  }
    
 
  public char[] handle_read_helper(Req req, int index) {
    int start = CTT.getEntry(index).dst.addr;
    int end = CTT.getEntry(index).dst.addr + CTT.getEntry(index).dst.len - 1;
    int src_addr = CTT.getEntry(index).src;
    char[] result = new char[req.size];
  
    if (req.addr < start) {
      char[] result1 = getData(req.addr, start - req.addr);
      char[] result2 = getData(src_addr, req.addr + req.size - start);
      System.arraycopy(result1, 0, result, 0, result1.length);
      System.arraycopy(result2, 0, result, result1.length, result2.length);
      return result;
    } else {
      if (req.addr + req.size - 1 > end) {
        char[] result1 = getData(src_addr + req.addr - start,
          end - req.addr + 1);
        char[] result2 = getData(end + 1, req.addr + req.size - 1 - end);
        System.arraycopy(result1, 0, result, 0, result1.length);
        System.arraycopy(result2, 0, result, result1.length, result2.length);
        return result;
      } else {
        char[] result1 = getData(src_addr + req.addr - start, req.size);
        return result1;
      }
    }
  }

  public char[] getData(int start, int len){
    char[] result = new char[len];
    for(int i = 0; i < len; i++){
      result[i] += data[start + i];
    }
    return result;
  }

  public void writeData(int addr, int len, char[] new_data){
    for(int i = 0; i < len; i++){
      data[addr + i] = new_data[i];
    }
  }
}