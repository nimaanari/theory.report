# encoding: utf-8

require 'pluto'
require 'nokogiri'
require 'uri'
require 'i18n'

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

# map \'o to ó or \'a to á or ...
def replace_latex_accents(s)
    'Ä ä B̈ b̈ C̈ c̈ Ë ë Ḧ ḧ Ï ï K̈ k̈ M̈ m̈ N̈ n̈ Ö ö P̈ p̈ Q̈ q̈ S̈ s̈ T̈ ẗ Ü ü V̈ v̈ Ẅ ẅ Ẍ ẍ Ÿ ÿ Z̈ z̈'.split(' ').zip(
    'A a B b C c E e H h I i K k M m N n O o P p Q q S s T t U u V v W w X x Y y Z z'.split(' ')).each{|c, r|
        s = s.gsub('\\"'+r, c)
    }
    'Á á B́ b́ Ć ć D́ d́ É é F́ f́ Ǵ ǵ H́ h́ Í í J́ ȷ́ Ḱ ḱ Ĺ ĺ Ḿ ḿ Ń ń Ó ó Ṕ ṕ Q́ q́ Ŕ ŕ Ś ś T́ t́ Ú ú V́ v́ Ẃ ẃ X́ x́ Ý ý Ź ź'.split(' ').zip(
    'A a B b C c D d E e F f G g H h I i J j K k L l M m N n O o P p Q q R r S s T t U u V v W w X x Y y Z z'.split(' ')).each{|c, r|
        s = s.gsub('\\\''+r, c)
    }
    'A̋ a̋ E̋ e̋ I̋ i̋ M̋ m̋ Ő ő Ű ű'.split(' ').zip(
    'A a E e I i M m O o U u'.split(' ')).each{|c, r|
        s = s.gsub('\\H'+r, c)
    }
    'À à Æ̀ æ̀ È è H̀ h̀ Ì ì K̀ k̀ M̀ m̀ Ǹ ǹ Ò ò R̀ r̀ S̀ s̀ T̀ t̀ Ù ù V̀ v̀ Ẁ ẁ X̀ x̀ Ỳ ỳ Z̀ z̀'.split(' ').zip(
    'A a Æ æ E e H h I i K k M m N n O o R r S s T t U u V v W w X x Y y Z z'.split(' ')).each{|c, r|
        s = s.gsub('\\`'+r, c)
    }
    'Â â B̂ b̂ Ĉ ĉ D̂ d̂ Ê ê Ĝ ĝ Ĥ ĥ Î î Ĵ ĵ K̂ k̂ L̂ l̂ M̂ m̂ N̂ n̂ Ô ô R̂ r̂ Ŝ ŝ T̂ t̂ Û û V̂ v̂ Ŵ ŵ X̂ x̂ Ŷ ŷ Ẑ ẑ'.split(' ').zip(
    'A a B b C c D d E e G g H h I i J j K k L l M m N n O o R r S s T t U u V v W w X x Y y Z z'.split(' ')).each{|c, r|
        s = s.gsub('\\^'+r, c)
    }
    'Ǎ ǎ B̌ b̌ Č č Ď ď Ě ě F̌ f̌ Ǧ ǧ Ȟ ȟ Ǐ ǐ J̌ ǰ Ǩ ǩ Ľ ľ M̌ m̌ Ň ň Ǒ ǒ P̌ p̌ Q̌ q̌ Ř ř Š š Ť ť Ǔ ǔ V̌ v̌ W̌ w̌ X̌ x̌ Y̌ y̌ Ž ž'.split(' ').zip(
    'A a B b C c D d E e F f G g H h I i J j K k L l M m N n O o P p Q q R r S s T t U u V v W w X x Y y Z z'.split(' ')).each{|c, r|
        s = s.gsub('\\v'+r, c)
    }
    'Ă ă C̆ c̆ Ĕ ĕ Ğ ğ Ĭ ĭ K̆ k̆ M̆ m̆ N̆ n̆ Ŏ ŏ P̆ p̆ R̆ r̆ T̆ t̆ Ŭ ŭ V̆ v̆ X̆ x̆ Y̆ y̆'.split(' ').zip(
    'A a C c E e G g I i K k M m N n O o P p R r T t U u V v X x Y y'.split(' ')).each{|c, r|
        s = s.gsub('\\u'+r, c)
    }
    'A̧ a̧ B̧ b̧ Ç ç Ḑ ḑ Ȩ ȩ Ģ ģ Ḩ ḩ I̧ i̧ Ķ ķ Ļ ļ M̧ m̧ Ņ ņ O̧ o̧ Q̧ q̧ Ŗ ŗ Ş ş Ţ ţ U̧ u̧ X̧ x̧ Z̧ z̧'.split(' ').zip(
    'A a B b C c D d E e G g H h I i K k L l M m N n O o Q q R r S s T t U u X x Z z'.split(' ')).each{|c, r|
        s = s.gsub('\\c'+r, c)
    }
    'Ȧ ȧ Ḃ ḃ Ċ ċ Ḋ ḋ Ė ė Ḟ ḟ Ġ ġ Ḣ ḣ İ i̇̀ K̇ k̇ L̇ l̇ Ṁ ṁ Ṅ ṅ Ȯ ȯ Ṗ ṗ Q̇ q̇ Ṙ ṙ Ṡ ṡ Ṫ ṫ U̇ u̇ V̇ v̇ Ẇ ẇ Ẋ ẋ Ẏ ẏ Ż ż'.split(' ').zip(
    'A a B b C c D d E e F f G g H h I i K k L l M m N n O o P p Q q R r S s T t U u V v W w X x Y y Z z'.split(' ')).each{|c, r|
        s = s.gsub('\\.'+r, c)
    }
    'Ạ ạ Ḅ ḅ C̣ c̣ Ḍ ḍ Ẹ ẹ F̣ f̣ G̣ g̣ Ḥ ḥ Ị ị J̣ j̣ Ḳ ḳ Ḷ ḷ Ṃ ṃ Ṇ ṇ Ọ ọ P̣ p̣ Q̣ q̣ Ṛ ṛ Ṣ ṣ Ṭ ṭ Ụ ụ Ṿ ṿ Ẉ ẉ X̣ x̣ Ỵ ỵ Ẓ ẓ'.split(' ').zip(
    'A a B b C c D d E e F f G g H h I i J j K k L l M m N n O o P p Q q R r S s T t U u V v W w X x Y y Z z'.split(' ')).each{|c, r|
        s = s.gsub('\\d'+r, c)
    }
    'Ą ą Ę ę Į į Ǫ ǫ Ų ų Y̨ y̨'.split(' ').zip(
    'A a E e I i O o U u Y y'.split(' ')).each{|c, r|
        s = s.gsub('\\k'+r, c)
    }
    'Ã ã Ẽ ẽ Ĩ ĩ Ñ ñ Õ õ Ũ ũ Ṽ ṽ Ỹ ỹ'.split(' ').zip(
    'A a E e I i N n O o U u V v Y y'.split(' ')).each{|c, r|
        s = s.gsub('\\~'+r, c)
    }
    'Ā ā B̄ b̄ C̄ c̄ D̄ d̄ Ē ē Ḡ ḡ Ī ī J̄ j̄ K̄ k̄ M̄ m̄ N̄ n̄ Ō ō P̄ p̄ Q̄ q̄ R̄ r̄ S̄ s̄ T̄ t̄ Ū ū V̄ v̄ W̄ w̄ X̄ x̄ Ȳ ȳ Z̄ z̄'.split(' ').zip(
    'A a B b C c D d E e G g I i J j K k M m N n O o P p Q q R r S s T t U u V v W w X x Y y Z z'.split(' ')).each{|c, r|
        s = s.gsub('\\='+r, c)
    }
    'A̱ a̱ Ḇ ḇ C̱ c̱ Ḏ ḏ E̱ e̱ G̱ g̱ H̱ ẖ I̱ i̱ J̱ j̱ Ḵ ḵ Ḻ ḻ M̱ m̱ Ṉ ṉ O̱ o̱ P̱ p̱ Ṟ ṟ S̱ s̱ Ṯ ṯ U̱ u̱ X̱ x̱ Y̱ y̱ Ẕ ẕ'.split(' ').zip(
    'A a B b C c D d E e G g H h I i J j K k L l M m N n O o P p R r S s T t U u X x Y y Z z'.split(' ')).each{|c, r|
        s = s.gsub('\\b'+r, c)
    }
    'Å å D̊ d̊ E̊ e̊ G̊ g̊ I̊ i̊ J̊ j̊ O̊ o̊ Q̊ q̊ S̊ s̊ Ů ů V̊ v̊ W̊ ẘ X̊ x̊ Y̊ ẙ'.split(' ').zip(
    'A a d d E e G g I i J j O o Q q S s U u V v W w X x Y y'.split(' ')).each{|c, r|
        s = s.gsub('\\b'+r, c)
    }
    s = s.gsub('\\l', 'ł')
    s = s.gsub('\\L', 'Ł')
    s = s.gsub('\\o', 'ø')
    s = s.gsub('\\O', 'Ø')
    s = s.gsub('\\i', 'ı')
    s = s.gsub('\\j', 'ȷ')
    s = s.gsub('\\ss', 'ß')
    return s
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
        if self.location == 'arxiv-rss2' then
            puts data.inspect
            date = data.published
            data.items.select {|item| item.id.end_with?('v1')}
            data.items.each do |item|
                item.published = date
                item.updated = date
                # remove first line
                item.summary = item.summary.split("\n")[1..-1].join("\n")
                # remove the beginning word abstract
                item.summary = item.summary[10..-1]
                authors = item.authors[0].text.split(', ').map{|author| replace_latex_accents(author)}.map{|author| '<a href="https://dblp.uni-trier.de/search?q='+CGI.escape(author.to_s)+'">'+author.to_s+'</a>'}
                item.summary = '<p class="arxiv-authors"><b>Authors:</b> ' + authors.join(', ') + '</p>' +
                                 item.summary
            end
        elsif self.location == 'arxiv-api' then
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
            if item.published then
                if item.published > Time.now then
                    # set it to a ten days ago
                    item.published = Time.now - 10.days
                end
            end
            if item.updated then
                if item.updated > Time.now then
                    # set it to a ten days ago
                    item.updated = Time.now - 10.days
                end
            end
        end
        old_deep_update_from_struct!(data)
    end
end
end
end

Pluto.main if __FILE__ == $0