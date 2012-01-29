class Movie < ActiveRecord::Base
  has_many :releases, :dependent => :destroy
  
  attr_accessible :title, :description, :rating, :lock_version
  
  validates :title, :presence => true,
                    :length => { :within => 1..100 }
end
