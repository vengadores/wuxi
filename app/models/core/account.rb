module Core
  class Account
    include Mongoid::Document
    field :name, type: String
    validates :name,
              uniqueness: true
    has_many :rules, class_name: "Core::Rule"
    accepts_nested_attributes_for :rules, allow_destroy: true
  end
end
