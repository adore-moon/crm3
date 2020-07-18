import com.sss.crm.commons.domain.ReturnObject;
import com.sss.crm.workbench.service.TranService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.Transaction;

import java.util.*;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:conf/applicationContext.xml"})
public class llll {

    @Autowired
    private ReturnObject returnObject;
    @Autowired
    private TranService tranService;
    @Autowired
    private JedisPool jedisPool;
    @Test
    public void tt(){
        String s1 = new String("aaa");
        String s2 = new String("aaa");
        System.out.println(s1 == s2);           // false
        String s3 = s1.intern();
        String s4 = s2.intern();
        System.out.println(s3 == s4);           // true
    }

    @Test
    public void rr(){
        String s = new String("1");
        String s1 = new String("1");
        System.out.println(s.equals(s1));

        HashSet hashSet = new HashSet();
        hashSet.add(s);
        hashSet.add(s1);
        System.out.println(hashSet.size());
        Class<Integer> integerClass = int.class;
        integerClass.isInstance(s);
    }

    @Test
    public void ee(){

        Jedis jedis = jedisPool.getResource();
        System.out.println(jedis.ping());
        Set<String> keys = jedis.keys("*");
        for (String key : keys) {
            System.out.println(key);
        }
        List<String> lisi = jedis.lrange("lisi", 0, -1);
        System.out.println(lisi);
        System.out.println(jedis.llen("lisi"));
        System.out.println(jedis.ltrim("lisi", 0, -1));
        System.out.println(jedis.keys("*"));
        jedis.exists("lsii");
        jedis.type("lisi");
        //list
        jedis.lpush("k","k1");
        jedis.llen("k");
        jedis.lrange("k",0,-1);
        jedis.rpush("q","q1");
        jedis.lpop("k");
        jedis.rpop("q");
        jedis.lrem("k",1,"k1");
        jedis.ltrim("k",0,2);
        jedis.sadd("myset","aa","bb");
        jedis.scard("myset");
        jedis.smembers("k");
        jedis.smove("key","key2","aa");
        jedis.srem("k","value");
        jedis.spop("k");
        jedis.zadd("zset",102,"value");
        jedis.zcard("zset");
        jedis.zrange("k",0,-1);
        jedis.zrevrange("k",0,-1);
        jedis.zscore("k","vale");
        jedis.zrangeByScore("k",1,2);
        jedis.zrem("k","val");
        jedis.zcount("k",1,2);
        jedis.zrank("k","val");
        //hash
        jedis.hset("map","aa","11");
        Map<String,String> map = new HashMap<>();
        map.put("b","b");
        map.put("c","c");
        jedis.hmset("map",map);
        jedis.hkeys("map");





    }

    @Test
    public void ww(){
        Jedis jedis = jedisPool.getResource();
        jedis.hset("map","aa","11");
        Map<String,String> map = new HashMap<>();
        map.put("b","b");
        map.put("c","c");
        jedis.hmset("map",map);
        System.out.println(jedis.hkeys("map"));

        System.out.println(jedis.hvals("map"));

        System.out.println(jedis.hlen("map"));

        System.out.println(jedis.hgetAll("map"));

        System.out.println(jedis.hexists("map", "kk"));

        System.out.println(jedis.hmget("map", "b", "c"));

        System.out.println(jedis.hget("map", "aa"));

        System.out.println(jedis.hdel("map", "c"));


    }

    @Test
    public void tran(){
        //事务
        Jedis jedis = jedisPool.getResource();
        Transaction multi = jedis.multi();
        multi.set("mm","mm");
        multi.zadd("foo",1,"bar");
        multi.exec();
        System.out.println(jedis.get("mm"));
    }

}
