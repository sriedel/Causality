module Causality
  class RuleLoader
    RULE_FILE_GLOB = "*_rules.rb"

    def self.load_directory( directory )
      rule_files_in_directory( directory ).select{ |f| File.file? f }.  
                                           collect { |file| load_file file }.
                                           flatten.
                                           uniq
    end

    def self.load_file( file )
      create_rules( extract_rules_array( file ) ) rescue []
    end

    private
    def self.rule_files_in_directory( path )
      Dir.glob( File.join( path, RULE_FILE_GLOB ) )
    end

    def self.extract_rules_array( file )
      eval File.read( file )
    end

    def self.create_rules( array )
      array.collect { |file_rule| create_rule( file_rule ) }.compact
    end

    def self.create_rule( hash )
      Causality::Rule.from_hash( hash ) rescue nil
    end

  end
end
