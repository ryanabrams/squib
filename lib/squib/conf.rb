require 'squib'
require 'forwardable'

module Squib
  # @api private
  class Conf

    DEFAULTS = {
      :antialias     => 'best',
      :backend       => 'memory',
      :count_format  => SYSTEM_DEFAULTS[:count_format],
      :custom_colors => {},
      :dir           => SYSTEM_DEFAULTS[:dir],
      :dpi           => 300,
      :hint          => :none,
      :img_dir       => '.',
      :progress_bar  => false,
      :ldquote       => "\u201C", # UTF8 chars
      :rdquote       => "\u201D",
      :lsquote       => "\u2018",
      :rsquote       => "\u2019",
      :em_dash       => "\u2014",
      :en_dash       => "\u2013",
      :ellipsis      => "\u2026",
      :smart_quotes  => true,
      :text_hint     => 'off',
    }

    #Translate the hints to the methods.
    ANTIALIAS_OPTS = {
      nil        => 'subpixel',
      'best'     => 'subpixel',
      'good'     => 'gray',
      'fast'     => 'gray',
      'gray'     => 'gray',
      'subpixel' => 'subpixel'
    }

    def initialize(config_hash = DEFAULTS)
      @config_hash = config_hash
      normalize_antialias
    end

    # Delegate [] to our hash
    # @api private
    def [](key)
      @config_hash[key]
    end

    # Load the configuration file, if exists, overriding hardcoded defaults
    # @api private
    def self.load(file)
      yaml = {}
      if File.exists? file
        Squib::logger.info { "  using config: #{file}" }
        yaml = YAML.load_file(file)
      end
      Conf.new(DEFAULTS.merge(yaml))
    end

    private

    def normalize_antialias
      @config_hash[:antialias] = ANTIALIAS_OPTS[@config_hash[:antialias].downcase.strip]
    end


  end
end