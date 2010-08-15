module LoggedExceptionsHelper
  def pretty_exception_date(exception)
    if Date.today == exception.created_at.to_date
      if exception.created_at > Time.now - 4.hours
        "#{time_ago_in_words(exception.created_at).gsub(/about /,"~ ")} ago"
      else
        "Today, #{exception.created_at.strftime(Time::DATE_FORMATS[:exc_time])}"
      end
    else
      exception.created_at.strftime(Time::DATE_FORMATS[:exc_date])
    end
  end
  
  def filtered?
    [:query, :date_ranges_filter, :exception_names_filter, :controller_actions_filter].any? { |p| params[p] }
  end

  def pagination_remote_links(collection)
    will_paginate collection, 
      :renderer   => 'LoggedExceptionsHelper::PaginationRenderer',
      #:previous_label => '',
    #:next_label => '',
    :container  => false
  end
  
  def listify(text)
    list_items = text.scan(/^\s*\* (.+)/).map {|match| content_tag(:li, match.first) }
    content_tag(:ul, list_items)
  end

  # http://github.com/mislav/will_paginate/blob/rails3/lib/will_paginate/view_helpers/link_renderer.rb
  class PaginationRenderer < WillPaginate::ViewHelpers::LinkRenderer

    def page_number(page)
      unless page == current_page
        link(page, page, :data_remote => true, :onclick => "ExceptionLogger.setPage(#{page});return false;", :rel => rel_value(page))
      else
        tag(:em, page)
      end
    end

    def previous_or_next_page(page, text, classname)
      if page
        link(text, page, :data_remote => true, :onclick => "ExceptionLogger.setPage(#{page});return false;", :class => classname)
      else
        tag(:span, text, :class => classname + ' disabled')
      end
    end

  end
end
