#require 'tzinfo'
require 'will_paginate/view_helpers/base'
require 'will_paginate/view_helpers/link_renderer'

helpers do
  def strip_tags(str, *tags)
    match = tags.join("|")
    str.gsub(/<\/?(#{match})(\s+[^>]*|\s*)>/, "")
  end

#  def time_to_local(time)
#    tz = TZInfo::Timezone.get('Europe/Stockholm')
#    tz.utc_to_local(time.utc)
#  end
end

helpers WillPaginate::ViewHelpers::Base
WillPaginate::ViewHelpers::LinkRenderer.class_eval do
  protected
  def url(page)
    url = @template.request.url
    if page == 1
      # strip out page param and trailing ? if it exists
      url.gsub(/page=[0-9]+/, '').gsub(/\?$/, '')
    else
      if url =~ /page=[0-9]+/
        url.gsub(/page=[0-9]+/, "page=#{page}")
      else
        url + "?page=#{page}"
      end      
    end
  end
end

