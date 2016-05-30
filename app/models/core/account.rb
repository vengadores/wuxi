module Core
  class Account
    include Mongoid::Document

    field :name, type: String

    validates :name,
              uniqueness: true

    begin :relationships
      has_many :rules,
               class_name: "Core::Rule"
      has_many :external_providers,
               class_name: "Core::ExternalProvider"
    end

    begin :nested_attributes
      accepts_nested_attributes_for :rules,
                                    allow_destroy: true
      accepts_nested_attributes_for :external_providers,
                                    allow_destroy: true
    end
  end
end
