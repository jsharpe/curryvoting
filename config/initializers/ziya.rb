require 'ziya'

Ziya.initialize(
	:logger => RAILS_DEFAULT_LOGGER,
	:themes_dir => File.join( File.dirname(__FILE__), %w[.. .. public charts themes])
)
