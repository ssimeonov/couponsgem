require 'rails/generators'

module Couponing
  class StylesheetGenerator < Rails::Generators::Base
    source_root File.expand_path('../stylesheets', __FILE__)
    
    def copy_stylesheet
      copy_file "coupons.css", "public/stylesheets/coupons.css"
    end
  
  end
end