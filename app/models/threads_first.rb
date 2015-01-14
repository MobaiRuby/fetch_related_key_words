# require 'net/http'
#
# pages = %w( www.taobao.com
#             www.zhihu.com
#             www.baidu.com
#           )
#
# threads = []
#
# for page in pages
#   threads << Thread.new(page) { |myPage|
#
#     h = Net::HTTP.new(myPage, 80)
#     puts "Fetching: #{myPage}"
#     resp, data = h.get('/', nil )
#     puts "Got #{myPage}:  #{resp.message}"
#     puts "data---->#{data}"
#   }
# end
#
# threads.each { |aThread|  aThread.join }

count = 0
arr = []

10.times do |i|
  arr[i] = Thread.new {
    sleep(rand(0)/10.0)
    Thread.current["mycount"] = count
    count += 1
  }
end

arr.each {|t| t.join; print t["mycount"], ", " }
puts "count = #{count}"