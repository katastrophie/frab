module Public::ScheduleHelper

  def day_parts
    separators = @day.day_separators.collect { |sep| sep.time }

    starts = Array.new(separators)
    starts.unshift @day.start_date

    ends = Array.new(separators)
    ends << @day.end_date

    starts.zip(ends)
  end

  def each_timeslot(&block)
    each_minutes(@conference.timeslot_duration, &block)
  end

  def each_part_timeslot((start_time, end_time), &block)
    time = start_time
    while time < end_time
      yield time
      time = time.since(@conference.timeslot_duration.minutes)
    end
  end

  def used_rooms((start_time, end_time))
    rooms = Array.new @conference.rooms.public

    rooms.keep_if do |room|
      @events[room].any? { |event| event.start_time >= start_time and event.start_time < end_time }
    end
  end

  def track_class(event)
    if event.track
      "track-#{event.track.name.parameterize}"
    else
      "track-default"
    end
  end

  def selected(regex)
    "selected" if request.path =~ regex
  end

end
