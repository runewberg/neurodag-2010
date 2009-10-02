require 'prawn'
pdf.tags :h1 => { :font_size => "24pt", :font_weight => :bold, :text_decoration => :underline,:align => :justify }, 
         :h2 => { :font_size => "16pt", :font_style => :bold },
         :h3 => { :font_size => "14pt", :font_style => :bold, :text_decoration => :underline },
         :title => { :font_size => "24pt", :font_style => :bold }

pdf.tags[:indent] = { :width => "7em" }
pdf.tags[:indent_h2]={:width => "16em"}
pdf.tags[:justify] = { :align => :justify }

options = {:line_height => 12, :font_size => "1em", :table_font_size => 8, :table_line_height => 23, :start_page_ypos => 24, :table_default_cell_width => 60}  

# block_tags - add BREAK after rendering text!
parse_options = {:erase_tags => ['legend'], :strip_tags => ['dl', 'dd', 'dt', 'dfn'], :block_tags => ['title', 'h1', 'h2', 'h3'], :strip_h_tags => 'h4+'}

options[:parse_options] = parse_options

html = render :partial => 'pdf_posters'

pdf.font "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"

# use default render options
Prawn::Assist::Generate.pdf(pdf, html)
