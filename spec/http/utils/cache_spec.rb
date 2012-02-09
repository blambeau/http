require 'spec_helper'
module Http::Utils
  class Cache
    public :warmup
  end
  describe Cache do

    describe "warmup" do

      it 'supports url/body pairs' do
        cache = Cache.new({"/somewhere" => "Body"})
        cache.get("/somewhere").to_a.should eq([ 200, {}, "Body" ])
      end

      it 'supports specifying the verb' do
        cache = Cache.new({[:post, "/somewhere"] => "Body"})
        cache.post("/somewhere").to_a.should eq([ 200, {}, "Body" ])
        cache.get("/somewhere").status.should eq(404)
      end

      it 'supports specifying the response as an Array' do
        cache = Cache.new({"/somewhere" => [301, {}, ""]})
        cache.get("/somewhere").to_a.should eq([ 301, {}, "" ])
      end

      it 'supports specifying the response as a Response object' do
        res = Http::Response.new.tap do |r|
          r.status  = 301
          r.headers = {}
          r.body    = ""
        end
        cache = Cache.new({"/somewhere" => res})
        cache.get("/somewhere").should eq(res)
      end

    end

    describe "request" do

      before{ @calls ||= 0 }

      def request(*args)
        @calls += 1
      end

      let(:cache){ Cache.new(self, "/hello" => "World") }

      it 'does not delegate if in cache' do
        cache.get("/hello")
        @calls.should eq(0)
      end

      it 'put in cache after first call' do
        cache.get("/noincacheinitially")
        @calls.should eq(1)
        cache.get("/noincacheinitially")
        @calls.should eq(1)
      end

      it 'does not put in cache if :nocache' do
        cache.get("/noincacheinitially", :nocache => true)
        @calls.should eq(1)
        cache.get("/noincacheinitially")
        @calls.should eq(2)
      end

    end

  end
end
