public class Req {
  boolean is_read;
  int addr; // must be multiples of 64
  int size; // assume max 64
  char[] data;

  public Req (boolean is_read, int addr, int size, char[] data){
    this.is_read = is_read;
    this.addr = addr;
    this.size = size;
    this.data = data;
  }
}
