import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;

import org.junit.Before;
import org.junit.Test;
// add multiple entries
// memory region can be both a source and a destination
// one source multiple destination
// one destination multiple sources

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

  // src_src
  // old entry: |-----|
  // new entry: |---|

  // cycle

  // how to handle one request mapping to multiple entires
  //    - multiple destinations
  //    - multiple sources
  //    - mixed sources and destinations

  // ways to optimize searching through CTT

  // cap number of d


  @Test
  public void dst_dst1(){
    // old entry: |-----|
    // new entry:          |----|
    mcsim.add_entry(7, 17, 4);
    assertEquals(2, mcsim.CTT.size());
    assertEquals(12, mcsim.CTT.get(2).addr);
    assertEquals(5, mcsim.CTT.get(2).len);
    assertEquals(17, mcsim.CTT.get(7).addr);
    assertEquals(4, mcsim.CTT.get(7).len);
  }

  @Test
  public void dst_dst2(){
    // old entry:      |-----|
    // new entry: |--|
    mcsim.add_entry(7, 10, 2);
    assertEquals(2, mcsim.CTT.size());
    assertEquals(12, mcsim.CTT.get(2).addr);
    assertEquals(5, mcsim.CTT.get(2).len);
    assertEquals(10, mcsim.CTT.get(7).addr);
    assertEquals(2, mcsim.CTT.get(7).len);
  }

  @Test
  public void dst_dst3(){
    // old entry:    |-----|
    // new entry: |-----|
    mcsim.add_entry(20, 10, 5);
    assertEquals(2, mcsim.CTT.size());
    assertEquals(15, mcsim.CTT.get(5).addr);
    assertEquals(5, mcsim.CTT.get(5).len);
    assertEquals(10, mcsim.CTT.get(20).addr);
    assertEquals(5, mcsim.CTT.get(20).len);
  }

  @Test
  public void dst_dst4(){
    // old entry:   |-----|
    // new entry: |---------|
    mcsim.add_entry(0, 10, 9);
    assertEquals(1, mcsim.CTT.size());
    assertEquals(10, mcsim.CTT.get(0).addr);
    assertEquals(9, mcsim.CTT.get(0).len);
  }

  @Test
  public void dst_dst5(){
    // old entry: |-----|
    // new entry:  |---|
    mcsim.add_entry(20, 13, 3);
    assertEquals(3, mcsim.CTT.size());
    assertEquals(12, mcsim.CTT.get(2).addr);
    assertEquals(1, mcsim.CTT.get(2).len);
    assertEquals(13, mcsim.CTT.get(20).addr);
    assertEquals(3, mcsim.CTT.get(20).len);
    assertEquals(16, mcsim.CTT.get(6).addr);
    assertEquals(1, mcsim.CTT.get(6).len);
  }

  @Test
  public void dst_dst6(){
    // old entry: |-----|
    // new entry:    |------|
    mcsim.add_entry(20, 13, 6);
    assertEquals(2, mcsim.CTT.size());
    assertEquals(12, mcsim.CTT.get(2).addr);
    assertEquals(1, mcsim.CTT.get(2).len);
    assertEquals(13, mcsim.CTT.get(20).addr);
    assertEquals(6, mcsim.CTT.get(20).len);
  }


  @Test
  public void dst_src1(){
    // old entry dst: |-----|
    // new entry src:          |----|
    mcsim.add_entry(18, 22, 4);
    assertEquals(2, mcsim.CTT.size());
    assertEquals(12, mcsim.CTT.get(2).addr);
    assertEquals(5, mcsim.CTT.get(2).len);
    assertEquals(22, mcsim.CTT.get(18).addr);
    assertEquals(4, mcsim.CTT.get(18).len);
  }

  @Test
  public void dst_src2(){
    // old entry dst:      |-----|
    // new entry src: |--|
    mcsim.add_entry(10, 20, 2);
    assertEquals(2, mcsim.CTT.size());
    assertEquals(12, mcsim.CTT.get(2).addr);
    assertEquals(5, mcsim.CTT.get(2).len);
    assertEquals(20, mcsim.CTT.get(10).addr);
    assertEquals(2, mcsim.CTT.get(10).len);
  }

  @Test
  public void dst_src3(){
    // old entry dst:    |-----|
    // new entry src: |-----|
    mcsim.add_entry(10, 20, 5);
    assertEquals(3, mcsim.CTT.size());
    assertEquals(12, mcsim.CTT.get(2).addr);
    assertEquals(5, mcsim.CTT.get(2).len);
    assertEquals(20, mcsim.CTT.get(10).addr);
    assertEquals(2, mcsim.CTT.get(10).len);
    assertEquals(22, mcsim.CTT.get(2).addr);
    assertEquals(3, mcsim.CTT.get(2).len);
  }
  @Test
  public void dst_src4(){
    // old entry dst:  |-----|
    // new entry src: |---------|
    mcsim.add_entry(20, 10, 9);
    assertEquals(4, mcsim.CTT.size());
    assertEquals(12, mcsim.CTT.get(2).addr);
    assertEquals(5, mcsim.CTT.get(2).len);
    assertEquals(20, mcsim.CTT.get(10).addr);
    assertEquals(2, mcsim.CTT.get(10).len);
    assertEquals(22, mcsim.CTT.get(2).addr);
    assertEquals(5, mcsim.CTT.get(2).len);
    assertEquals(27, mcsim.CTT.get(17).addr);
    assertEquals(2, mcsim.CTT.get(17).len);
  }

  @Test
  public void dst_src5(){
    // old entry dst: |-----|
    // new entry src:  |---|
    mcsim.add_entry(13, 20, 3);
    assertEquals(2, mcsim.CTT.size());
    assertEquals(12, mcsim.CTT.get(2).addr);
    assertEquals(5, mcsim.CTT.get(2).len);
    assertEquals(20, mcsim.CTT.get(3).addr);
    assertEquals(3, mcsim.CTT.get(3).len);
  }

  @Test
  public void dst_src6(){
    // old entry dst: |-----|
    // new entry src:    |------|

    mcsim.add_entry(14, 20, 6);
    assertEquals(3, mcsim.CTT.size());
    assertEquals(12, mcsim.CTT.get(2).addr);
    assertEquals(5, mcsim.CTT.get(2).len);
    assertEquals(20, mcsim.CTT.get(4).addr);
    assertEquals(3, mcsim.CTT.get(4).len);
    assertEquals(23, mcsim.CTT.get(17).addr);
    assertEquals(3, mcsim.CTT.get(17).len);
  }

}
