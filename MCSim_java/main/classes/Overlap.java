package main.classes;

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
