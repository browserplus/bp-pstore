#!/usr/bin/env ruby

require File.join(File.dirname(File.dirname(File.expand_path(__FILE__))),
                  'external/dist/share/service_testing/bp_service_runner.rb')
require 'uri'
require 'test/unit'
require 'open-uri'
require 'rbconfig'
include Config
require 'webrick'
include WEBrick

class TestPStore < Test::Unit::TestCase
  def setup
    subdir = 'build/PStore'
    if ENV.key?('BP_OUTPUT_DIR')
      subdir = ENV['BP_OUTPUT_DIR']
    end
    @cwd = File.dirname(File.expand_path(__FILE__))
    @service = File.join(@cwd, "../#{subdir}")
    nulldevice = "/dev/null"
    if CONFIG['arch'] =~ /mswin|mingw/
      nulldevice = "NUL"
    end
    @server = HTTPServer.new(:Port => 0,
                             :Logger => WEBrick::Log.new(nulldevice),
                             :AccessLog => [nil],
                             :BindAddress => "127.0.0.1")
    @urlLocal = "http://localhost:#{@server[:Port]}/"
    @urlFake = "http://www.yahoo.com/fake.html"
  end
  
  def teardown
  end

  def test_load_service
    # NEEDSWORK!!!  Need to figure out how to host RubyInterpreter to get these tests running
    #BrowserPlus.run(@service) { |s|
    #}
  end

#  def test_Pstore
#    # NEEDSWORK!!!  Need to figure out how to host RubyInterpreter to get these tests running
#    BrowserPlus.Service::new(@service) { |s|
#      i = s.allocate(@urlLocal)
#      # For all .json in cases.
#      Dir.glob(File.join(@cwd, "cases", "*.json")).each do |f|
#        json = JSON.parse(File.read(f))
#        k =  json["keys"].size() - 1
#        keys = json["keys"]
#        values = json["values"]
#        assert_equal(keys.size(), values.size())
#
#        # Set.
#        for n in 0..k
#          i.set({ 'key' => json["keys"][n], 'value' => (json["values"])[n] })
#        end
#
#        # Get.
#        for i in 0..k
#          want = values[i]
#          got = i.get({ 'key' => keys[i] })
#          assert_equal(want, got)
#        end
#
#        # Keys.
#        want = keys.size()
#        got = i.keys.size()
#        assert_equal(want, got)
#
#        # Clear.
#        i.clear()
#        want = 0
#        got = i.keys().size()
#        assert_equal(want, got)
#      end
#      s.shutdown()
#    }
#  end
end
