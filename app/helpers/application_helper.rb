module ApplicationHelper

  def nav_active(path)
    "active" if current_page?(path)
  end

  def stamp_progress_width(current_stamps, max_stamps)
    return 0 if max_stamps.to_i == 0

    percent = (current_stamps.to_f / max_stamps.to_f) * 100
    percent.clamp(0, 100).round
  end

  def friendly_time(time)
    return "" unless time
  
    if time.today?
      "Today, #{time.strftime('%-I:%M %p')}"
    else
      time.strftime('%b %d, %-I:%M %p')
    end
  end
  
end
