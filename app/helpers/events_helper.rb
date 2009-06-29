module EventsHelper

def curryhouses_for_select
	Curryhouse.find(:all, :order => 'title').collect { |c| [c.title c.id] }
end

end
