package tests;
import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import org.junit.Before;
import org.junit.Test;

import main.*;

public class MCSimTest_CTT_Entries {
  MCSim mcsim;

  @Before
  public void setUp(){
    // abcdefghijklmnopqrstuvwxyz
    char[] data = new char[30];

    for(int i = 0; i < 30; i++){
      if(i < 26){
        data[i] = (char) ('a' + i);
      }else{
        data[i] = 'a';
      }
    }

    mcsim = new MCSim(data);

    // ab |cdefg| hijkl |cdefg| rstuvwxyz
    mcsim.add_entry(2, 12, 5);
  }

  // how to handle one request mapping to multiple entires
  //    - multiple destinations
  //    - multiple sources
  //    - mixed sources and destinations


  @Test
  public void dst_dst1(){
    // old entry: |-----|
    // new entry:          |----|
    mcsim.add_entry(7, 17, 4);
    assertEquals(2, mcsim.CTT.size);
    assertTrue(mcsim.CTT.containsEntry(2, 12, 5));
    assertTrue(mcsim.CTT.containsEntry(7, 17, 4));
    //assertEquals(12, mcsim.CTT.get(2).addr);
    //assertEquals(5, mcsim.CTT.get(2).len);
    //assertEquals(17, mcsim.CTT.get(7).addr);
    //assertEquals(4, mcsim.CTT.get(7).len);
  }

  @Test
  public void dst_dst2(){
    // old entry:      |-----|
    // new entry: |--|
    mcsim.add_entry(7, 10, 2);
    assertEquals(2, mcsim.CTT.size);
    assertTrue(mcsim.CTT.containsEntry(2, 12, 5));
    assertTrue(mcsim.CTT.containsEntry(7, 10, 2));
    //assertEquals(12, mcsim.CTT.get(2).addr);
    //assertEquals(5, mcsim.CTT.get(2).len);
    //assertEquals(10, mcsim.CTT.get(7).addr);
    //assertEquals(2, mcsim.CTT.get(7).len);
  }

  @Test
  public void dst_dst3(){
    // old entry:    |-----|
    // new entry: |-----|
    mcsim.add_entry(20, 10, 5);
    assertEquals(2, mcsim.CTT.size);
    assertTrue(mcsim.CTT.containsEntry(5, 15, 2));
    assertTrue(mcsim.CTT.containsEntry(20, 10, 5));
    //assertEquals(15, mcsim.CTT.get(5).addr);
    //assertEquals(5, mcsim.CTT.get(5).len);
    //assertEquals(10, mcsim.CTT.get(20).addr);
    //assertEquals(5, mcsim.CTT.get(20).len);
  }

  @Test
  public void dst_dst4(){
    // old entry:   |-----|
    // new entry: |---------|
    mcsim.add_entry(0, 10, 9);
    assertEquals(1, mcsim.CTT.size);
    assertTrue(mcsim.CTT.containsEntry(0, 10, 9));
    //assertEquals(10, mcsim.CTT.get(0).addr);
    //assertEquals(9, mcsim.CTT.get(0).len);
  }

  @Test
  public void dst_dst5(){
    // old entry: |-----|
    // new entry:  |---|
    mcsim.add_entry(20, 13, 3);
    assertEquals(3, mcsim.CTT.size);
    assertTrue(mcsim.CTT.containsEntry(2, 12, 1));
    assertTrue(mcsim.CTT.containsEntry(20, 13, 3));
    assertTrue(mcsim.CTT.containsEntry(6, 16, 1));
    //assertEquals(12, mcsim.CTT.get(2).addr);
    //assertEquals(1, mcsim.CTT.get(2).len);
    //assertEquals(13, mcsim.CTT.get(20).addr);
    //assertEquals(3, mcsim.CTT.get(20).len);
    //assertEquals(16, mcsim.CTT.get(6).addr);
    //assertEquals(1, mcsim.CTT.get(6).len);
  }

  @Test
  public void dst_dst6(){
    // old entry: |-----|
    // new entry:    |------|
    mcsim.add_entry(20, 13, 6);
    assertEquals(2, mcsim.CTT.size);
    assertTrue(mcsim.CTT.containsEntry(2, 12, 1));
    assertTrue(mcsim.CTT.containsEntry(20, 13, 6));
    //assertEquals(12, mcsim.CTT.get(2).addr);
    //assertEquals(1, mcsim.CTT.get(2).len);
    //assertEquals(13, mcsim.CTT.get(20).addr);
    //assertEquals(6, mcsim.CTT.get(20).len);
  }


  @Test
  public void dst_src1(){
    // old entry dst: |-----|
    // new entry src:          |----|
    mcsim.add_entry(18, 22, 4);
    assertEquals(2, mcsim.CTT.size);
    assertTrue(mcsim.CTT.containsEntry(2, 12, 5));
    assertTrue(mcsim.CTT.containsEntry(18, 22, 4));
    //assertEquals(12, mcsim.CTT.get(2).addr);
    //assertEquals(5, mcsim.CTT.get(2).len);
    //assertEquals(22, mcsim.CTT.get(18).addr);
    //assertEquals(4, mcsim.CTT.get(18).len);
  }

  @Test
  public void dst_src2(){
    // old entry dst:      |-----|
    // new entry src: |--|
    mcsim.add_entry(10, 20, 2);
    assertEquals(2, mcsim.CTT.size);
    assertTrue(mcsim.CTT.containsEntry(2, 12, 5));
    assertTrue(mcsim.CTT.containsEntry(10, 20, 2));
    //assertEquals(12, mcsim.CTT.get(2).addr);
    //assertEquals(5, mcsim.CTT.get(2).len);
    //assertEquals(20, mcsim.CTT.get(10).addr);
    //assertEquals(2, mcsim.CTT.get(10).len);
  }

  @Test
  public void dst_src3(){
    // old entry dst:    |-----|
    // new entry src: |-----|
    mcsim.add_entry(10, 20, 5);
    assertEquals(3, mcsim.CTT.size);
    assertTrue(mcsim.CTT.containsEntry(2, 12, 5));
    assertTrue(mcsim.CTT.containsEntry(10, 20, 2));
    assertTrue(mcsim.CTT.containsEntry(2, 22, 3));
    //assertEquals(12, mcsim.CTT.get(2).addr);
    //assertEquals(5, mcsim.CTT.get(2).len);
    //assertEquals(20, mcsim.CTT.get(10).addr);
    //assertEquals(2, mcsim.CTT.get(10).len);
    //assertEquals(22, mcsim.CTT.get(2).addr);
    //assertEquals(3, mcsim.CTT.get(2).len);
  }
  @Test
  public void dst_src4(){
    // old entry dst:  |-----|
    // new entry src: |---------|
    mcsim.add_entry(10, 20, 9);
    assertEquals(4, mcsim.CTT.size);
    assertTrue(mcsim.CTT.containsEntry(2, 12, 5));
    assertTrue(mcsim.CTT.containsEntry(10, 20, 2));
    assertTrue(mcsim.CTT.containsEntry(2, 22, 5));
    assertTrue(mcsim.CTT.containsEntry(17, 27, 2));
    //assertEquals(12, mcsim.CTT.get(2).addr);
    //assertEquals(5, mcsim.CTT.get(2).len);
    //assertEquals(20, mcsim.CTT.get(10).addr);
    //assertEquals(2, mcsim.CTT.get(10).len);
    //assertEquals(22, mcsim.CTT.get(2).addr);
    //assertEquals(5, mcsim.CTT.get(2).len);
    //assertEquals(27, mcsim.CTT.get(17).addr);
    //assertEquals(2, mcsim.CTT.get(17).len);
  }

  @Test
  public void dst_src5(){
    // old entry dst: |-----|
    // new entry src:  |---|
    mcsim.add_entry(13, 20, 3);
    assertEquals(2, mcsim.CTT.size);
    assertTrue(mcsim.CTT.containsEntry(2, 12, 5));
    assertTrue(mcsim.CTT.containsEntry(3, 20, 3));
    //assertEquals(12, mcsim.CTT.get(2).addr);
    //assertEquals(5, mcsim.CTT.get(2).len);
    //assertEquals(20, mcsim.CTT.get(3).addr);
    //assertEquals(3, mcsim.CTT.get(3).len);
  }

  @Test
  public void dst_src6(){
    // old entry dst: |-----|
    // new entry src:    |------|

    mcsim.add_entry(14, 20, 6);
    assertEquals(3, mcsim.CTT.size);
    assertTrue(mcsim.CTT.containsEntry(2, 12, 5));
    assertTrue(mcsim.CTT.containsEntry(4, 20, 3));
    assertTrue(mcsim.CTT.containsEntry(17, 23, 3));
    //assertEquals(12, mcsim.CTT.get(2).addr);
    //assertEquals(5, mcsim.CTT.get(2).len);
    //assertEquals(20, mcsim.CTT.get(4).addr);
    //assertEquals(3, mcsim.CTT.get(4).len);
    //assertEquals(23, mcsim.CTT.get(17).addr);
    //assertEquals(3, mcsim.CTT.get(17).len);
  }

}
