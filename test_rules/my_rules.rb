[
  { :name => "always true",
    :activating_causes => [ :gravity_wave, :universe_implosion ],
    :resulting_effects => [ :rapture, :sublimation ],
    :rule              => Proc.new { |cause| true }
  },
  { :name => "always false",
    :activating_causes => [ :gravity_wave, :universe_implosion ],
    :resulting_effects => [ :damnation, :hellfire ],
    :rule              => Proc.new { |cause| false }
  },
]
