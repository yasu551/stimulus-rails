require "hotwire/importmap_helper"

module Hotwire
  class Engine < ::Rails::Engine
    initializer "hotwire.assets" do
      Rails.application.config.assets.precompile += %w(
        hotwire/manifest
        hotwire/importmap.json
        hotwire/loaders/preload_controllers.js
      )

      Rails.application.config.assets.configure { |env| env.context_class.class_eval { include Hotwire::ImportmapHelper } }
    end
  end
end
