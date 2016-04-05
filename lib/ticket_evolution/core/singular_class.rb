module TicketEvolution
  module SingularClass
    def singular_class(klass = self.class)
      TicketEvolution.lookup_const!("TicketEvolution::#{(klass.is_a?(String) ? klass : klass.name).demodulize.singularize.camelize}")
    end
  end
end
