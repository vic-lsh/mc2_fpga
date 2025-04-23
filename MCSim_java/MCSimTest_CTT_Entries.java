import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;

import org.junit.Before;
import org.junit.Test;
// add multiple entries
// memory region can be both a source and a destination
// one source multiple destination
// one destination multiple sources

// does timing need to be accounted for? Will there be time stamps on the requests
// and can you receive a request that was sent before the request that was just processed
public class MCSimTest_CTT_Entries {
  MCSim mcsim;

  @Before
  public void setUp(){
    // abcdefghijklmnopqrstuvwxyz
    char[] data = new char[26];

    for(int i = 0; i < 26; i++){
      data[i] = (char) ('a' + i);
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
  public void src_dst1(){
    // old entry src:    |-----|
    // new entry dst: |-----|
    mcsim.add_entry(20, 0, 5);
    assertEquals(3, mcsim.CTT.size());
    assertEquals(0, mcsim.CTT.get(20).addr);
    assertEquals(5, mcsim.CTT.get(20).len);
    assertEquals(12, mcsim.CTT.get(22).addr);
    assertEquals(3, mcsim.CTT.get(22).len);
    assertEquals(15, mcsim.CTT.get(5).addr);
    assertEquals(2, mcsim.CTT.get(5).len);
  }

  public void src_dst1(){
    // old entry src:    |-----|
    // new entry dst: |-----|
    mcsim.add_entry(20, 0, 5);
    assertEquals(3, mcsim.CTT.size());
    assertEquals(0, mcsim.CTT.get(20).addr);
    assertEquals(5, mcsim.CTT.get(20).len);
    assertEquals(12, mcsim.CTT.get(22).addr);
    assertEquals(3, mcsim.CTT.get(22).len);
    assertEquals(15, mcsim.CTT.get(5).addr);
    assertEquals(2, mcsim.CTT.get(5).len);
  }

}
