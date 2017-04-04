module Core
  class Account
    class SearchtermService
      def initialize(account)
        @account = account
      end

      def searchterm
        searchterms = rules_contents.join(" OR ")
        "#{searchterms} -RT"
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
