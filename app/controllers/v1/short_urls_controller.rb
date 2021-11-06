class V1::ShortUrlsController < ApplicationController
  skip_before_action :require_user, only: [:index, :create, :visited_link]
  before_action :find_short_url, except: [:index, :create, :visited_link, :top_100]
  before_action :access_by_user_or_key, except: :visited_link

  def index
    pagy, short_urls = pagy(ShortUrl.url_for(@user))

    render json: { 
                    data: short_urls, current_page: pagy.page,
                    total_pages: pagy.pages,
                 }, status: :ok
  end

  def update
    if @short_url.update(url: params[:url])
      render json: { message: I18n.t('responce_message.updated', type: 'ShortUrl'), data: @short_url }, status: :ok
    else
      render json: { message: @short_url.errors.full_messages }, status: :bad_request
    end
  end

  def create
    short_url = ShortUrl.new(url: params[:url], user: @user)
    if short_url.save
      link = "#{ShortUrl::HOST}/#{short_url.code}" 
      render json: { message: I18n.t('responce_message.created', type: 'ShortUrl'), link: link }, status: :created
    else
      render json: { message: short_url.errors.full_messages }, status: :bad_request
    end
  end

  def destroy
    @short_url.destroy
    render json: { message: I18n.t('responce_message.destroyed', type: 'ShortUrl') }, status: :ok
  end

  def visited_link
    short_url = ShortUrl.find_by(code: params[:code])
    
    if short_url
      ShortUrl.increment_counter(:clicked_count, short_url.id)
      redirect_to short_url.url, status: :moved_permanently
    else
      render json: { message: I18n.t('responce_message.not_found', type: 'ShortUrl') }, status: :bad_request 
    end
  end

  def top_100
    pagy, short_urls = pagy(ShortUrl.top_100_for(@user))

    render json: { data: short_urls, current_page: pagy.page, total_pages: pagy.pages }, status: :ok
  end

  private

  def find_short_url
    @short_url = ShortUrl.find_by(id: params[:id])
    render json: { message: I18n.t('responce_message.not_found', type: 'ShortUrl') }, status: :bad_request unless @short_url
  end

  def access_by_user_or_key
    @user = current_user || user_access_by_key
    render json: { message: I18n.t('responce_message.please_login', type: 'ShortUrl') }, status: :unauthorized unless @user
  end
end
