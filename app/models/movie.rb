class Movie < ActiveRecord::Base
  attr_accessible :title, :description, :rating, :lock_version
  
  validates :title, :presence => true,
                    :length => { :within => 1..100 }
end
