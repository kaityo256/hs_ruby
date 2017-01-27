$MAX=8 # Number of bits

class Integer
  def to_b s = ""
    v = self
    $MAX.times{|i|
      s = (v&1).to_s + s
      v = v >> 1
    }
    s
  end

  def to_a
    s = "["
    v = self
    $MAX.times do |i|
      if (1<<($MAX-i-1)) & v !=0
        s = s + ($MAX-i).to_s  + ","
      end
    end
    s.chop + "]"
  end
end

class Array
  def show
    self.each do |ri|
      puts ri.to_b
    end
  end
end

def make_array(l,n)
  r = []
  a = [1] * l + [0] * ($MAX-l)
  n.times do
    r.push a.shuffle.join("").to_i(2)
  end
  r
end

def check_minimal(t,k,e)
  v = t
  while v!=0
    t2 = v & -v
    t3 = t ^ t2
    if e.slice(0..(k-1)).collect{|ei| (ei & t3)!=0}.inject(:&)
      return false
    end
    v = v ^ t2
  end
  return true
end

def search(k, t, e, r)
  return if !check_minimal(t,k,e)
  if k == e.size
    r.push t
    return
  end
  if (t & e[k]) !=0
    search(k+1,t,e,r)
    return
  end
  v = e[k]
  while v!=0
    t2 = v & -v
    search(k + 1, t | t2, e,r)
    v = v ^ t2
  end
end

def test
  srand(1)
  e = make_array(4,10)
  puts "input"
  e.each do |ei|
    puts ei.to_b + " : " + ei.to_a 
  end
  r = []
  puts "hitting sets"
  search(0,0,e,r)
  r.each do |ri|
    puts ri.to_b + " : " + ri.to_a
  end
end

def from_stdin
  e = []
  while line=gets
    $MAX = line.length  if $MAX < line.length
    e.push line.to_i(2)
  end
  r = []
  search(0,0,e,r)
  r.show
end

test
