class Release < ActiveRecord::Base
  belongs_to :movie
  
  validates :released_on, :presence => true
  
  validates :format,      :presence => true
end
