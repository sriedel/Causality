[
  { :name => "always true",
    :activating_causes => [ :gravity_wave, :universe_implosion ],
    :resulting_effects => [ :Rapture, :Sublimation ],
    :rule              => Proc.new { |cause| true }
  },
  { :name => "always false",
    :activating_causes => [ :gravity_wave, :universe_implosion ],
    :resulting_effects => [ :Damnation, :Hellfire ],
    :rule              => Proc.new { |cause| false }
  },
]
