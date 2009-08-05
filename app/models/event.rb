class Event < ActiveRecord::Base
	validates_presence_of :startdate, :enddate
	has_many :votes
	has_and_belongs_to_many :curryhouses

	def dates
		require 'date'
	        return (Date.parse(startdate.to_s)..Date.parse(enddate.to_s)).to_a
	end

end
