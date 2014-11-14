$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'markup_matcher'

Dir.glob(File.expand_path('../support/**/*.rb', __FILE__)).each {|file| require file}
