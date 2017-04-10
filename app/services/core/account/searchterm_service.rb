module Core
  class Account
    class SearchtermService
      def initialize(account)
        @account = account
      end

      def rules_joined
        rules_contents.join(" OR ")
      end

      def searchterm
        "#{rules_joined} -RT"
      end

      private

      def rules_contents
        @account.rules.searchterm.allowed.map do |rule|
          rule.content
        end
      end
    end
  end
end
