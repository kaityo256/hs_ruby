$MAX=8 # Number of bits

class Fixnum
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

def make_array(l,n)
  r = []
  a = [1] * l + [0] * ($MAX-l)
  n.times do
    r.push a.shuffle.join("").to_i(2)
  end
  r
end

def check_minimal(t,level,e)
  v = t
  while v!=0
    t2 = v & -v
    t3 = t ^ t2
    if e.slice(0..(level-1)).collect{|ei| (ei & t3)!=0}.inject(:&)
      return false
    end
    v = v ^ t2
  end
  return true
end

def search(level, t, e, r)
  return if !check_minimal(t,level,e)
  if level == e.size
    r.push t
    return
  end
  if (t & e[level]) !=0
    search(level+1,t,e,r)
    return
  end
  v = e[level]
  while v!=0
    t2 = v & -v
    search(level + 1, t | t2, e,r)
    v = v ^ t2
  end
end

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
