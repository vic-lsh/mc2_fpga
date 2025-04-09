// assuming each req can only overlap with one CTT entry
// can either break up req or change code to handle one req overlapping with multiple
// CTT entries
public class MCSim {

  public class Destination {
    long addr;
    long len;
  }

  public class Req {
    bool is_read;
    long addr; // must be multiples of 64
    long size; // assume max 64
    String data;
  }

  public class Overlap {
    long start;
    // inclusive
    long end;
    long src_addr;
  }

  public char[] data;
  // src -> (dst, len)
  public HashMap<Long, Destination> CTT;

  public MCSim (String data){
    CTT = new HashMap<>();
    this.data = data;
  }

  public void mc_lazy(long src, long dst, long len) {
    for(int i = 0; i < len; i++){
      data[dst + i] = data[src + i];
    }

    CTT.remove(src);
  }
  
  // return void if write, read data if read request
  public String handle_mem_req(MCSim sim, Req req) {
    if (req.is_read) {
      return handle_read(req);
    } else {
      return handle_write(req);
    }
  }

  public String handle_write(Req req) {
    // can req be part of src and dst?
    Overlap src_overlap = in_src(req);
    Overlap dst_overlap = in_dst(req);
    
    while(src_overlap != null){
      // wait for copy
      //this.wait();
      src_overlap = in_src(req);
    }

    if(in_dst != null){
      Destination dst = CTT.get(dst_overlap.src_addr);
      if(req.addr <= dst_overlap.start){
        if(req.addr + req.size >= dst.addr + dst.len){
          CTT.remove(dst_overlap.src);
        }else{
          CTT.put(dst_overlap.src_addr + dst_overlap.end - dst_overlap.start + 1,
              new Destination(req.addr + req.size, 
              dst.len - (dst_overlap.end - dst_overlap.start + 1)));
          CTT.remove(dst_overlap.src);
        }
      }else{
        if(req.addr + req.size >= dst.addr + dst.len){
          CTT.put(dst_over.src_addr, new Destination(dst.addr, dst.len - 
                  (overlap.end - req.addr + 1)));
        }else{
          CTT.put(dst_overlap.src_addr, new Destination(dst.addr, 
                  dst.addr - overlap.start));
          CTT.put(dst_overlap.src_addr + overlap.end - dst.addr + 1, 
                  new Destination(overlap.end + 1, dst.addr + dst.len - 1 - overlap.end));
        }
      }
    }

    return writeData(req.addr, req.size, req.data);
  }

  public String handle_read(Req req) {
    Overlap overlap = in_dst(req);
    String result = "";
    long addr;
    if(overlap == null){
       return getData(req.addr, req.addr + req.size - 1);
    }else{
      if(req.addr < overlap.start){
        result = getData(req.addr, overlap.start - 1);
        result += getData(overlap.src, overlap.src + overlap.end - overlap.start);
        if(req.addr + req.size - 1 > overlap.end){
          result += getData(overlap.end + 1, req.addr + req.size - 1);
        }
        return result;
      }
    }
  }

  public String getData(long start, long end){
    String result = "";
    for(int i = start; i <= end; i++){
      result += data[i];
    }
    return result;
  }

  public String writeData(long addr, long len, char[] new_data){
    for(int i = 0; i < len; i++){
      data[addr + i] = new_data[i];
    }
  }

  public Overlap in_src(Req req){
    for(long src : ctt.keySet()){
      Destination dst = ctt.get(src);
      // check if in src
      if(req.addr <= src){
        if(req.addr + req.size > src){
          return new Overlap(src, min(src + dst.len, req.addr + req.size), src);
        }
      }else if(req.addr > src && req.addr < src + dst.len){
        return new Overlap(req.addr, min(src + dst.len, req.addr + req.size), src);
      }
    }
    return null;
  }

  public Overlap in_dst(Req req) {
    bool in_dst;
    for(long src : ctt.keySet()){
      Destination dst = ctt.get(src);
      // check if in dst
      if(req.addr <= dst.addr){
        if(req.addr + req.size > dst.addr){
          return new Overlap(dst, min(dst.addr + dst.len, req.addr + req.size), src);
        }
      }else if(req.addr > dst.addr && req.addr < dst.addr + dst.len){
        return new Overlap(req.addr, min(dst.addr + dst.len, req.addr + req.size), src);
      }
    }

    return null;
  }

  public static void main(String[] args) {
  }
}
