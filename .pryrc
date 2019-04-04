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

class Array
  def jot
    join(T)
  end
end

def url_read(url)
  require 'open-uri' unless defined? OpenURI
  open(url).read
end

def url_parse(url)
  require 'nokogiri' unless defined? Nokogiri
  Nokogiri::HTML.parse(url_read(url))
end
