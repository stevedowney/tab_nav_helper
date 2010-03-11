class TabNavGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      directory = "public/stylesheets/tab_nav"
      m.directory directory
      template_dir = File.dirname(__FILE__) + "/templates"
      Dir["#{template_dir}/#{directory}/*"].each do |absolute_path|
        relative_path = absolute_path.sub("#{template_dir}/", '')
        m.file relative_path, relative_path
      end
    end
  end
end
