module Core
  class BannedWordDecorator < ::ApplicationDecorator
    def content
      object.content.gsub(/[aeiu]/, "*")
    end
  end
end
