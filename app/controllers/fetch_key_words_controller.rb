# encoding: utf-8
require 'socket'

class FetchKeyWordsController < ApplicationController

  def init_page
    @title = '输入要搜索的关键字'
    @related_word = RelatedWord.new
  end

  def fetch

    res = []

    res << batch_socket(related_words_params)

    res.each do |key_word|

      count = RelatedWord.all.count

      while count <= 100000 do

        arr = []

        5.times do |i|
          arr[i] = Thread.new {
            sleep(rand(0)/10.0)
            res << batch_socket(key_word)
          }
        end

        arr.each {|t| t.join}

      end

    end

    @body = res

    render :result

  end

  def result
      @title = '搜索结果'
  end

  private

  def related_words_params
    params.require(:related_word).permit(:title)
  end

  def batch_socket(key_work)
    host = 'www.baidu.com'     # The web server
    port = 80                           # Default HTTP port
    path = "/s?ie=utf-8&f=3&rsv_bp=1&rsv_idx=1&tn=baidu&wd=#{key_work}&rsv_pq=cd58aea80000cf75&rsv_t=d1ea6IwdbXZZGlevYp991s3fSKyXiuAGnCKKYYNf%2BPrhlChs3EKNUD9KAz4&rsv_enter=1&rsv_sug3=18&rsv_sug4=769&rsv_sug6=6&rsv_sug1=8&oq=jiudian&rsv_sug2=0&rsp=1&inputT=7578"                 # The file we want

    request = "GET #{path} HTTP/1.0\r\n\r\n"

    socket = TCPSocket.open(host,port)                          # Connect to server
    socket.print(request)                                       # Send request
    response = socket.read.force_encoding("UTF-8")              # Read complete response
    socket.close                                                #Close the socket

    @headers, body = response.split("\r\n\r\n", 2)

    th = body.scan(/<table cellpadding="0">.*<\/table>/)[0].to_s.match(/<a\s*.*>.*<\/a>/).to_s if !body.nil?

    tags = []

    th.split(/<\/a>/).each do |td|
      res = td.split(/<a\s*.*>/)
      if res.length == 2
        tags << res[1]
      end
    end if !th.nil?

    tags.each do |tag|
      if(RelatedWord.create(title: tag))
        @status = 'OK!'
      end
    end
  end

end
