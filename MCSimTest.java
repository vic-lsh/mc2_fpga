import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;

import org.junit.Before;
import org.junit.Test;

public class MCSimTest {
  MCSim mcsim;

  @Before
  public void setUp(){
    // abcdefghijklmnopqurstuvwxyz
    char[] data = new char[26];

    for(int i = 0; i < 26; i++){
      data[i] = (char) ('a' + i);
    }

    mcsim = new MCSim(data);

    // ab |cdefg| hijkl |cdefg| rstuvwxyz
    mcsim.add_entry(2, 12, 5);
  }

  @Test
  public void handle_read_test(){

    // ctt entry dst: |-----|
    // req:                   |----|
    Req req1 = new Req(true, 17, 4, null);
    char[] result1 = mcsim.handle_mem_req(req1);
    assertArrayEquals(new char[]{'r', 's', 't', 'u'}, result1);

    // ctt entry dst:      |-----|
    // req:           |--|
    Req req2 = new Req(true, 10, 2, null);
    char[] result2 = mcsim.handle_mem_req(req2);
    assertArrayEquals(new char[]{'k', 'l'}, result2);

    // ctt entry dst:   |-----|
    // req:          |-----|
    Req req3 = new Req(true, 10, 5, null);
    char[] result3 = mcsim.handle_mem_req(req3);
    assertArrayEquals(new char[]{'k', 'l', 'c', 'd', 'e'}, result3);

    // ctt entry dst:   |-----|
    // req:           |---------|
    Req req4 = new Req(true, 10, 9, null);
    char[] result4 = mcsim.handle_mem_req(req4);
    assertArrayEquals(new char[]{'k', 'l', 'c', 'd', 'e', 'f', 'g', 'r', 's'}, result4);

    // ctt entry dst; |-----|
    // req:            |---|
    Req req5 = new Req(true, 13, 3, null);
    char[] result5 = mcsim.handle_mem_req(req5);
    assertArrayEquals(new char[]{'d', 'e', 'f'}, result5);

    // ctt entry dst; |-----|
    // req:             |------|
    Req req6 = new Req(true, 13, 6, null);
    char[] result6 = mcsim.handle_mem_req(req6);
    assertArrayEquals(new char[]{'d', 'e', 'f', 'g', 'r', 's'}, result6);
  }

  @Test
  public void handle_write_test(){

    // ctt entry dst: |-----|
    // req:                   |----|
    Req req1 = new Req(false, 17, 4, new char[] {'a', 'a', 'a', 'a'});
    char[] result1 = mcsim.handle_mem_req(req1);
    assertEquals(mcsim.CTT.size(), 1);
    assertEquals(12, mcsim.CTT.get(2).addr);
    assertEquals(5, mcsim.CTT.get(2).len);

    // ctt entry dst:      |-----|
    // req:           |--|
    Req req2 = new Req(true, 10, 2, null);
    assertEquals(1, mcsim.CTT.size());
    assertEquals(12, mcsim.CTT.get(2).addr);
    assertEquals(5, mcsim.CTT.get(2).len);
 
    // ctt entry dst:   |-----|
    // req:          |-----|
    Req req3 = new Req(true, 10, 5, null);
    char[] result3 = mcsim.handle_mem_req(req3);
    assertEquals(1, mcsim.CTT.size());
    System.out.println(mcsim.CTT.keySet());
    assertEquals(15, mcsim.CTT.get(5).addr);
    assertEquals(2, mcsim.CTT.get(5).len);
/*
    // ctt entry dst:   |-----|
    // req:           |---------|
    Req req4 = new Req(true, 10, 9, null);
    char[] result4 = mcsim.handle_mem_req(req4);
    assertArrayEquals(new char[]{'k', 'l', 'c', 'd', 'e', 'f', 'g', 'r', 's'}, result4);

    // ctt entry dst; |-----|
    // req:            |---|
    Req req5 = new Req(true, 13, 3, null);
    char[] result5 = mcsim.handle_mem_req(req5);
    assertArrayEquals(new char[]{'d', 'e', 'f'}, result5);

    // ctt entry dst; |-----|
    // req:             |------|
    Req req6 = new Req(true, 13, 6, null);
    char[] result6 = mcsim.handle_mem_req(req6);
    assertArrayEquals(new char[]{'d', 'e', 'f', 'g', 'r', 's'}, result6);
    */
  }
}
