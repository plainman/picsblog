module ApplicationHelper

  def german_datetime(date_time)
    date_time.strftime("%d.%m.%Y, %H:%M Uhr")
  end

end
