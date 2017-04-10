module Admin
  class ExternalPostsController < BaseController
    def repost
      scope = Core::ExternalPost.with_status(:analysed)
      external_post = scope.find(params[:id])
      external_post.update!(
        status: :will_repost,
        manually_reposted: true
      )
      redirect_to admin_account_path(
        params[:account_id],
        posts_status: :will_repost
      )
    end
  end
end
