class Vote < ActiveRecord::Base
	belongs_to :event
	has_and_belongs_to_many :curryhouse
	serialize :avail
end
