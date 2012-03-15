module ActiveXlsx
  module Generators
    class InstallGenerator < Rails::Generators::Base
      
      source_root File.expand_path("../../templates", __FILE__)
      
      desc "Creates activexlsx initializer"
      
      def create_initializer
        template "active_xlsx.rb", "config/initializers/active_xlsx.rb"
      end
      
    end
  end
end
