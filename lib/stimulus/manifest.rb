module Stimulus::Manifest
  extend self

  def generate_from(controllers_path)
    extract_controllers_from(controllers_path).collect do |controller_path|
      import_and_register_controller(controllers_path, controller_path)
    end
  end

  def import_and_register_controller(controllers_path, controller_path)
    module_path = controller_path.relative_path_from(controllers_path).to_s.remove(".js")
    controller_class_name = module_path.camelize.gsub(/::/, "__")
    tag_name = module_path.remove("_controller").gsub(/\//, "--")

    <<-JS

import #{controller_class_name} from "./#{module_path}"
application.register("#{tag_name}", #{controller_class_name})
    JS
  end

  def extract_controllers_from(directory)
    (directory.children.select { |e| e.to_s =~ /_controller.js$/ } +
      directory.children.select(&:directory?).collect { |d| extract_controllers_from(d) }
    ).flatten
  end
end