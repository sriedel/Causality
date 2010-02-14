module Causality
  class RuleLoader
    RULE_FILE_GLOB = "*_rules.rb"

    def self.load_directory( directory )
      rules = []
      
      rule_files_in_directory( directory ).each do |rule_file|
        next unless File.file? rule_file
        begin
          files_rule_array = extract_rules_array( rule_file )
          rules += create_rules( files_rule_array )
        rescue
        end
        
      end
      rules 
    end

    private
    def self.rule_files_in_directory( path )
      Dir.glob( File.join( path, RULE_FILE_GLOB ) )
    end

    def self.extract_rules_array( file )
      eval File.read( file )
    end

    def self.create_rules( array )
      rules = []
      array.each do |file_rule|
        begin
          rules << Causality::Rule.from_hash( file_rule )
        rescue
        end
      end
      rules
    end

  end
end
