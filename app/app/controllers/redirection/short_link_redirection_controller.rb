# Redirection::ShortLinkRedirectionController destinates the client to the
# original url of a given token
class Redirection::ShortLinkRedirectionController < ActionController::Base
  def redirect
    short = Shortener::Short.find_by!(token: params[:token])

    raise ActiveRecord::RecordNotFound if short.expired?

    redirect_to(short.original_url, allow_other_host: true)
  end
end
