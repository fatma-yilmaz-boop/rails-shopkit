require "shopkit/version"
require "shopkit/engine"

module Shopkit
  class Error < StandardError; end

  mattr_accessor :currency, default: "USD"
  mattr_accessor :tax_rate, default: 0.0

  def self.configure
    yield self
  end
end
