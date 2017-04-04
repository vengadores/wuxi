module Core
  class Activity
    include Mongoid::Document
    include Mongoid::Timestamps
    extend Enumerize

    field :subject_id, type: BSON::ObjectId
    field :subject_type, type: String
    field :action, type: String
    field :predicate, type: Hash
    field :whodunit_id, type: BSON::ObjectId

    index({ action: 1 })
    index({ subject_id: 1, subject_type: 1 })

    validates :subject_id,
              :subject_type,
              :action,
              presence: true

    enumerize :action,
              in: [
                :external_user_status_update,
                :external_user_exceeded_throttle,
                :blacklist_user_banned_word_usage
              ]

    scope :latest, -> { order(created_at: :desc) }

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
