module Brain
  class ExternalAnalysis
    include Mongoid::Document
    include Mongoid::Timestamps
    extend Enumerize

    field :subject_id, type: BSON::ObjectId
    field :subject_type, type: String
    field :provider, type: String
    field :response, type: Hash

    index({ subject_id: 1, subject_type: 1 })
    index({ provider: 1 })

    validates :subject_id,
              :subject_type,
              :provider,
              presence: true

    enumerize :provider,
              in: [
                :bitext
              ]

    def subject=(new_subject)
      self.subject_id = new_subject.id
      self.subject_type = new_subject.class.name
    end

    def subject
      @subject ||= if subject_id && subject_type
        subject_type.constantize.find(subject_id)
      end
    end
  end
end
