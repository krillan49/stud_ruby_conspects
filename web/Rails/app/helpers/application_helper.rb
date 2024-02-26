# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def prepend_flash # хэлпер для динамического отображения флэша
    turbo_stream.prepend 'flash', partial: 'shared/flash'
  end

  def pagination(obj)
    # rubocop:disable Rails/OutputSafety
    raw(pagy_bootstrap_nav(obj)) if obj.pages > 1
    # rubocop:enable Rails/OutputSafety
  end

  def nav_tab(title, url, options = {})
    current_page = options.delete :current_page
    css_class = current_page == title ? 'text-secondary' : 'text-white'
    options[:class] = options[:class] ? "#{options[:class]} #{css_class}" : css_class
    link_to title, url, options
  end

  def currently_at(current_page = '')
    render partial: 'shared/menu', locals: { current_page: current_page }
  end

  def full_title(page_title = '')
    base_title = 'AskIt'
    page_title.present? ? "#{page_title} | #{base_title}" : base_title
  end
end













# 
