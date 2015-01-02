module Squib
  class Deck

    # Saves the given range of cards to either PNG or PDF
    #
    # @option opts [Enumerable] range (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts [String] dir (_output) the directory for the output to be sent to. Will be created if it doesn't exist.
    # @option opts [Symbol] format (:png)  the format that this will be rendered too. Options `:pdf, :png`. Array of both is allowed: `[:pdf, :png]`
    # @option opts [String] prefix (card_) the prefix of the file name to be printed
    # @option opts [Boolean] rotate (false) PNG saving only. If true, the saved cards will be rotated 90 degrees clockwise. Intended to rendering landscape instead of portrait.
    # @return self
    # @api public
    def save(opts = {})
      opts = needs(opts, [:range, :creatable_dir, :formats, :prefix, :rotate])
      save_png(opts) if opts[:format].include? :png
      save_pdf(opts) if opts[:format].include? :pdf
      self
    end

    # Saves the given range of cards to a PNG
    #
    # @example
    #   save range: 1..8, dir: '_pnp', prefix: 'bw_'
    #
    # @option opts [Enumerable] range (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts [String] dir (_output) the directory for the output to be sent to. Will be created if it doesn't exist.
    # @option opts [String] prefix (card_) the prefix of the file name to be printed.
    # @option opts [Boolean, :clockwise, :counterclockwise] rotate (false) if true, the saved cards will be rotated 90 degrees clockwise. Or, rotate by the number of radians. Intended to rendering landscape instead of portrait.
    # @return [nil] Returns nothing
    # @api public
    def save_png(opts = {})
      opts = needs(opts,[:range, :creatable_dir, :prefix, :rotate])
      @progress_bar.start("Saving PNGs to #{opts[:dir]}/#{opts[:prefix]}*", @cards.size) do |bar|
        opts[:range].each do |i|
          @cards[i].save_png(i, opts[:dir], opts[:prefix], opts[:rotate], opts[:angle])
          bar.increment
        end
      end
    end

    # Renders a range of files in a showcase as if they are sitting on a reflective surface
    # See {file:samples/showcase.rb} for full example
    #
    # @example
    #   showcase file: 'showcase_output.png', trim: 78, trim_radius: 32
    #
    # @option opts [Enumerable, :all] range (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts [Fixnum] trim (0) the margin around the card to trim before putting into the showcase
    # @option opts [Fixnum] trim_radius (0) the rounded rectangle radius around the card to trim before putting into the showcase
    # @option opts [String] dir (_output) the directory for the output to be sent to. Will be created if it doesn't exist.
    def showcase(opts = {})
      opts = needs(opts,[:range, :trim, :trim_radius, :creatable_dir, :file_to_save])
      render_showcase(opts[:range], opts[:trim], opts[:trim_radius], opts[:dir], opts[:file])
    end

  end
end
