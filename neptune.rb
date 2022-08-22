# encoding: utf-8

require 'pluto'

module Pluto
module Model
class Feed < ActiveRecord::Base
    alias_method :old_deep_update_from_struct!, :deep_update_from_struct!
    ARXIV_UPDATE_RE = %r{\([^\]\(]*\].+\)\z}
    TITLE_RE = %r{(.*)\. \([^\(]*\)\z}
    def deep_update_from_struct!(data)
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
                item.summary = '<p class="arxiv-authors"><b>Authors:</b> ' + item.authors[0].text + '</p>' +
                               item.summary
            end
            puts data.items.inspect
        else
            data.items.each do |item|
                if !item.authors.nil? && !item.authors.empty? then
                    authors = item.authors.join(", ")
                    if !item.content.nil? then
                        item.content = item.content + '<p class="authors">By '+authors+'</p>'
                    elsif !item.summary.nil? then
                        item.summary = item.summary + '<p class="authors">By '+authors+'</p>'
                    end
                end
                item.updated = item.published
            end
        end
        old_deep_update_from_struct!(data)
    end
end
end
end

Pluto.main if __FILE__ == $0