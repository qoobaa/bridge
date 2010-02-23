module Bridge
  module Contract
    def self.contracts_compare(first, second)
      CONTRACTS.index(first) <=> CONTRACTS.index(second)
    end

    def self.contract?(contract)
      CONTRACTS.include?(value)
    end

    def self.pass?(value)
      value == PASS
    end

    def self.double?(value)
      value == DOUBLE
    end

    def self.redouble?(value)
      value == REDOUBLE
    end
  end
end
