class Event < ActiveRecord::Base
	validates_presence_of :startdate, :enddate
	has_many :votes
	has_and_belongs_to_many :curryhouses
end
