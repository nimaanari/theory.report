# encoding: utf-8

require 'pluto'

module Pluto
module Model
class Feed < ActiveRecord::Base
    alias_method :old_fix_dates, :fix_dates
    ARXIV_UPDATE_RE = %r{\([^(]*UPDATED\)\z}
    TITLE_RE = %r{(.*)\. \([^(]*\)\z}
    def fix_dates(data)
        puts self.inspect
        old_fix_dates(data)
        if self.location == 'arxiv' then
            date = DateTime.parse(self.http_last_modified)
            data.items = data.items.select {|item| !ARXIV_UPDATE_RE.match?(item.title)}
            data.items.each do |item|
                if item.updated.nil? &&
                   item.published.nil?
                   item.published_local = date
                   item.published = date
                end
                if TITLE_RE.match?(item.title) then
                    item.title = TITLE_RE.match(item.title)[1]
                end
                item.summary = '<p><b>Authors:</b> ' + item.authors[0].text + '</p>' +
                               item.summary
            end
        end
    end
end
end
end

Pluto.main if __FILE__ == $0