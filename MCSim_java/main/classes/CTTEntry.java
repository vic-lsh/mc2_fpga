package main.classes;

public class CTTEntry {
  public int src;
  public Destination dst;
  
  public CTTEntry(int src, int dst, int len){
    this.src = src;
    this.dst = new Destination(dst, len);
  }

  @Override
  public String toString(){
    return "[src=" + src + "-" + (src + dst.len - 1) + ", dst=" + dst.addr + "-" + (dst.addr + dst.len - 1) + ", len=" + dst.len + "]";
  }
}
