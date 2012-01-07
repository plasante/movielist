class Movie < ActiveRecord::Base
  attr_accessible :title, :description, :rating
  
  validates :title, :presence => true,
                    :length => { :within => 1..100 }
end
