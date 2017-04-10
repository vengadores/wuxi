module Brain
  class ScheduledAnalysis
    include Mongoid::Document
    include Mongoid::Timestamps
    extend Enumerize

    field :subject_id, type: BSON::ObjectId
    field :subject_type, type: String
    field :status, type: String
    field :lang, type: String

    index({ subject_id: 1, subject_type: 1 })
    index({ status: 1 })

    validates :subject_id,
              :subject_type,
              :status,
              presence: true

    enumerize :status,
              in: [
                :new,
                :done
              ],
              default: :new

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
