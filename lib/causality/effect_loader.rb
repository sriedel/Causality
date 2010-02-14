module Causality
  class EffectLoader
    EFFECT_FILE_GLOB = "*_effect.rb"

    def self.load_directory( directory )
      effects_in_directory( directory ).each do |effect_file|
        load_file( effect_file )
      end
    end

    def self.load_file( file )
      begin
        require file
      rescue LoadError, SyntaxError
      end
    end

    private
    def self.effects_in_directory( directory )
      Dir.glob( File.join( directory, EFFECT_FILE_GLOB ) ).select{ |f| File.file? f }
    end
  end
end
