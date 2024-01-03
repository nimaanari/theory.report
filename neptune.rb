# encoding: utf-8

require 'pluto'
require 'nokogiri'
require 'uri'

def globalize_imgs(src, base_url)
    begin
        doc = Nokogiri::HTML(src)
        doc.xpath('//img/@src').each do |node|
            node.value = URI(base_url).merge(node.value).to_s
        end
        return doc.to_s
    rescue
        return src
    end
end

def quote_dc_creators(src)
    begin
        doc = Nokogiri::XML(src)
        doc.xpath('//dc:creator').each do |node|
            node.content = node.children.select{|child| !child.text?}.map{|child| child.to_s}.join(', ')
        end
        return doc.to_s
    rescue
        return src
    end
end

module Pluto
class FeedFetcherCondGetWithCache
    alias_method :old_fetch, :fetch
    def fetch(feed_rec)
        text = old_fetch(feed_rec)
        if feed_rec.location == 'arxiv-rss' then
            text = quote_dc_creators(text)
        end
        return text
    end
end
module Model
class Feed < ActiveRecord::Base
    alias_method :old_deep_update_from_struct!, :deep_update_from_struct!
    def deep_update_from_struct!(data)
        if self.location == 'arxiv-api' then
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
        elsif self.location == 'arxiv-rss' then
            data.items = data.items.select {|item| item.id.end_with?('v1')}
            date = data.published
            data.items.each do |item|
                item.published = date
                item.updated = date
                item.summary = '<p class="arxiv-authors"><b>Authors:</b> ' + item.authors[0].text + '</p>' +
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
        data.items.each do |item|
            if !item.content.nil? then
                item.content = globalize_imgs(item.content, item.url)
            end
            if !item.summary.nil? then
                item.summary = globalize_imgs(item.summary, item.url)
            end
        end
        old_deep_update_from_struct!(data)
    end
end
end
end

Pluto.main if __FILE__ == $0