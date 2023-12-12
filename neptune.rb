# encoding: utf-8

require 'pluto'

module Pluto
module Model
class Feed < ActiveRecord::Base
    alias_method :old_deep_update_from_struct!, :deep_update_from_struct!
    def deep_update_from_struct!(data)
        if self.location == 'arxiv' then
            data.items = data.items.select {|item| item.id.end_with?('v1')}
            data.items.each do |item|
                # convert to eastern time
                date = item.published.in_time_zone('Eastern Time (US & Canada)')
                # if time is before 2pm, then add a day
                if date.hour >= 14 then
                    date = date + 1.day
                end
                date = date.change(hour: 20, min: 0, sec: 0)
                if date.wday == 0 then
                    date = date + 1.day
                elsif date.wday == 5 then
                    date = date + 2.day
                elsif date.wday == 6 then
                    date = date + 2.day
                end
                # convert back to UTC
                date = date.in_time_zone('UTC')
                item.published = date
                item.updated = date
                item.published_local = date
                item.summary = '<p class="arxiv-authors"><b>Authors:</b> ' + item.authors.map{|author| '<a href="https://dblp.uni-trier.de/search?q='+CGI.escape(author.to_s)+'">'+author.to_s+'</a>'}.join(", ") + '</p>' +
                               item.summary
            end
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