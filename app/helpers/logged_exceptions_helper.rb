module LoggedExceptionsHelper
  def pretty_exception_date(exception)
    if Date.today == exception.created_at.to_date
      if exception.created_at > Time.now - 4.hours
        "#{time_ago_in_words(exception.created_at).gsub(/about /,"~ ")} ago"
      else
        "Today, #{exception.created_at.strftime("%l:%M %p")}"
      end
    else
      exception.created_at.strftime("%b %d, %Y")
    end
  end
  
  def filtered?
    [:query, :date_ranges_filter, :exception_names_filter, :controller_actions_filter].any? { |p| params[p] }
  end

  def pagination_remote_links(collection)
    will_paginate collection, 
      :renderer   => 'LoggedExceptionsHelper::PaginationRenderer',
      :previous_label => '',
      :next_label => '',
      :container  => false
  end
  
  def listify(text)
    list_items = text.scan(/^\s*\* (.+)/).map {|match| content_tag(:li, match.first) }
    content_tag(:ul, list_items)
  end

  class PaginationRenderer < WillPaginate::LinkRenderer
    def page_link_or_span(page, span_class = 'current', text = nil)
      text ||= page.to_s
      if page and page != current_page
        @template.link_to_function text, "ExceptionLogger.setPage(#{page})"
      else
        @template.content_tag :span, text, :class => span_class
      end
    end
  end
end
