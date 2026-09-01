module Shopkit
  class Engine < ::Rails::Engine
    isolate_namespace Shopkit

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
