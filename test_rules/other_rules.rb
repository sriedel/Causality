[
  { :name => "uninterested",
    :activating_causes => [ ],
    :resulting_effects => [ :rapture, :sublimation ],
    :rule              => Proc.new { |cause| true }
  },
  { :name => "lethargic",
    :activating_causes => [ :gravity_wave, :universe_implosion ],
    :resulting_effects => [ ],
    :rule              => Proc.new { |cause| false }
  },
  { :name => "exceptional",
    :activating_causes => [ :gravity_wave ],
    :resulting_effects => [ :rational_thought ],
    :rule              => Proc.new { |cause| raise }
  },
]
