#
# A BrowserPlus service implements a persistent hash table.
#
# (c) Yahoo! Inc. 2007-2008
#

require 'pstore'
require 'digest/md5'
require 'uri'


class PersistentHashInstance
  # args contains 'url', 'data_dir', 'temp_dir'
  def initialize(args)
    uri = URI.parse(args['uri'])
    if uri.scheme == "file"
      domain = "localfile"
    else
      path_comps = uri.host.scan(/[^.]+/) # separate domain between dots ... yahoo.com into [yahoo com]
      path_comps.unshift("www") if path_comps.length == 2 # make 'yahoo.com' into 'www.yahoo.com'
      domain = path_comps.join(".")
    end
    dir = "#{args['data_dir']}/#{domain}"
    FileUtils.makedirs(dir)
    @pstore = PStore.new("#{dir}/#{Digest::MD5.hexdigest(uri.path)}.hst")
  end

  def get(bp, args)
    begin
      item = nil
      @pstore.transaction(true) do 
        item = @pstore[args['key']]
      end
      bp.complete(item)
    rescue Exception => err
      bp.error('FAIL', err.message)
    end
  end

  def set(bp, args)
    begin
      @pstore.transaction do 
        @pstore[args['key']] = args['value']
      end
      bp.complete(true)
    rescue Exception => err
      bp.error('FAIL', err.message)
    end
  end

  def keys(bp, args)
    begin
      keys = []
      @pstore.transaction(true) do 
        @pstore.roots.each do |key|
          keys << key
        end
      end
      bp.complete(keys)
    rescue Exception => err
      bp.error('FAIL', err.message)
    end
  end

  def clear(bp, args)
    begin
      @pstore.transaction do 
        keys = []
        @pstore.roots.each do |key|
          keys << key
        end

        keys.each do |key|
          @pstore.delete key
        end
      end
      bp.complete(true)
    rescue Exception => err
      bp.error('FAIL', err.message)
    end
  end

end

# TODO add a delete_file type method
# add a delete item method

rubyCoreletDefinition = {
  'class' => "PersistentHashInstance",
  'name' => "PStore",
  'major_version' => 1,
  'minor_version' => 0,  
  'micro_version' => 10,  
  'documentation' => 'Provides a persistent store.',
  'functions' =>
  [
    {
      'name' => 'get',
      'documentation' => "Retrieve an item from storage.",
      'arguments' =>
      [
        {
          'name' => 'key',
          'type' => 'string',
          'documentation' => 'The storage key.',
          'required' => true
        }
      ]
    },
   
    {
      'name' => 'set',
      'documentation' => "Store one item.",
      'arguments' =>
      [
        {
          'name' => 'key',
          'type' => 'string',
          'documentation' => 'The storage key.',
          'required' => true
        },
        {
          'name' => 'value',
          'type' => 'any',
          'documentation' => 'The value to store.',
          'required' => true
        }
      ]
    },
      
    {
      'name' => 'keys',
      'documentation' => "Return all the keys in the store.",
      'arguments' => []
    },

    {
      'name' => 'clear',
      'documentation' => "Remove all the items from the store.",
      'arguments' => []
    }

  ]
}

