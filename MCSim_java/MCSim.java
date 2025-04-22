// assuming each req can only overlap with one CTT entry
// can either break up req or change code to handle one req overlapping with multiple
// CTT entries
// convert hashmap to array

import java.util.HashMap;
import java.lang.Math;

public class MCSim {

  public class Destination {
    int addr;
    int len;

    public Destination(int addr, int len){
      this.addr = addr;
      this.len = len;
    }
  }

  public class Overlap {
    int start;
    // inclusive
    int end;
    int src_addr;

    public Overlap(int start, int end, int src_addr){
      this.start = start;
      this.end = end;
      this.src_addr = src_addr;
    }
  }

  public char[] data;
  // src -> (dst, len)
  public HashMap<Integer, Destination> CTT;

  public MCSim (char[] data){
    CTT = new HashMap<>();
    this.data = data;
  }

  public void mc_lazy(int src, int dst, int len) {
    for(int i = 0; i < len; i++){
      data[dst + i] = data[src + i];
    }

    CTT.remove(src);
  }

  public void add_entry(int src, int dst, int len){
    CTT.put(src, new Destination(dst, len));
  }
  
  // return void if write, read data if read request
  public char[] handle_mem_req(Req req) {
    if (req.is_read) {
      return handle_read(req);
    } else {
      return handle_write(req);
    }
  }

  public char[] handle_write(Req req) {
    // can req be part of src and dst?
    Overlap src_overlap = in_src(req);
    Overlap dst_overlap = in_dst(req);
    
    while(src_overlap != null){
      // wait for copy
      //this.wait();
      src_overlap = in_src(req);
    }

    if(dst_overlap != null){
      Destination dst = CTT.get(dst_overlap.src_addr);
      if(req.addr < dst_overlap.start || req.addr == dst.addr){
        if(req.addr + req.size >= dst.addr + dst.len){
          CTT.remove(dst_overlap.src_addr);
        }else{
          CTT.put(dst_overlap.src_addr + dst_overlap.end - dst_overlap.start + 1,
              new Destination(req.addr + req.size, 
              dst.len - (dst_overlap.end - dst_overlap.start + 1)));
          CTT.remove(dst_overlap.src_addr);
        }
      }else{
        if(req.addr + req.size >= dst.addr + dst.len){
          CTT.put(dst_overlap.src_addr, new Destination(dst.addr, dst.len - 
                  (dst_overlap.end - req.addr + 1)));
        }else{
          CTT.put(dst_overlap.src_addr, new Destination(dst.addr, 
                  dst_overlap.start - dst.addr));
          CTT.put(dst_overlap.src_addr + dst_overlap.end - dst.addr + 1, 
                  new Destination(dst_overlap.end + 1, dst.addr + dst.len - 1 - dst_overlap.end));
        }
      }
    }

    writeData(req.addr, req.size, req.data);
    return null;
  }

  public char[] handle_read(Req req) {
    Overlap overlap = in_dst(req);
    char[] result = new char[req.size];
    if(overlap == null){
       return getData(req.addr, req.size);
    }else{
      if(req.addr < overlap.start){
        char[] result1 = getData(req.addr, overlap.start - req.addr);
        char[] result2 = getData(overlap.src_addr, overlap.end - overlap.start + 1);
        System.arraycopy(result1, 0, result, 0, result1.length);
        System.arraycopy(result2, 0, result, result1.length, result2.length);
        if(req.addr + req.size - 1 > overlap.end){
          char[] result3 = getData(overlap.end + 1, req.addr + req.size - overlap.end - 1);
          System.arraycopy(result3, 0, result, result1.length + result2.length, result3.length);
        }
        return result;
      }else{
        char[] result1 = getData(overlap.src_addr + overlap.start - CTT.get(overlap.src_addr).addr, 
                                  overlap.end - overlap.start + 1);
        if(req.addr + req.size - 1 > overlap.end){
          char[] result2 = getData(overlap.end + 1, req.addr + req.size - 1 - overlap.end);
          System.arraycopy(result1, 0, result, 0, result1.length);
          System.arraycopy(result2, 0, result, result1.length, result2.length);
          return result;
        }else{
          return result1;
        }
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

  public Overlap in_src(Req req){
    for(int src : CTT.keySet()){
      Destination dst = CTT.get(src);
      // check if in src
      if(req.addr <= src){
        if(req.addr + req.size > src){
          return new Overlap(src, Math.min(src + dst.len, req.addr + req.size), src);
        }
      }else if(req.addr > src && req.addr < src + dst.len){
        return new Overlap(req.addr, Math.min(src + dst.len, req.addr + req.size), src);
      }
    }
    return null;
  }

  public Overlap in_dst(Req req) {
    for(int src : CTT.keySet()){
      Destination dst = CTT.get(src);
      // check if in dst
      if(req.addr <= dst.addr){
        if(req.addr + req.size > dst.addr){
          return new Overlap(dst.addr, Math.min(dst.addr + dst.len - 1, req.addr + req.size - 1), src);
        }
      }else if(req.addr > dst.addr && req.addr < dst.addr + dst.len){
        return new Overlap(req.addr, Math.min(dst.addr + dst.len - 1, req.addr + req.size - 1), src);
      }
    }

    return null;
  }
}
