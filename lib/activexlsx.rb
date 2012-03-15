require "active_support/dependencies"

Mime::Type.register "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", :xlsx

module ActiveXlsx
  
  mattr_accessor :app_root
  
  def self.setup
    yield self
  end
  
  class Engine < Rails::Engine
    
  end
  
end

module ActiveAdmin
  
  module Views
    
    class PaginatedCollection
      
      alias_method :build_download_format_links_original, :build_download_format_links
      
      def build_download_format_links(format = [:csv, :xml, :json, :xlsx])
        if controller.respond_to? :xlsx_enabled and controller.xlsx_enabled
          build_download_format_links_original format
        else
          format = Array.new format
          format.delete :xlsx
          build_download_format_links_original format
        end
      end
      
    end
    
  end
  
  class ResourceDSL
    
    private
    
    def enable_xlsx_download!
      controller do
        
        include MethodOrProcHelper
        
        respond_to :xlsx, :only => :index
        
        alias_method :per_page_original, :per_page
        
        def per_page
          return max_xlsx_records if request.format == Mime::Type.lookup_by_extension(:xlsx)
          per_page_original
        end
        
        def max_xlsx_records
          10_000
        end
        
        def xlsx_enabled
          true
        end
        
        def xlsx_filename
          "#{resource_collection_name.to_s.gsub('_', '-')}-#{Time.now.strftime("%Y-%m-%d")}.xlsx"
        end
        
        def xlsx_worksheet_name
          resource_collection_name.to_s
        end
        
        def index(options={}, &block)
          super(options) do |format|
            block.call(format) if block
            format.html { render active_admin_template("index") }
            format.csv do
              headers["Content-Type"] = "text/csv; charset=utf-8"
              headers["Content-Disposition"] = %{attachment; filename="#{csv_filename}"}
              render active_admin_template("index")
            end
            format.xlsx do
              headers["Content-Type"] = Mime::Type.lookup_by_extension(:xlsx).to_s
              headers["Content-Disposition"] = %{attachment; filename="#{xlsx_filename}"}
              render active_admin_template("index")
            end
          end
        end
        
        alias :index! :index
        
      end
    end
  
  end
  
end