class Curryhouse < ActiveRecord::Base
	validates_presence_of :title, :description, :postcode
end
