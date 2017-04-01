module Admin
  class BannedWordsController < BaseController
    before_action :find_banned_word, only: [:edit, :update, :destroy]

    def index
      @banned_words = Core::BannedWord.ordered
    end

    def new
      @banned_word = Core::BannedWord.new
    end

    def create
      @banned_word = Core::BannedWord.new(banned_word_params)
      if @banned_word.save
        redirect_to action: :index
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @banned_word.update(banned_word_params)
        redirect_to action: :index
      else
        render :edit
      end
    end

    def destroy
      @banned_word.destroy
      redirect_to action: :index
    end

    private

    def find_banned_word
      @banned_word = Core::BannedWord.find params[:id]
    end

    def banned_word_params
      params.require(
        :banned_word
      ).permit(
        :content
      )
    end
  end
end
