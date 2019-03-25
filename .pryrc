T = -"\t"
N = -"\n"

class String
  def spt
    split(T)
  end

  def spn
    split(N)
  end

  def spr
    split(/\R/)
  end
end

def url_read(url)
  open(url).read
end
