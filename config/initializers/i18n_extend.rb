module Mailing
  module I18n
    #----------------------------------------------------------------------------
    def t(*args)
      if args.size == 1
        super(args.first, :default => args.first.to_s)
      elsif args.second.is_a?(Hash)
        super(*args)
      elsif args.second.is_a?(Fixnum)
        super(args.first, :count => args.second)
      else
        super(args.first, :value => args.second)
      end
    end
  end
end

ActionView::Base.send(:include, Mailing::I18n)
ActionController::Base.send(:include, Mailing::I18n)

