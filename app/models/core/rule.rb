class Core::Rule
  include Mongoid::Document
  KINDS = %w(
    language
    location
    searchterm
  ).freeze

  field :kind, type: String
  field :content, type: String
  field :allowed, type: Boolean
  field :can_mention, type: Boolean

  validates :kind, presence: true,
                   inclusion: { in: KINDS }

  belongs_to :account

  def is_searchterm?
    kind == "searchterm"
  end
end
