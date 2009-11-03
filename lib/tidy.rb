require 'rubygems'
require 'mechanize'
require 'string'

def tidy_html(html) 
  agent = WWW::Mechanize.new
  page = agent.get('http://infohound.net/tidy')
  tidy_form = page.form('tidy')
  tidy_form._html = html
  page = agent.submit(tidy_form)

  require 'htmlentities'
  coder = HTMLEntities.new

  res = page.search("textarea")
  result_doc = coder.decode(res)

  result_doc.erase_tags!('head')

  tidy_result = nil
  if result_doc
    doc = Nokogiri::HTML.parse(result_doc)  
    doc.css('body').each do |body|
      tidy_result = body.to_s
    end
  end

  tidy_result.replace_start_and_end_tag!('textarea', '')
  tidy_result.replace_start_and_end_tag!('body', '')

  # VIRKER !!!
  tidy_result.strip!
end


