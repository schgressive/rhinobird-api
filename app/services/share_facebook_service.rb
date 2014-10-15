class ShareFacebookService < Struct.new(:user, :stream)

  def run
    if stream.thumbnail.exists?
      post_to_facebook unless already_posted?
    end
  end

  private

  def post_to_facebook
    graph = Koala::Facebook::API.new(user.fb_token)

    post = graph.put_wall_post(caption, {
      name: "RhinobirdTv",
      link: stream.full_stream_url,
      picture: stream.thumbnail.url(:medium),
      description: caption,
    })

    # Update Facebook Post Id
    stream.update_column("fb_id", post["id"])

  rescue Koala::KoalaError => e
    Rails.logger.info "Couldn't post on facebook: #{e.message}"
  end

  def already_posted?
    stream.fb_id.present?
  end

  def caption
    @caption ||= stream.caption.present? ? stream.caption : "Checkout my livestream"
  end

end
