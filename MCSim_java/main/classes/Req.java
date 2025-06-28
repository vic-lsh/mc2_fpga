package main.classes;

public class Req {
  public boolean is_read;
  public int addr; // must be multiples of 64
  public int size; // assume max 64
  public char[] data;

  public Req (boolean is_read, int addr, int size, char[] data){
    this.is_read = is_read;
    this.addr = addr;
    this.size = size;
    this.data = data;
  }
}
