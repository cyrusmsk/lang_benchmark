struct LCG
  A = 1103515245_u32
  C =      12345_u32
  M = 1_u32 << 31

  def initialize(@seed : UInt32)
  end

  def next
    @seed = (A &* @seed &+ C) % M
  end
end

class LRU
  def initialize(@size : Int32)
    @a = Array(Tuple(UInt32, UInt32)).new
  end

  def get(key)
    @a.each_with_index do |x, i|
      next unless x[0] == key
      @a.delete_at(i)
      @a.push(x)
      return x[1]
    end
    return
  end

  def put(key, value)
    @a.each_with_index do |x, i|
      next unless x[0] == key
      @a.delete_at(i)
      @a.push({key, value})
      return
    end
    @a.delete_at(0) if @a.size >= @size
    @a.push({key, value})
  end
end

n = ARGV.size > 0 ? ARGV[0].to_i : 100
k = ARGV.size > 0 ? ARGV[1].to_i : 10

hit = 0
missed = 0
rng0 = LCG.new 0
rng1 = LCG.new 1
lru = LRU.new k
n.times do
  n0 = rng0.next % 100
  lru.put(n0, n0)
  n1 = rng1.next % 100
  if lru.get(n1)
    hit += 1
  else
    missed += 1
  end
end

puts hit
puts missed
