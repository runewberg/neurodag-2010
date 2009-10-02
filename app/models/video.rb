class Video < ActiveRecord::Base
  belongs_to :page
  belongs_to :album
  # validates_url_format_of :url,:allow_nil => true, :message => 'is not a valid url'
  
  validates_numericality_of :width, :height
  validates_presence_of :name
  validates_inclusion_of :width, :in => 100..500
  validates_inclusion_of :height, :in => 100..500
end
