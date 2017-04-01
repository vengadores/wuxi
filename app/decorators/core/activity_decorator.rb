module Core
  class ActivityDecorator < ::ApplicationDecorator
    def whodunit_user_image
      if whodunit_user.present?
        whodunit_user.info["image"]
      else
        "/images/rails.png"
      end
    end

    def whodunit_user_name
      if whodunit_user.present?
        whodunit_user.nickname
      else
        "wuxi"
      end
    end

    private

    def whodunit_user
      @whodunit_user ||= Admin::User.find(object.whodunit_id) if object.whodunit_id.present?
    end
  end
end
