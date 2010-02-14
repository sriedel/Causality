[
  { :name => "uninterested",
    :activating_causes => [ ],
    :resulting_effects => [ :Rapture, :Sublimation ],
    :rule              => Proc.new { |cause| true }
  },
  { :name => "duplicate rule",
    :activating_causes => [ :gravity_wave ],
    :resulting_effects => [ :Rapture ],
    :rule              => Proc.new { |cause| true }
  },
  { :name => "lethargic",
    :activating_causes => [ :gravity_wave, :universe_implosion ],
    :resulting_effects => [ ],
    :rule              => Proc.new { |cause| false }
  },
  { :name => "exceptional",
    :activating_causes => [ :gravity_wave ],
    :resulting_effects => [ :RationalThought ],
    :rule              => Proc.new { |cause| raise }
  },
]
