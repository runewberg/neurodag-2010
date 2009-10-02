module Prawn
  module Format
    module Instructions
      class Text < Base
        def initialize(state, text, options={})
          super(state)
          @text = text
          @break = options.key?(:break) ? options[:break] : text.index(/[-\xE2\x80\x94\s]/)
          @discardable = options.key?(:discardable) ? options[:discardable] : text.index(/\s/)
          @text = state.font.normalize_encoding(@text) if options.fetch(:normalize, true)
        end
      end
    end
  end
end
