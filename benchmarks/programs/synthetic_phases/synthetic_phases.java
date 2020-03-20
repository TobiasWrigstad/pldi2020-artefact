import java.util.Random;

public class synthetic_phases {
  static class Pair {
    public double x;
    public double y;

    public static Pair new_pair() {
      var p = new Pair();
      p.x = 0.4;
      p.y = 0.4;
      return p;
    }
  }

  static Pair arr[];
  static Pair gc_arr[];
  static final int cache_line_size = 64;
  static final int n_cache_line = 1*1000*1000;
  static final int object_size = 32;
  static final int N = cache_line_size * n_cache_line / object_size;
  static final int loop = 200*1;
  static final int phases = 3;
  static final int per_loop = 1000*800;

  static void f(int i) {
    arr[i].x = (arr[i].x + 1) / 3.0;
    arr[i].y = (arr[i].y + 1) / 3.0;
  }

  public static void main(String[] args) {
    arr = new Pair[N];
    gc_arr = new Pair[N];
    var gc_index = 0;
    for (int i = 0; i < N; ++i) {
      arr[i] = Pair.new_pair();
    }
    int cache_line_index = 0;
    int ops = 0;
    for (int phase_i = 0; phase_i < phases; ++phase_i) {
      for (int l = 0; l < loop; ++l) {
        var rand = new Random(phase_i);
        for (int i = 0; i < per_loop; ++i) {
          cache_line_index = rand.nextInt(n_cache_line);
          var index = cache_line_index * cache_line_size / object_size
            + rand.nextInt(cache_line_size / object_size);
          f(index);
          ops++;
          if (ops % 10 == 0) {
            gc_arr[(gc_index++) % N] = Pair.new_pair();
          }
        }
      }
    }
  }
}
