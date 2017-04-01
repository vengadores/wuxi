class Core::BannedWord
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String

  index({ content: 1 })

  validates :content,
            presence: true,
            uniqueness: true

  scope :ordered, ->{ order(content: :asc) }

  def content=(new_content)
    ##
    # force downcase
    super(new_content.try(:downcase))
  end
end
