module TicketEvolution
  class Base
    def method_missing(method, *args)
      method_const_name = method.to_s.camelize

      const =
        TicketEvolution.lookup_const("#{self.class.name}::#{method_const_name}") ||
          TicketEvolution.lookup_const("TicketEvolution::#{method_const_name}")

      const ? const.new(:parent => self) : super
    end
  end
end
