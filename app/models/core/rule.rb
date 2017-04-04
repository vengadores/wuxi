class Core::Rule
  include Mongoid::Document
  include Mongoid::Timestamps

  KINDS = %w(
    language
    location
    searchterm
  ).freeze

  field :kind, type: String
  field :content, type: String
  field :allowed, type: Boolean, default: false
  field :can_mention, type: Boolean
  field :case_sensitive, type: Boolean

  index({ kind: 1 })
  index({ allowed: 1 })

  validates :kind, presence: true,
                   inclusion: { in: KINDS }

  belongs_to :account

  scope :allowed, -> { where(allowed: true) }
  scope :non_allowed, -> { where(allowed: false) }
  scope :searchterm, -> { where(kind: "searchterm") }
  scope :language, -> { where(kind: "language") }

  def is_searchterm?
    kind == "searchterm"
  end
end
