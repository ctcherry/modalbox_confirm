require File.join(File.dirname(__FILE__), 'lib', 'modalbox_helpers')
ActionView::Helpers::AssetTagHelper::register_javascript_include_default('modalbox')
I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'lib', 'locale', '*.{rb,yml}')]